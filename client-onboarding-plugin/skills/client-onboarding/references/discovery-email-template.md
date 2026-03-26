# Discovery Questionnaire Email Template

Send this email after Step 1 (Client Setup & Prep) once the discovery questionnaire and branded PDF have been generated.

## Placeholders

| Token | Source | Example |
|-------|--------|---------|
| `{FIRST_NAME}` | internal-client-profile.md, Contact | Ygal |
| `{EMAIL}` | internal-client-profile.md, Email | ygal@sevenseasfoods.com |
| `{MEETING_REFERENCE}` | Context from last conversation | "the shipment report" |
| `{FOCUS_AREAS}` | Key pain points from profile | "container tracking across your six carriers, and the customs/ISF filing workflow" |
| `{QUESTION_COUNT}` | Count of questions in questionnaire | 34 |
| `{TIME_ESTIMATE}` | ~1 min per question, round to nearest 5 | 30 minutes |
| `{DETAIL_HINT}` | What kind of detail helps most | "the spreadsheet workflow and carrier tracking steps" |
| `{CLIENT_SLUG}` | Directory name | ygal-fish-import |
| `{FORM_URL}` | Google Form responderUri after creation | https://docs.google.com/forms/d/e/.../viewform |

## Subject Line

```
Discovery questions for your {FOCUS_AREA_SHORT} automation
```

Where `{FOCUS_AREA_SHORT}` is a 2-4 word summary of the main pain point (e.g., "shipment tracking", "order fulfillment", "client intake").

## Email Body

```
{FIRST_NAME},

Good talking through {MEETING_REFERENCE}. We got a clear picture of {FOCUS_AREAS}.

We put together {QUESTION_COUNT} questions organized around those areas. The goal is to document exactly how each process works today so we can scope the automation accurately and calculate the ROI before we build anything.

You can answer whichever way is easiest:
- Google Form: {FORM_URL}
- PDF: Attached. Open in any PDF reader and type directly into the answer fields. Save and email back.
- Email: Reply with numbered responses
- Call: We can walk through it together if that's easier

A few notes:
- Should take about {TIME_ESTIMATE}. Short answers are fine.
- If a question doesn't apply, skip it.
- The more detail you give on {DETAIL_HINT}, the more precise our scoping will be.

Once we have your answers, we'll document the SOPs for each process, map out before/after workflows, and put together a proposal with specific savings numbers.

Talk soon,
Ariel
My New Agent | mynewagent.ai
```

## Google Form Creation

Before sending the email, create a Google Form from the client's questionnaire markdown.

**Step 1: Create the form**
```bash
gws forms forms create --json '{"info": {"title": "Discovery Questions: {CLIENT_COMPANY}", "documentTitle": "Discovery Questions: {CLIENT_COMPANY}"}}'
```

**Step 2: Add questions via batchUpdate**

Parse the questionnaire markdown and build a batchUpdate JSON:
- Each `## Section Name` becomes a `pageBreakItem`
- Each numbered question becomes a `textQuestion` with `paragraph: true` (open-ended, not required)
- The intro blockquote becomes the form `description` via `updateFormInfo`

```bash
gws forms forms batchUpdate --params '{"formId": "{FORM_ID}"}' --json '{"requests": [...]}'
```

**Step 3: Capture `responderUri`** from the create response for the email.

## GWS CLI Command

```bash
gws gmail +send \
  --to {EMAIL} \
  --subject 'Discovery questions for your {FOCUS_AREA_SHORT} automation' \
  --body '<HTML_BODY_WITH_PLACEHOLDERS_FILLED>' \
  --html \
  -a ~/my-new-agent/clients/{CLIENT_SLUG}/deliverables/discovery/discovery-questionnaire.pdf \
  --draft
```

Always create as `--draft` first so Ariel can review before sending.

## After Sending

Update the client's internal profile checklist:
```
- [x] Discovery questionnaire sent
```
