# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

My New Agent (mynewagent.ai) -- AI automation consulting agency. We build custom business automations for clients in 2-6 weeks with measurable ROI. Owner: Ariel (azr18 on GitHub, ariel.r08@gmail.com).

## Key Commands

```bash
# Generate pitch deck
python3 brand/generate_pitch.py

# Generate branded PDF from any markdown deliverable
python3 pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py clients/{slug}/deliverables/{subfolder}/{file}.md

# Install the Claude Code plugin (add to ~/.claude/settings.json)
# See README.md "Setting Up a New System" section for full config
```

The primary workflow tool is the `/client-onboarding` skill, which drives all client work through 5 steps. The `/brand-voice-generator` skill manages the agency brand guide. The `/pdf-delivery` skill converts markdown deliverables to branded PDFs for clients.

## Architecture

This repo has three concerns:

1. **Client Onboarding Plugin** (`client-onboarding-plugin/`) -- A Claude Code skill plugin that implements the 5-step onboarding workflow. The skill definition lives at `client-onboarding-plugin/skills/client-onboarding/SKILL.md` (659 lines). Supporting reference material (discovery questions, past work case studies) is in `references/`.

2. **Active Client Data** (`clients/{client-slug}/deliverables/`) -- Each client gets a directory with deliverables organized into subfolders by workflow step: `discovery/` (questionnaire, profile, process overview), `sops/` (one per process), `flows/` (before/after diagrams), `proposal/`, `meeting-prep/` (speaking notes), and `research/` (ad-hoc research and case studies).

3. **Brand Materials** (`brand/`) -- Brand guide (`brand-guide.md`), pitch deck generator (`generate_pitch.py`), PDF generator (in `pdf-delivery` skill), process overview diagram (`process-overview.excalidraw`), website design spec (`website-prompt.txt`), and the generated .pptx deck.

### Plugin Structure

```
.claude-plugin/marketplace.json           # Marketplace manifest
client-onboarding-plugin/
  .claude-plugin/plugin.json              # Plugin definition
  skills/
    client-onboarding/
      SKILL.md                            # 5-step onboarding workflow
      references/
        discovery-questions.md            # 51 questions by industry
        past-work.md                      # 3 anonymized case studies
    brand-voice-generator/
      SKILL.md                            # Agency brand guide management
      references/
        mna-brand-voice.md               # Agency voice baseline
    pdf-delivery/
      SKILL.md                            # Markdown to branded PDF
      references/
        generate_pdf.py                   # Conversion script
        pdf-template.html                 # HTML template
        pdf-style.css                     # Brand CSS
```

## 5-Step Client Onboarding Workflow

Every client follows this process (full details in the SKILL.md):

| Step | Output |
|------|--------|
| 1. Client Setup & Prep | `discovery/` -- process overview (from brand/), discovery questionnaire, internal profile |
| 2. SOP Documentation | `sops/sop-{process}.md` per process with automation ratings and annual value |
| 3. Process Flow Diagram | `flows/flow-{process}.excalidraw` -- before/after diagram per process |
| 4. Scoping & Pricing Proposal | `proposal/proposal-{slug}.md` with pricing table and ROI |
| 5. Speaking Notes | `meeting-prep/speaking-notes-{slug}.md` with conversation flow and objection handling |

## Pricing Model

- Setup fee = 25% of estimated annual value
- Monthly retainer = $200-500/mo
- Default hourly rate: $25/hr (adjust per client)
- All pricing is always DRAFT with visible input assumptions
- Formulas: Labor Savings = (hrs/week x rate x 52) x automation%; Setup Fee = Annual Value x 25%

## Writing Style (All Client-Facing Deliverables)

- No em dashes. Use commas, periods, or parentheses.
- No corporate buzzwords: "leverage," "synergy," "paradigm," "best-in-class," "holistic," "robust."
- No AI patterns: "I'd be happy to," "Great question," "Let me," "Here's," "Certainly."
- Write like a knowledgeable friend at a whiteboard. Natural, direct, confident.
- Use "we" for the agency, "you" for the client.
- Numbers are persuasive. "$X/year" beats "significant savings."
- Short paragraphs. Tables and bullets for scannable content.

## Value Positioning (4 levers, never name this framework to clients)

1. Dream outcome -- paint the picture post-automation
2. Perceived likelihood -- use past work references and specific numbers
3. Time delay -- "live within weeks, not months"
4. Effort reduction -- we do the heavy lifting, client just answers questions and reviews

## The Client Handoff Analogy

Use when explaining SOPs: the client is going on a two-week trip and needs to hand every task off to us. They write down every single step, every detail, every "if this happens, do that." That list = SOPs (phases 1-2). Then we look at that list and ask which tasks a machine can do instead of a person (phases 3-5).

## Tech Stack

- Next.js 16 + Supabase + Stripe (TypeScript) for SaaS projects
- Python for data processing and automation scripts
- n8n for workflow automation
- Excalidraw (via cli-anything-excalidraw MCP server) for process diagrams
- WSL2 (Ubuntu on Windows), Node.js v20 via nvm

## Diagrams

Process diagrams use Excalidraw format (.excalidraw files with companion .json). These are generated via the Excalidraw MCP server tools (create_view, export_to_excalidraw, save_checkpoint, etc.).
