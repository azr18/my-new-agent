"""Generate a fillable (AcroForm) PDF from a discovery questionnaire markdown file.

Uses ReportLab to create branded PDFs with text fields after each question.
Called automatically by generate_pdf.py when it detects a questionnaire.

Usage (standalone):
    python3 generate_fillable_pdf.py <questionnaire.md>
    python3 generate_fillable_pdf.py <questionnaire.md> --output <output.pdf>
"""

import sys
import re
from pathlib import Path

from reportlab.lib.pagesizes import letter
from reportlab.lib.units import inch

# ReportLab's base unit is points, so 1 pt = 1. Define for readability.
pt = 1
from reportlab.lib.colors import HexColor, white
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import (
    BaseDocTemplate,
    Frame,
    PageTemplate,
    Paragraph,
    Spacer,
    KeepTogether,
    Flowable,
    Image,
)
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

from parse_questionnaire import parse_file, Questionnaire

# ---------------------------------------------------------------------------
# Brand constants (from pdf-style.css)
# ---------------------------------------------------------------------------
NAVY = HexColor("#0F0F23")
ELECTRIC_BLUE = HexColor("#00D4FF")
TEAL = HexColor("#00C9A7")
BODY_COLOR = HexColor("#333333")
LIGHT_GRAY = HexColor("#F8F9FA")
FIELD_BG = HexColor("#FAFAFA")
FIELD_BORDER = HexColor("#E0E0E0")
HEADER_GRAY = HexColor("#666666")
FOOTER_GRAY = HexColor("#999999")
BORDER_GRAY = HexColor("#BBBBBB")

PAGE_W, PAGE_H = letter  # 612 x 792 points
MARGIN_TOP = 1 * inch
MARGIN_BOTTOM = 0.75 * inch
MARGIN_LEFT = 0.75 * inch
MARGIN_RIGHT = 0.75 * inch

CONTENT_W = PAGE_W - MARGIN_LEFT - MARGIN_RIGHT

# Paths
SCRIPT_DIR = Path(__file__).parent.resolve()
BRAND_DIR = SCRIPT_DIR.parents[3] / "brand"
LOGO_PATH = BRAND_DIR / "logo.png"
FONT_DIR = BRAND_DIR / "fonts"

# ---------------------------------------------------------------------------
# Font registration
# ---------------------------------------------------------------------------
FONT_REGULAR = "Helvetica"
FONT_BOLD = "Helvetica-Bold"

_inter_regular = FONT_DIR / "Inter-Regular.ttf"
_inter_bold = FONT_DIR / "Inter-Bold.ttf"
if _inter_regular.exists() and _inter_bold.exists():
    pdfmetrics.registerFont(TTFont("Inter", str(_inter_regular)))
    pdfmetrics.registerFont(TTFont("Inter-Bold", str(_inter_bold)))
    FONT_REGULAR = "Inter"
    FONT_BOLD = "Inter-Bold"

# ---------------------------------------------------------------------------
# Paragraph styles
# ---------------------------------------------------------------------------
STYLE_H1 = ParagraphStyle(
    "H1",
    fontName=FONT_BOLD,
    fontSize=24,
    leading=30,
    textColor=NAVY,
    spaceAfter=4 * pt,
)

STYLE_H2 = ParagraphStyle(
    "H2",
    fontName=FONT_BOLD,
    fontSize=18,
    leading=24,
    textColor=NAVY,
    spaceBefore=20 * pt,
    spaceAfter=10 * pt,
    leftIndent=12 * pt,
    borderPadding=(0, 0, 0, 8),
)

STYLE_INTRO = ParagraphStyle(
    "Intro",
    fontName=FONT_REGULAR,
    fontSize=11,
    leading=16.5,
    textColor=HexColor("#555555"),
    leftIndent=16 * pt,
    rightIndent=16 * pt,
    spaceBefore=4 * pt,
    spaceAfter=12 * pt,
)

STYLE_QUESTION = ParagraphStyle(
    "Question",
    fontName=FONT_REGULAR,
    fontSize=11,
    leading=16.5,
    textColor=BODY_COLOR,
)


# ---------------------------------------------------------------------------
# Custom flowables
# ---------------------------------------------------------------------------
class BlueUnderline(Flowable):
    """2px Electric Blue line spanning the full content width."""

    def __init__(self, width):
        super().__init__()
        self.width = width
        self.height = 2

    def draw(self):
        self.canv.setStrokeColor(ELECTRIC_BLUE)
        self.canv.setLineWidth(2)
        self.canv.line(0, 0, self.width, 0)


