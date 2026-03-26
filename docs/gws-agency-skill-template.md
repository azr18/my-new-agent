# Prompt Template: Create a Google Workspace Agency Skill

## Context

This is a reusable prompt template for creating agency-tailored Google Workspace skills. Copy the template below, fill in the `{PLACEHOLDERS}`, and paste it into a new Claude Code conversation. The memory system will provide Claude with background context about the project automatically.

## How to Use

1. Run `/clear` or open a new Claude Code session
2. Copy the prompt template below
3. Replace all `{PLACEHOLDERS}` with your specifics
4. Paste and send

---

## Prompt Template

```
Create the agency {SERVICE_NAME} skill for My New Agent — skill #{SKILL_NUMBER} in the Google Workspace integration.

## What to Build

Create `google-workspace-plugin/skills/mna-{SERVICE_SLUG}/SKILL.md` — an agency-tailored skill that wraps the base GWS {SERVICE_SLUG} skill with My New Agent's workflows and conventions.

## Base Skills to Reference (already in the repo)

Read these files first to understand the available commands:
- `google-workspace-plugin/skills/gws-{SERVICE_SLUG}/SKILL.md` — base service skill (API resources, command syntax)
{HELPER_SKILLS_LIST}
- `google-workspace-plugin/skills/gws-shared/SKILL.md` — auth, global flags, security rules

Also review these for relevant cross-service recipes:
{RELEVANT_RECIPES_LIST}

## Existing Agency Skills to Match Pattern

Read these to match the agency's skill format, tone, and structure:
- `brand-voice-generator-plugin/skills/brand-voice-generator/SKILL.md` — example of agency skill structure
- `client-onboarding-plugin/skills/client-onboarding/SKILL.md` — example of workflow-based skill with steps
- `brand/brand-guide.md` — agency brand voice and visual identity

## How I Use {SERVICE_NAME} for the Agency

{DESCRIBE_YOUR_USE_CASES_HERE — be specific. Examples below for each service:}

{For Gmail: "I email clients for discovery follow-ups, send proposals, reply to leads from the website contact form. My inbox gets mixed with client emails and vendor/tool notifications. I want triage rules that surface client emails first. I sign emails as 'Ariel — My New Agent'. I never want to send an email without confirming first."}

{For Calendar: "I schedule discovery calls (30 min), review sessions (45 min), and kickoff meetings (60 min). I use Google Meet for all client meetings. My working hours are X-Y timezone. I want to be able to check availability and create events with the right naming convention."}

{For Drive: "Each client gets a folder at a consistent path. I store deliverables, meeting recordings, and shared documents. I want consistent folder structures created automatically when onboarding a new client."}

{For any service: describe the specific tasks you do, naming conventions, who you interact with, what guardrails you want}

## Skill Requirements

The SKILL.md must include:

### 1. Frontmatter
```yaml
---
name: "mna-{SERVICE_SLUG}"
description: "{ONE_LINE_DESCRIPTION}. Triggers on: {COMMA_SEPARATED_TRIGGER_PHRASES}."
---
```

### 2. Role Definition
One paragraph: "You manage {SERVICE_NAME} for My New Agent (mynewagent.ai), an AI automation agency." Define what this skill handles and what it doesn't.

### 3. Agency Workflows
Numbered workflows for each use case I described above. Each workflow should:
- Have a clear name (e.g., "Send Client Follow-Up", "Triage Inbox")
- List the steps using actual `gws` commands from the base skill
- Include the exact flags and parameters needed
- Show example commands with realistic agency data
- Mark read-only vs write operations clearly

### 4. Conventions & Defaults
A table or list of agency-specific defaults:
- Naming conventions (email subjects, event titles, folder names, file names)
- Default values (calendar ID, folder paths, contact groups)
- Brand voice rules for any client-facing content (reference brand-guide.md)

### 5. Guardrails
- Always confirm before ANY write operation (send, create, update, delete)
- Show a preview of what will be sent/created before executing
- Never expose internal pricing or notes in client-facing content
- Follow the writing style from CLAUDE.md (no em dashes, no buzzwords, no AI patterns)

### 6. Cross-Service Integration
How this skill connects to other agency skills:
- Which client-onboarding steps use this service
- Which other GWS services this skill commonly pairs with
- Links to relevant base GWS skills and recipes

### 7. Quick Reference
A compact table of the most common commands for fast lookup:

| Task | Command |
|------|---------|
| {common task} | `gws {service} ...` |

### 8. Verification
After creating the skill:
- Test one read-only command to confirm it works
- Test one write command with `--dry-run` if available
- Confirm the skill triggers correctly

## Writing Style for the Skill Itself

- Direct and scannable — tables and code blocks over prose
- Commands must be copy-pasteable (include all required flags)
- Use realistic agency examples (client names like "acme-corp", emails like "contact@acme.com")
- Keep it under 200 lines — concise enough to be useful, detailed enough to be complete
```

---

## Service-Specific Fill-In Guide

Use this to fill in the placeholder sections for each service:

