"""Parse a discovery questionnaire markdown file into structured data.

Used by generate_fillable_pdf.py to create fillable PDFs with form fields.
"""

import re
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class Question:
    number: int
    text: str
    subtext: str = ""
    prefilled_answer: str = ""


@dataclass
class Section:
    title: str
    questions: list[Question] = field(default_factory=list)


@dataclass
class Questionnaire:
    title: str
    intro: str
    sections: list[Section] = field(default_factory=list)


def is_questionnaire(markdown_text: str, filename: str = "") -> bool:
    """Detect whether a markdown file is a discovery questionnaire.

    Uses filename match + content heuristics. Returns True if the file
    looks like a questionnaire (must match at least 2 of 3 signals).
    """
    signals = 0

    # Signal 1: filename
    if "discovery-questionnaire" in filename.lower():
        signals += 1

    # Signal 2: H1 starts with "Discovery Session" or "Discovery Questions"
    h1 = re.search(r"^#\s+(.+)$", markdown_text, re.MULTILINE)
    if h1 and re.match(r"Discovery (Session|Questions)", h1.group(1)):
        signals += 1

    # Signal 3: 10+ numbered questions
    numbered = re.findall(r"^\d+\.\s+", markdown_text, re.MULTILINE)
    if len(numbered) >= 10:
        signals += 1

    return signals >= 2


def parse_questionnaire(markdown_text: str) -> Questionnaire:
    """Parse questionnaire markdown into a Questionnaire dataclass."""
    lines = markdown_text.split("\n")

    title = "Untitled"
    intro_lines: list[str] = []
    sections: list[Section] = []
    current_section: Section | None = None
    current_question: Question | None = None
    answer_lines: list[str] = []
    in_intro = False

    for line in lines:
        stripped = line.strip()

        # H1 title
        h1 = re.match(r"^#\s+(.+)$", stripped)
        if h1:
            title = h1.group(1).strip()
            in_intro = True
            continue

        # Blockquote intro (lines between H1 and first H2)
        if in_intro:
            if stripped.startswith("> "):
                intro_lines.append(stripped[2:])
                continue
            elif stripped == ">" or stripped == "":
                if intro_lines:
                    intro_lines.append("")
                continue
            # Non-blockquote, non-empty line ends intro
            # Fall through to other checks

        # H2 section header
        h2 = re.match(r"^##\s+(.+)$", stripped)
        if h2:
            in_intro = False
            # Save any pending answer to previous question
            _flush_answer(current_question, answer_lines)
            answer_lines = []
            current_question = None

            current_section = Section(title=h2.group(1).strip())
            sections.append(current_section)
            continue

        # Numbered question
        q_match = re.match(r"^(\d+)\.\s+(.+)$", stripped)
        if q_match:
            in_intro = False
            # Save any pending answer to previous question
            _flush_answer(current_question, answer_lines)
            answer_lines = []

            number = int(q_match.group(1))
            raw_text = q_match.group(2).strip()

            # Strip bold markers: **text** or __text__
            text = re.sub(r"\*\*(.+?)\*\*", r"\1", raw_text)
            text = re.sub(r"__(.+?)__", r"\1", text)

            current_question = Question(number=number, text=text)
            if current_section is None:
                current_section = Section(title="")
                sections.append(current_section)
            current_section.questions.append(current_question)
            continue

        # Horizontal rule -- skip
        if re.match(r"^-{3,}$", stripped) or re.match(r"^\*{3,}$", stripped):
            continue

        # Subtext line (parenthetical right after question, starts with ()
        if current_question and stripped.startswith("(") and not current_question.subtext and not answer_lines:
            current_question.subtext = re.sub(r"\*\*(.+?)\*\*", r"\1", stripped)
            continue

        # Italic reveal note -- skip (these are for the question bank, not client-facing)
        if stripped.startswith("*Reveals:") or stripped.startswith("_Reveals:"):
            continue

        # Non-empty line after a question = potential pre-filled answer
        if current_question and stripped and not stripped.startswith("#"):
            answer_lines.append(stripped)
            continue

    # Flush final answer
    _flush_answer(current_question, answer_lines)

    intro = " ".join(line for line in intro_lines if line).strip()

    return Questionnaire(title=title, intro=intro, sections=sections)


def _flush_answer(question: Question | None, answer_lines: list[str]) -> None:
    """Assign accumulated answer lines to the question's prefilled_answer."""
    if question and answer_lines:
        text = "\n".join(answer_lines).strip()
        if text:
            question.prefilled_answer = text


def parse_file(md_path: str) -> Questionnaire:
    """Convenience: read a file and parse it."""
    path = Path(md_path).resolve()
    markdown_text = path.read_text(encoding="utf-8")
    return parse_questionnaire(markdown_text)