class H2Border(Flowable):
    """H2 heading with a 3px Electric Blue left border."""

    def __init__(self, text, width):
        super().__init__()
        self.text = text
        self.full_width = width
        self._para = Paragraph(text, STYLE_H2)
        pw, ph = self._para.wrap(width - 15 * pt, 1000)
        self.width = width
        self.height = ph

    def wrap(self, availWidth, availHeight):
        pw, ph = self._para.wrap(availWidth - 15 * pt, availHeight)
        self.height = ph
        return availWidth, ph

    def draw(self):
        self.canv.setStrokeColor(ELECTRIC_BLUE)
        self.canv.setLineWidth(3)
        self.canv.line(0, -2, 0, self.height + 2)
        self._para.drawOn(self.canv, 12 * pt, 0)


class IntroBlock(Flowable):
    """Blockquote with teal left border and light gray background."""

    def __init__(self, text, width):
        super().__init__()
        self.full_width = width
        self._para = Paragraph(text, STYLE_INTRO)
        pw, ph = self._para.wrap(width - 32 * pt - 3, 1000)
        self.width = width
        self.height = ph + 20 * pt

    def wrap(self, availWidth, availHeight):
        pw, ph = self._para.wrap(availWidth - 32 * pt - 3, availHeight)
        self.height = ph + 20 * pt
        return availWidth, self.height

    def draw(self):
        self.canv.setFillColor(LIGHT_GRAY)
        self.canv.rect(0, 0, self.full_width, self.height, fill=1, stroke=0)
        self.canv.setStrokeColor(TEAL)
        self.canv.setLineWidth(3)
        self.canv.line(0, 0, 0, self.height)
        self._para.drawOn(self.canv, 16 * pt + 3, 10 * pt)


class FormField(Flowable):
    """A Platypus flowable that reserves space and draws an AcroForm text field.

    acroForm.textfield() uses absolute page coordinates, but draw() runs
    in a translated canvas context. We capture the absolute position in
    drawOn() and forward it to the textfield call.
    """

    def __init__(self, field_name, width, height, default_value=""):
        super().__init__()
        self.field_name = field_name
        self.width = width
        self.height = height
        self.default_value = default_value
        self._abs_x = 0
        self._abs_y = 0

    def drawOn(self, canvas, x, y, _sW=0):
        self._abs_x = x
        self._abs_y = y
        super().drawOn(canvas, x, y, _sW)

    def draw(self):
        self.canv.acroForm.textfield(
            name=self.field_name,
            x=self._abs_x,
            y=self._abs_y,
            width=self.width,
            height=self.height,
            value=self.default_value,
            borderWidth=1,
            borderColor=FIELD_BORDER,
            fillColor=FIELD_BG,
            textColor=BODY_COLOR,
            fontSize=10,
            fontName="Helvetica",
            fieldFlags="multiline",
            forceBorder=True,
        )


# ---------------------------------------------------------------------------
# Page template with headers/footers and "Page X of Y"
# ---------------------------------------------------------------------------
class NumberedCanvas:
    """Mixin-style wrapper to get 'Page X of Y' with ReportLab.

    We monkey-patch the canvas class used by BaseDocTemplate so that
    on save() we go back and stamp the total page count.
    """

    def __init__(self, doc_title):
        self.doc_title = doc_title

    def __call__(self, canvas_class):
        title = self.doc_title

        class _Canvas(canvas_class):
            _title = title

            def __init__(self, *args, **kwargs):
                super().__init__(*args, **kwargs)
                self._pages = []

            def showPage(self):
                self._pages.append(dict(self.__dict__))
                self._startPage()

            def save(self):
                total = len(self._pages)
                for i, page_state in enumerate(self._pages):
                    self.__dict__.update(page_state)
                    self._draw_header_footer(i, total)
                    super().showPage()
                super().save()

            def _draw_header_footer(self, page_idx, total_pages):
                is_first = page_idx == 0

                if not is_first:
                    # Header left: "My New Agent"
                    self.setFont(FONT_BOLD, 9)
                    self.setFillColor(NAVY)
                    self.drawString(MARGIN_LEFT, PAGE_H - 0.6 * inch, "My New Agent")

                    # Header right: document title
                    self.setFont(FONT_REGULAR, 9)
                    self.setFillColor(HEADER_GRAY)
                    self.drawRightString(
                        PAGE_W - MARGIN_RIGHT, PAGE_H - 0.6 * inch, self._title
                    )

                    # Header separator line
                    self.setStrokeColor(ELECTRIC_BLUE)
                    self.setLineWidth(1)
                    y_line = PAGE_H - 0.65 * inch
                    self.line(MARGIN_LEFT, y_line, PAGE_W - MARGIN_RIGHT, y_line)

                # Footer left: "mynewagent.ai"
                self.setFont(FONT_REGULAR, 8)
                self.setFillColor(FOOTER_GRAY)
                y_footer = 0.45 * inch
                self.drawString(MARGIN_LEFT, y_footer, "mynewagent.ai")

                # Footer right: "Page X of Y"
                self.drawRightString(
                    PAGE_W - MARGIN_RIGHT,
                    y_footer,
                    f"Page {page_idx + 1} of {total_pages}",
                )

                # Footer separator line
                self.setStrokeColor(BORDER_GRAY)
                self.setLineWidth(1)
                y_fline = y_footer + 10
                self.line(MARGIN_LEFT, y_fline, PAGE_W - MARGIN_RIGHT, y_fline)

        return _Canvas