### Skill #1: Gmail
- `{SERVICE_SLUG}`: gmail
- `{HELPER_SKILLS_LIST}`:
  - `google-workspace-plugin/skills/gws-gmail-send/SKILL.md`
  - `google-workspace-plugin/skills/gws-gmail-read/SKILL.md`
  - `google-workspace-plugin/skills/gws-gmail-triage/SKILL.md`
  - `google-workspace-plugin/skills/gws-gmail-reply/SKILL.md`
  - `google-workspace-plugin/skills/gws-gmail-reply-all/SKILL.md`
  - `google-workspace-plugin/skills/gws-gmail-forward/SKILL.md`
  - `google-workspace-plugin/skills/gws-gmail-watch/SKILL.md`
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-draft-email-from-doc/SKILL.md`
  - `google-workspace-plugin/skills/recipe-save-email-attachments/SKILL.md`
  - `google-workspace-plugin/skills/recipe-save-email-to-doc/SKILL.md`
  - `google-workspace-plugin/skills/recipe-forward-labeled-emails/SKILL.md`
  - `google-workspace-plugin/skills/recipe-create-gmail-filter/SKILL.md`
  - `google-workspace-plugin/skills/recipe-label-and-archive-emails/SKILL.md`
  - `google-workspace-plugin/skills/gws-workflow-email-to-task/SKILL.md`

### Skill #2: Calendar
- `{SERVICE_SLUG}`: calendar
- `{HELPER_SKILLS_LIST}`:
  - `google-workspace-plugin/skills/gws-calendar-insert/SKILL.md`
  - `google-workspace-plugin/skills/gws-calendar-agenda/SKILL.md`
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-batch-invite-to-event/SKILL.md`
  - `google-workspace-plugin/skills/recipe-block-focus-time/SKILL.md`
  - `google-workspace-plugin/skills/recipe-create-events-from-sheet/SKILL.md`
  - `google-workspace-plugin/skills/recipe-find-free-time/SKILL.md`
  - `google-workspace-plugin/skills/recipe-reschedule-meeting/SKILL.md`
  - `google-workspace-plugin/skills/recipe-schedule-recurring-event/SKILL.md`
  - `google-workspace-plugin/skills/gws-workflow-meeting-prep/SKILL.md`

### Skill #3: Drive
- `{SERVICE_SLUG}`: drive
- `{HELPER_SKILLS_LIST}`:
  - `google-workspace-plugin/skills/gws-drive-upload/SKILL.md`
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-bulk-download-folder/SKILL.md`
  - `google-workspace-plugin/skills/recipe-create-shared-drive/SKILL.md`
  - `google-workspace-plugin/skills/recipe-find-large-files/SKILL.md`
  - `google-workspace-plugin/skills/recipe-organize-drive-folder/SKILL.md`
  - `google-workspace-plugin/skills/recipe-share-folder-with-team/SKILL.md`
  - `google-workspace-plugin/skills/recipe-watch-drive-changes/SKILL.md`

### Skill #4: Docs
- `{SERVICE_SLUG}`: docs
- `{HELPER_SKILLS_LIST}`:
  - `google-workspace-plugin/skills/gws-docs-write/SKILL.md`
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-create-doc-from-template/SKILL.md`
  - `google-workspace-plugin/skills/recipe-draft-email-from-doc/SKILL.md`
  - `google-workspace-plugin/skills/recipe-save-email-to-doc/SKILL.md`

### Skill #5: Sheets
- `{SERVICE_SLUG}`: sheets
- `{HELPER_SKILLS_LIST}`:
  - `google-workspace-plugin/skills/gws-sheets-read/SKILL.md`
  - `google-workspace-plugin/skills/gws-sheets-append/SKILL.md`
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-backup-sheet-as-csv/SKILL.md`
  - `google-workspace-plugin/skills/recipe-compare-sheet-tabs/SKILL.md`
  - `google-workspace-plugin/skills/recipe-copy-sheet-for-new-month/SKILL.md`
  - `google-workspace-plugin/skills/recipe-create-expense-tracker/SKILL.md`
  - `google-workspace-plugin/skills/recipe-generate-report-from-sheet/SKILL.md`
  - `google-workspace-plugin/skills/recipe-sync-contacts-to-sheet/SKILL.md`

### Skill #6: Contacts/People
- `{SERVICE_SLUG}`: people
- `{HELPER_SKILLS_LIST}`: (none — no helpers for people)
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-sync-contacts-to-sheet/SKILL.md`

### Skill #7: Tasks
- `{SERVICE_SLUG}`: tasks
- `{HELPER_SKILLS_LIST}`: (none)
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-create-task-list/SKILL.md`
  - `google-workspace-plugin/skills/recipe-review-overdue-tasks/SKILL.md`
  - `google-workspace-plugin/skills/gws-workflow-email-to-task/SKILL.md`

### Skill #8: Forms
- `{SERVICE_SLUG}`: forms
- `{HELPER_SKILLS_LIST}`: (none)
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-collect-form-responses/SKILL.md`
  - `google-workspace-plugin/skills/recipe-create-feedback-form/SKILL.md`

### Skill #9: Slides
- `{SERVICE_SLUG}`: slides
- `{HELPER_SKILLS_LIST}`: (none)
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-create-presentation/SKILL.md`
  - `google-workspace-plugin/skills/recipe-share-event-materials/SKILL.md`

### Skill #10: Keep
- `{SERVICE_SLUG}`: keep
- `{HELPER_SKILLS_LIST}`: (none)
- `{RELEVANT_RECIPES_LIST}`: (none directly — keep is standalone)

### Skill #11: Classroom
- `{SERVICE_SLUG}`: classroom
- `{HELPER_SKILLS_LIST}`: (none)
- `{RELEVANT_RECIPES_LIST}`:
  - `google-workspace-plugin/skills/recipe-create-classroom-course/SKILL.md`

### Skill #12: Admin
- `{SERVICE_SLUG}`: admin-reports
- `{HELPER_SKILLS_LIST}`: (none)
- `{RELEVANT_RECIPES_LIST}`: (none directly)

---

## Verification

After each skill is created:
1. Run a read-only test command from the skill's Quick Reference table
2. Run a write command with `--dry-run` (if supported)
3. Invoke the skill by trigger phrase to confirm it loads
4. Check that cross-service references point to real files
