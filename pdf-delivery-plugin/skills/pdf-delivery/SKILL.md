---
name: "pdf-delivery"
description: "Convert any markdown deliverable to a branded PDF for client delivery. Applies agency brand (header, footer, colors, fonts) from brand/brand-guide.md. Triggers on: generate PDF, make PDF, convert to PDF, branded PDF, send to client, deliver this, PDF from markdown, client deliverable, package for client, export PDF, create PDF, pdf this, make this a PDF, prepare for delivery, PDF for client."
---

# PDF Delivery Skill

You convert markdown deliverables into branded PDFs for client delivery. The PDF applies My New Agent's brand: header with company name, footer with page numbers and mynewagent.ai, agency colors, and consistent typography.

Markdown files are for internal use. Clients receive PDFs.

## Workflow

| Step | Name | What Happens |
|------|------|-------------|
| 1 | Input | Get the markdown file path |
| 2 | Brand Check | Verify brand assets exist |
| 3 | Generate | Run the conversion script |
| 4 | Confirm | Report output, offer to generate more |

---

## Step 1: Input

Get the markdown file path from the user's prompt or context.

- If the user specifies a file, use it.
- If the user says something like "PDF this" or "deliver this to the client" in the context of working on a client, check the client's deliverables directory for markdown files that should be client-facing.
- If ambiguous, ask: "Which file? Give me the path or the client slug and file name."

**Client-facing deliverables** (generate PDFs for these):
- `discovery-questionnaire.md`
- `sop-{process}.md`
- `proposal-{client-slug}.md`

**Internal only** (never generate PDFs for these):
- `internal-client-profile.md`
- `speaking-notes-{client-slug}.md`

Verify the file exists and has a `.md` extension.

---

## Step 2: Brand Check

Verify the brand guide exists at `~/my-new-agent/brand/brand-guide.md`. If it does not exist, tell the user: "The agency brand guide is not set up yet. Run the brand-voice-generator skill first to create it."

The PDF generation script will still work without the brand guide (it uses CSS for styling, not the guide), but the guide ensures brand consistency across all agency output.

---

## Step 3: Generate

Run the conversion script:

```bash
python3 ~/my-new-agent/pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py <markdown-file-path>
```

The script:
- Extracts the document title from the first `# ` heading
- Parses markdown to HTML (with table support)
- Wraps in the branded HTML template
- Applies the brand CSS (colors, fonts, page layout)
- Outputs a PDF in the same directory with the same filename but `.pdf` extension

**Questionnaires are automatically fillable.** When the input is a `discovery-questionnaire.md`, the script detects it and generates a fillable PDF with form fields that clients can type into directly in Adobe Reader, macOS Preview, Chrome, or any standard PDF viewer. The branded styling (header, footer, colors, fonts) is preserved. To force a static (non-fillable) PDF for a questionnaire, pass `--no-fillable`.

Optional: specify a custom output path:
```bash
python3 ~/my-new-agent/pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py <input.md> --output <output.pdf>
```

### Troubleshooting

| Error | Fix |
|-------|-----|
| `ModuleNotFoundError: weasyprint` | `pip install --break-system-packages weasyprint` |
| `ModuleNotFoundError: markdown_it` | `pip install --break-system-packages markdown-it-py` |
| `ModuleNotFoundError: jinja2` | `pip install --break-system-packages jinja2` |
| `ModuleNotFoundError: reportlab` | `pip install --break-system-packages reportlab` |
| Fonts look wrong | Download Inter to `brand/fonts/` or the system will use its sans-serif fallback |

---

## Step 4: Confirm

1. Report the output PDF path.
2. Check if there are other markdown deliverables in the same client directory that could be converted. List them and ask: "Want me to generate PDFs for any of these too?"
3. Remind the user: "The markdown file is your internal copy. The PDF is what goes to the client."

---

## Brand Elements Applied

The PDF template and stylesheet are at `references/pdf-template.html` and `references/pdf-style.css`. They apply:

| Element | Value |
|---------|-------|
| Header (left) | "My New Agent" |
| Header (right) | Document title (from first H1) |
| Header separator | 1px Electric Blue (#00D4FF) |
| Footer (left) | "mynewagent.ai" |
| Footer (right) | "Page X of Y" |
| H1 | 24pt bold, navy (#0F0F23), blue underline |
| H2 | 18pt bold, navy, Electric Blue left border |
| Body text | 11pt, #333, 1.5 line-height |
| Tables | Navy header row with white text, alternating gray/white rows |
| Blockquotes | Teal (#00C9A7) left border, light gray background |
| Code blocks | Dark background (#1A1A2E), white text |
| Logo | Included in header if `brand/logo.png` exists |
| Form fields (questionnaires) | Light gray fill (#FAFAFA), 1px gray border (#E0E0E0), 10pt text, multiline |

To change any of these, edit `pdf-style.css`. The Python script reads the CSS at runtime, so changes take effect immediately.

---

## Checklist

- [ ] Markdown file exists and is a client-facing deliverable
- [ ] Brand guide exists (or user was warned)
- [ ] PDF generated without errors
- [ ] If questionnaire: fillable fields work (test by typing in a field)
- [ ] Output path reported to user
- [ ] User reminded that markdown = internal, PDF = client