# ---------------------------------------------------------------------------
# Large-field heuristic
# ---------------------------------------------------------------------------
_LARGE_FIELD_PATTERNS = re.compile(
    r"walk me through|from first|every step|from the very first|"
    r"from.*trigger to|from.*contact to|from.*canvas to|"
    r"walk me through it",
    re.IGNORECASE,
)


def _field_height(question_text: str) -> float:
    """Return field height in points. Larger for process walk-through questions."""
    if _LARGE_FIELD_PATTERNS.search(question_text):
        return 120
    return 80


# ---------------------------------------------------------------------------
# Main generator
# ---------------------------------------------------------------------------
def convert_questionnaire_to_pdf(
    md_path: str, output_path: str | None = None
) -> str:
    """Generate a fillable branded PDF from a questionnaire markdown file.

    Returns the output PDF path.
    """
    md_path = Path(md_path).resolve()

    if not md_path.exists():
        print(f"Error: File not found: {md_path}")
        sys.exit(1)

    if output_path:
        out = Path(output_path).resolve()
    else:
        out = md_path.with_suffix(".pdf")

    questionnaire = parse_file(str(md_path))
    story = _build_story(questionnaire)

    # Build document
    frame = Frame(
        MARGIN_LEFT,
        MARGIN_BOTTOM,
        CONTENT_W,
        PAGE_H - MARGIN_TOP - MARGIN_BOTTOM,
        id="main",
    )
    page_tmpl = PageTemplate(id="main", frames=[frame])

    canvas_cls = NumberedCanvas(questionnaire.title)

    doc = BaseDocTemplate(
        str(out),
        pagesize=letter,
        pageTemplates=[page_tmpl],
        title=f"{questionnaire.title} - My New Agent",
        author="My New Agent",
    )

    # Build with custom canvas for header/footer/page numbers
    from reportlab.pdfgen.canvas import Canvas as _BaseCanvas

    doc.build(story, canvasmaker=canvas_cls(_BaseCanvas))

    return str(out)


def _build_story(q: Questionnaire) -> list:
    """Convert a Questionnaire into a list of ReportLab flowables."""
    story: list[Flowable] = []

    # Logo on first page
    if LOGO_PATH.exists():
        logo = Image(str(LOGO_PATH), width=CONTENT_W, height=80 * pt, kind="proportional")
        logo.hAlign = "CENTER"
        story.append(logo)
        story.append(Spacer(1, 12 * pt))

    # Title
    story.append(Paragraph(q.title, STYLE_H1))
    story.append(BlueUnderline(CONTENT_W))
    story.append(Spacer(1, 12 * pt))

    # Intro blockquote
    if q.intro:
        story.append(IntroBlock(q.intro, CONTENT_W))
        story.append(Spacer(1, 8 * pt))

    # Sections and questions
    for si, section in enumerate(q.sections):
        if section.title:
            story.append(H2Border(section.title, CONTENT_W))
            story.append(Spacer(1, 6 * pt))

        for question in section.questions:
            q_text = f"<b>{question.number}.</b>  {question.text}"
            if question.subtext:
                q_text += f"<br/><i>{question.subtext}</i>"

            q_para = Paragraph(q_text, STYLE_QUESTION)
            field_name = f"q{si}_{question.number}"
            height = _field_height(question.text)
            form_field = FormField(
                field_name=field_name,
                width=CONTENT_W,
                height=height,
                default_value=question.prefilled_answer,
            )

            block = KeepTogether([
                q_para,
                Spacer(1, 4 * pt),
                form_field,
                Spacer(1, 12 * pt),
            ])
            story.append(block)

    return story


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
def main():
    if len(sys.argv) < 2:
        print(
            "Usage: python3 generate_fillable_pdf.py <questionnaire.md> "
            "[--output <path>]"
        )
        sys.exit(1)

    md_file = sys.argv[1]
    output_file = None

    if "--output" in sys.argv:
        idx = sys.argv.index("--output")
        if idx + 1 < len(sys.argv):
            output_file = sys.argv[idx + 1]
        else:
            print("Error: --output requires a path argument")
            sys.exit(1)

    result = convert_questionnaire_to_pdf(md_file, output_file)
    print(f"Fillable PDF created: {result}")


if __name__ == "__main__":
    main()
