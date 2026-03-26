#!/usr/bin/env python3
"""Convert a markdown deliverable to a branded PDF for My New Agent.

Usage:
    python3 generate_pdf.py <markdown-file>
    python3 generate_pdf.py <markdown-file> --output <output-path>

Output:
    Same directory, same filename with .pdf extension (unless --output specified).
"""

import sys
import re
from pathlib import Path
from datetime import date

from markdown_it import MarkdownIt
from jinja2 import Template
import weasyprint

from parse_questionnaire import is_questionnaire
from generate_fillable_pdf import convert_questionnaire_to_pdf


# Paths relative to this script
SCRIPT_DIR = Path(__file__).parent.resolve()
TEMPLATE_PATH = SCRIPT_DIR / "pdf-template.html"
STYLE_PATH = SCRIPT_DIR / "pdf-style.css"

# Brand assets directory (up from skills/pdf-delivery/references/ to repo root, then brand/)
BRAND_DIR = SCRIPT_DIR.parents[3] / "brand"
LOGO_PATH = BRAND_DIR / "logo.png"


def extract_title(markdown_text: str) -> str:
    """Pull the first H1 heading from markdown, or return 'Untitled'."""
    match = re.search(r"^#\s+(.+)$", markdown_text, re.MULTILINE)
    if match:
        return match.group(1).strip()
    return "Untitled"


def strip_html_comments(html: str) -> str:
    """Remove HTML comments (like DRAFT PRICING blocks) from rendered output."""
    return re.sub(r"<!--.*?-->", "", html, flags=re.DOTALL)


def convert_markdown_to_pdf(md_path: str, output_path: str = None, fillable: bool = True) -> str:
    """Main conversion pipeline. Returns the output PDF path."""
    md_path = Path(md_path).resolve()

    if not md_path.exists():
        print(f"Error: File not found: {md_path}")
        sys.exit(1)

    if not md_path.suffix == ".md":
        print(f"Error: Expected a .md file, got: {md_path.suffix}")
        sys.exit(1)

    # Determine output path
    if output_path:
        out = Path(output_path).resolve()
    else:
        out = md_path.with_suffix(".pdf")

    # Read markdown
    markdown_text = md_path.read_text(encoding="utf-8")

    # Route questionnaires to fillable PDF generator
    if fillable and is_questionnaire(markdown_text, md_path.name):
        return convert_questionnaire_to_pdf(str(md_path), output_path)

    # Extract title
    title = extract_title(markdown_text)

    # Parse markdown to HTML with table support
    md = MarkdownIt("commonmark").enable("table")
    html_body = md.render(markdown_text)
    html_body = strip_html_comments(html_body)

    # Read template and CSS
    template_text = TEMPLATE_PATH.read_text(encoding="utf-8")
    css_text = STYLE_PATH.read_text(encoding="utf-8")

    # Check for logo
    logo_exists = LOGO_PATH.exists()
    logo_path = LOGO_PATH.as_uri() if logo_exists else ""

    # Render HTML
    template = Template(template_text)
    full_html = template.render(
        title=title,
        content=html_body,
        css=css_text,
        date=date.today().isoformat(),
        logo_exists=logo_exists,
        logo_path=logo_path,
    )

    # Generate PDF
    html_doc = weasyprint.HTML(
        string=full_html,
        base_url=str(SCRIPT_DIR),
    )
    html_doc.write_pdf(str(out))

    return str(out)


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 generate_pdf.py <markdown-file> [--output <path>] [--no-fillable]")
        sys.exit(1)

    md_file = sys.argv[1]
    output_file = None
    fillable = "--no-fillable" not in sys.argv

    if "--output" in sys.argv:
        idx = sys.argv.index("--output")
        if idx + 1 < len(sys.argv):
            output_file = sys.argv[idx + 1]
        else:
            print("Error: --output requires a path argument")
            sys.exit(1)

    result = convert_markdown_to_pdf(md_file, output_file, fillable=fillable)
    print(f"PDF created: {result}")


if __name__ == "__main__":
    main()
