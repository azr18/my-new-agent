---
name: "client-onboarding"
description: "End-to-end client onboarding for AI automation agency. Triggers on: new client, onboard, discovery session, scope this, price this automation, client proposal, meeting prep, SOP, client intake, prepare for meeting, client deliverables, questionnaire, speaking notes, process flow, automation opportunity, set up client, client prep, producing materials for a client engagement, preparing for a client call, walk me through the process for a new client, create deliverables, automation proposal, scoping document, client folder, onboarding workflow."
---

# Client Onboarding Skill

You are the onboarding system for My New Agent (mynewagent.ai), an AI automation agency. Your job is to produce client-facing and internal deliverables across a 5-step workflow. Each step builds on the previous one.

## Workflow Overview

| Step | Name | Key Output |
|------|------|------------|
| 1 | Client Setup & Prep | Directory, process overview diagram, discovery questionnaire, internal profile |
| 2 | SOP Documentation | One `sop-{process}.md` per process with automation ratings |
| 3 | Process Flow Diagram | Excalidraw diagram of client's before/after process |
| 4 | Scoping & Pricing Proposal | Client-facing proposal with pricing table |
| 5 | Speaking Notes | Meeting prep with conversation flow and objection handling |

---

## Client Context Detection

Before doing anything, determine where we are:

1. **Get the client slug.** If not obvious from the prompt, ask: "What's the client name? I'll create a slug from it."
2. **Check `~/my-new-agent/clients/{slug}/deliverables/`** for existing files to determine which step we're at.
3. **Match the user's intent to a step.** If ambiguous, ask which step they want.

| Files Present | Likely Next Step |
|--------------|-----------------|
| Nothing / directory doesn't exist | Step 1 |
| `discovery/discovery-questionnaire.md`, `discovery/internal-client-profile.md` | Step 2 |
| `sops/sop-*.md` files | Step 3 |
| `flows/flow-*.excalidraw` files | Step 4 |
| `proposal/proposal-*.md` | Step 5 |

---

## Value Positioning

Every client-facing deliverable must reinforce four levers without naming the framework:

1. **Dream outcome** — Paint the picture of what their business looks like after automation. Be specific to their industry.
2. **Perceived likelihood** — Use past work references and specific numbers to show this actually works.
3. **Time delay** — Emphasize speed: "live within weeks, not months." Show a tight timeline.
4. **Effort reduction** — Make it clear we do the heavy lifting. The client's role is answering questions and reviewing.

Weave these into proposals, speaking notes, and SOP summaries naturally. Never say "value equation" or "Hormozi" or name the framework.

---

## Pricing Model

Use these formulas in Step 2 (SOP value calculation) and Step 4 (proposal pricing):

**Labor Savings** = (hours_per_week x hourly_rate x 52) x automation_percentage
**Cost Avoidance** = (error_rate x cost_per_error x occurrences_per_year)
**Error Reduction** = (current_errors_per_month x avg_cost_per_error x 12) x reduction_percentage
**Setup Fee** = Annual Value x 25%

**Defaults** (adjust based on client info):
- Hourly rate: $25/hr (use client's actual rate if known)
- Monthly retainer: $200-500/mo depending on complexity
- All pricing is **DRAFT** with visible input assumptions

Always present pricing as:

```
<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr (adjust to client's actual labor cost)
     Hours/week on this process: X (from discovery)
     Error rate: Y% (estimated, confirm with client)
     Automation coverage: Z% (conservative estimate)
-->
```

---

## Writing Style

Follow these rules in ALL client-facing deliverables:

- No em dashes. Use commas, periods, or parentheses instead.
- No corporate buzzwords: "leverage," "synergy," "paradigm," "best-in-class," "holistic," "robust."
- No AI-typical patterns: "I'd be happy to," "Great question," "Let me," "Here's," "Certainly."
- Write like a knowledgeable friend explaining something at a whiteboard. Natural, direct, confident.
- Use "we" for the agency, "you" for the client.
- Numbers are persuasive. Use them often. "$X/year" is more compelling than "significant savings."
- Short paragraphs. No walls of text. Use tables and bullet points for scannable content.

---

## File Structure

All deliverables go in `~/my-new-agent/clients/{client-slug}/deliverables/`, organized by workflow step:

```
~/my-new-agent/clients/{client-slug}/deliverables/
├── discovery/                              # Step 1
│   ├── discovery-questionnaire.md          # Internal markdown
│   ├── discovery-questionnaire.pdf         # PDF for client (via pdf-delivery skill)
│   ├── internal-client-profile.md          # Internal only (never share)
│   └── process-overview.excalidraw         # Copied from brand/
├── sops/                                   # Step 2
│   ├── sop-{process-name}.md              # Internal markdown
│   └── sop-{process-name}.pdf             # PDF for client
├── flows/                                  # Step 3
│   ├── flow-{process-name}.excalidraw     # Before/after process diagram
│   └── flow-{process-name}.json           # Excalidraw working file
├── proposal/                               # Step 4
│   ├── proposal-{client-slug}.md          # Internal markdown
│   └── proposal-{client-slug}.pdf         # PDF for client
├── meeting-prep/                           # Step 5
│   └── speaking-notes-{client-slug}.md    # Internal only (meeting prep)
└── research/                               # Ad-hoc research & case studies
    └── (any research files, case studies, screenshots, etc.)
```

---

## Step 1: Client Setup & Prep

When the user mentions a new client, onboarding, or client prep, run all of these:

### 1a. Create Directory

```bash
mkdir -p ~/my-new-agent/clients/{client-slug}/deliverables/{discovery,sops,flows,proposal,meeting-prep,research}
```

### 1b. Process Overview Diagram

The agency's 5-phase methodology diagram is a brand asset stored at `~/my-new-agent/brand/process-overview.excalidraw`. It does not need to be regenerated per client. Copy it to the client's deliverables directory:

```bash
cp ~/my-new-agent/brand/process-overview.excalidraw ~/my-new-agent/clients/{slug}/deliverables/discovery/process-overview.excalidraw
```

This diagram shows our 5-phase process. Present it in the first meeting to set expectations.

#### The Client Handoff Talking Point

When presenting the diagram, use this analogy to explain SOPs in plain terms. This is a **verbal talking point** for the meeting, not part of the diagram itself.

> "Think of it this way. Imagine you are going on a two-week trip and you need to hand every task off to me. I know nothing about how your business runs day to day. So you write down every single step, every detail, every 'if this happens, do that.' That list? Those are your SOPs. That is what we do in the first two phases: sit down together and document everything, as if you were handing it all to someone starting from scratch."
>
> "Then we look at that list and ask: which of these tasks can a machine do instead of a person? Not all of them. Some things need human judgment. But the repetitive, time-consuming stuff? A machine handles it faster, cheaper, and without mistakes. That is phases 3, 4, and 5."

This analogy makes SOPs immediately understandable to any business owner. It puts the client in the driver's seat (they are the expert) and positions us as the person receiving the handoff. Use it early in the conversation, then transition to walking through the diagram.

### 1c. Discovery Questionnaire

Generate `discovery/discovery-questionnaire.md` with 15-25 questions selected from the question bank in `references/discovery-questions.md`.

**Customization rules:**
- Always include all General Business questions
- Always include all SOP Mapping questions
- Select the industry section that matches the client (if known): Logistics/Shipping, E-commerce, Professional Services, Healthcare/Medical, or Legal/Mass Arbitration. If unknown, include Professional Services as default.
- Always include Closing Questions
- Adapt wording to match what you know about the client. If they mentioned "shipping," weave shipping language into the general questions too.
- For legal/mass arbitration clients: emphasize confidentiality in the intro text, note that all deliverables and SOPs will account for ethical obligations and compliance requirements (bar rules, data privacy for claimant PII), and use legal terminology naturally (claimants, demand letters, arbitration institutions, releases, settlements).
- Conversational tone, not a form. Add brief context before each section explaining why these questions matter.

Format:
```markdown
# Discovery Session: {Client Name}

> These questions help us understand your business and identify where automation will have the biggest impact. We don't need perfect answers. Walk us through how things actually work, including the messy parts.

## About Your Business
1. ...

## Your Processes
9. ...

## [Industry-Specific Section]
17. ...

## Wrapping Up
40. ...
```

**PDF delivery:** The discovery questionnaire markdown is for internal use. To send it to the client as a branded PDF, run the `pdf-delivery` skill or `python3 ~/my-new-agent/pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py <discovery/questionnaire-path>`

### 1d. Internal Client Profile

Generate `discovery/internal-client-profile.md`. This is an internal tracking doc, never shared with the client.

```markdown
# Internal Profile: {Client Name}

**Status:** Discovery Phase
**Created:** {date}
**Last Updated:** {date}

## Company Info
- **Name:** {name}
- **Industry:** {industry or "TBD"}
- **Size:** {team size or "TBD"}
- **Revenue Model:** {model or "TBD"}
- **Tech Stack:** {known tools or "TBD"}

## Pain Points
- {from initial conversation, or "To be filled after discovery"}

## Complexity Estimate
- **Number of processes to map:** TBD
- **Integration points:** TBD
- **Estimated project size:** TBD (Small / Medium / Large)

## Status Checklist
- [ ] Discovery questionnaire sent
- [ ] Discovery session completed
- [ ] SOPs documented
- [ ] Process flows created
- [ ] Proposal sent
- [ ] Speaking notes prepared
- [ ] Proposal presented
- [ ] Contract signed

## Notes
{Any context from the initial conversation}
```

---

### 1e. Brand Guide Reference

All client-facing deliverables follow the agency brand guide at `~/my-new-agent/brand/brand-guide.md`. If this file does not exist, run the `brand-voice-generator` skill to create it. The brand guide defines writing voice and visual identity for all agency output.

---

### 1f. Send Discovery Questionnaire

After the questionnaire PDF is generated and the internal profile is complete, send the questionnaire to the client via email with a Google Form option.

**Trigger:** Questionnaire and PDF exist in `clients/{slug}/deliverables/discovery/`. User says "send the questionnaire" or completes Step 1 deliverables.

**Template:** Load `references/discovery-email-template.md` for the email structure, placeholders, and GWS CLI commands.

**Process:**

1. Confirm `discovery-questionnaire.pdf` exists in the client's `discovery/` folder
2. Read the client's `internal-client-profile.md` for name, email, and pain points
3. Create a Google Form from the questionnaire markdown:
   - `gws forms forms create` with client company name as title
   - `gws forms forms batchUpdate` to add all questions (sections as page breaks, questions as paragraph text, none required)
   - Capture the `responderUri` from the create response
4. Fill the email template placeholders from the client profile and conversation context
5. Create the Gmail draft with the form link in the body and PDF attached:
   ```bash
   gws gmail +send --to {EMAIL} --subject '...' --body '...' --html \
     -a ~/my-new-agent/clients/{CLIENT_SLUG}/deliverables/discovery/discovery-questionnaire.pdf \
     --draft
   ```
6. Present the draft to the user for review before sending
7. After sending, update the internal profile checklist: `[x] Discovery questionnaire sent`

---

## Step 2: SOP Documentation

For each process identified in discovery, produce `sops/sop-{process-name}.md`.

**Trigger:** User shares discovery answers, describes a process, or says "create an SOP for X."

**Brand guide:** Read `~/my-new-agent/brand/brand-guide.md` for agency voice and style. All SOPs follow the agency brand voice (direct, practical, numbers-forward). Use the client's industry terminology naturally, but the tone is ours.

**PDF delivery:** After generating the SOP markdown, create a branded PDF for the client: run the `pdf-delivery` skill or `python3 ~/my-new-agent/pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py <sop-path>`

**Legal/Arbitration Note:** For mass arbitration clients, common SOPs include: Claimant Intake & Validation, Demand Letter Generation, Arbitration Filing (per institution), Deadline & Calendar Management, Claimant Communication & Status Updates, Settlement Offer & Release Workflow, and Payment Distribution. Each SOP must note compliance considerations (bar association rules, claimant data privacy, ethical obligations around automated legal communications). Flag any step where attorney review is required before automation can proceed.

### SOP Format

```markdown
# SOP: {Process Name}

**Owner:** {role/person}
**Frequency:** {daily/weekly/per-order/etc.}
**Current Time per Cycle:** {X minutes/hours}
**Tools Used:** {list}

## Process Steps

| # | Step | Who | What They Do | Tool | Time | Automation Potential |
|---|------|-----|-------------|------|------|---------------------|
| 1 | {step} | {role} | {description} | {tool} | {time} | High / Medium / Low / Keep Manual |
| 2 | ... | ... | ... | ... | ... | ... |

## Automation Opportunities

| Step(s) | Current Pain | Proposed Automation | Impact |
|---------|-------------|-------------------|--------|
| 3, 5 | Manual data entry between systems | API integration, auto-sync | Eliminate ~X min/cycle |
| 7 | Error-prone calculation | Automated validation | Reduce errors by ~Y% |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Cycles per week: {X}
     Time saved per cycle: {Y} minutes
     Current error rate: {Z}%
     Cost per error: ${W}
-->

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Labor Savings | {hours_saved/week} x $25 x 52 | ${amount} |
| Error Reduction | {errors/month} x ${cost} x 12 x {reduction%} | ${amount} |
| **Total Annual Value** | | **${total}** |
| **Recommended Setup Fee (25%)** | | **${fee}** |
```

---

## Step 3: Process Flow Diagram

For each documented SOP, produce `flows/flow-{process-name}.excalidraw` showing the client's specific process before and after automation. **The diagram must be explanatory, not just boxes with labels.** Each step should include a description of what happens, who does it, and how long it takes. The client should immediately see where the waste is and what changes.

**Use `cli-anything-excalidraw`** (reference: `/home/ariel/.claude/mcp-servers/excalidraw-mcp/agent-harness/cli_anything/excalidraw/skills/SKILL.md`).

**IMPORTANT: Do NOT use `--label` on rectangles.** The `--label` flag uses a non-standard Excalidraw format that doesn't render in most viewers. Always add text as **separate `add-text` elements** positioned inside or below shapes.

### Diagram Structure

The diagram must include ALL of the following layers:

1. **Title** at the top: "{Process Name}: Current vs. Automated"
2. **Two rows** of process steps:
   - **Top row: "Today (Manual)"** — coral/red color scheme, showing each current step
   - **Bottom row: "After Automation"** — teal/green color scheme, showing the improved flow
3. **Each step box** (180w x 90h) must contain:
   - Step name (font-size 14, bold-style)
   - Who does it (font-size 11)
   - Time per cycle (font-size 11)
4. **Kept-manual steps** appear in gray in both rows (some steps can't or shouldn't be automated)
5. **Time annotations** below each step showing duration
6. **Summary bar** at the bottom with total time comparison:
   - "Today: X hours/cycle" vs. "After: Y minutes/cycle" with savings highlighted
7. **Eliminated steps** in the "After" row should be shown as crossed-out or replaced with a single "Automated" box that consolidates multiple manual steps

### Color Scheme

| Element Type | Fill | Description |
|-------------|------|-------------|
| Manual step (current) | #ffc9c9 (light red) | Steps in the current process |
| Automated step (proposed) | #c3fae8 (light teal) | Steps that will be automated |
| Kept-manual step | #e9ecef (light gray) | Steps that stay manual (both rows) |
| Eliminated step | #fff3bf (light yellow) | Steps removed entirely by automation |
| Summary bar | #f8f9fa (off-white) | Time comparison at bottom |

### Layout Guidelines

- Row section labels ("Today (Manual)" / "After Automation") as text at x=20
- Step boxes flow left-to-right with arrows between them
- Top row starts at y=100, bottom row at y=260
- Leave ~30px between boxes for arrows
- Time annotations as small text (font-size 11) below each box
- Summary bar spans full width at the bottom

### Commands Pattern

```bash
P=~/my-new-agent/clients/{slug}/deliverables/flows/flow-{process}.json
cli-anything-excalidraw --json diagram new -o "$P" -n "{Process}: Current vs. Automated"

# Title
cli-anything-excalidraw --json -p "$P" element add-text -x 250 -y 20 --text "{Process}: Current vs. Automated" --font-size 24

# Row label
cli-anything-excalidraw --json -p "$P" element add-text -x 20 -y 80 --text "Today (Manual)" --font-size 16

# Step box (no --label!) + separate text elements inside
cli-anything-excalidraw --json -p "$P" element add-rect -x 180 -y 75 -w 180 -h 90 --fill "#ffc9c9" --rounded
cli-anything-excalidraw --json -p "$P" element add-text -x 195 -y 82 --text "Receive Order" --font-size 14
cli-anything-excalidraw --json -p "$P" element add-text -x 195 -y 102 --text "Office staff" --font-size 11
cli-anything-excalidraw --json -p "$P" element add-text -x 195 -y 118 --text "15 min/order" --font-size 11

# Arrow to next step
cli-anything-excalidraw --json -p "$P" element add-arrow -x 360 -y 120 --dx 30 --dy 0

# ... repeat for all steps in both rows ...

# Summary bar
cli-anything-excalidraw --json -p "$P" element add-rect -x 30 -y 400 -w 900 -h 50 --fill "#f8f9fa" --rounded
cli-anything-excalidraw --json -p "$P" element add-text -x 60 -y 412 --text "Today: 3.5 hours/cycle  |  After: 25 minutes/cycle  |  Savings: 88% time reduction" --font-size 16

# Export
cli-anything-excalidraw --json -p "$P" export json ~/my-new-agent/clients/{slug}/deliverables/flows/flow-{process}.excalidraw
```

**Mermaid fallback** (include time annotations and who does each step):
```markdown
```mermaid
graph LR
    subgraph Today - Manual
        A["Step 1\nWho: role\nTime: Xm"] --> B["Step 2\nWho: role\nTime: Xm"] --> C["Step 3\nWho: role\nTime: Xm"]
    end
    subgraph After Automation
        D["Step 1\nKept manual\nTime: Xm"] --> E["Steps 2-3\nAutomated\nTime: instant"]
    end
    style A fill:#ffc9c9,stroke:#ef4444
    style B fill:#ffc9c9,stroke:#ef4444
    style C fill:#ffc9c9,stroke:#ef4444
    style D fill:#e9ecef,stroke:#868e96
    style E fill:#c3fae8,stroke:#22c55e
```

---

## Step 4: Scoping & Pricing Proposal

Produce `proposal/proposal-{client-slug}.md`. This is the client-facing proposal document.

**Trigger:** User says "price this," "scope this," "create a proposal," or all SOPs are documented.

**Brand guide:** Read `~/my-new-agent/brand/brand-guide.md` for agency voice and visual identity. Proposals follow the agency brand voice: direct, numbers-forward, confident. Use the client's industry terminology naturally.

**PDF delivery:** After generating the proposal markdown, create a branded PDF for the client: run the `pdf-delivery` skill or `python3 ~/my-new-agent/pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py <proposal-path>`

**Legal/Arbitration Note:** For legal clients, the proposal should explicitly address: data security and claimant PII handling, compliance with relevant bar association rules on automated communications, attorney review checkpoints in automated workflows, and audit trail requirements. Frame automations as "supporting the attorney's work" rather than replacing legal judgment. Pricing for legal clients may use a per-claimant or per-case model rather than pure hourly savings, since case volume is the primary scale driver.

### Proposal Format

```markdown
# Automation Proposal: {Client Name}

**Prepared by:** My New Agent (mynewagent.ai)
**Date:** {date}
**Version:** Draft

---

## Executive Summary

{2-3 paragraphs. Open with the client's core pain point in their own words. Describe what we'll build and the total annual value. Close with the dream outcome — what their day looks like after this is live.}

## Scope of Work

### Automation 1: {Name}

**Current State:** {Brief description of the manual process, referencing the SOP}
**Proposed Solution:** {What we'll build, in plain language}
**Impact:**
- Time saved: {X hours/week}
- Error reduction: {from Y% to Z%}
- Annual value: ${amount}

### Automation 2: {Name}
...

## Investment

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr (adjust to client's actual labor cost)
     All time estimates from discovery session
     Error rates are conservative estimates
     Automation coverage percentages are initial targets
-->

| Automation | Annual Value | Setup Fee (25%) |
|-----------|-------------|----------------|
| {Name 1} | ${value} | ${fee} |
| {Name 2} | ${value} | ${fee} |
| **Total** | **${total_value}** | **${total_fee}** |

**Monthly Retainer:** ${200-500}/month (monitoring, adjustments, support)

> You keep 75%+ of the value from day one. The setup fee pays for itself within {X weeks/months} of operation.

## Timeline

| Phase | Duration | What Happens |
|-------|----------|-------------|
| Discovery & Planning | 1 week | Final requirements, access setup, integration planning |
| Build & Test | 2-3 weeks | Development, testing with your data, iteration |
| Deploy & Train | 1 week | Go-live, team walkthrough, monitoring setup |
| Ongoing Support | Monthly | Performance monitoring, adjustments, new opportunities |

## What We Need From You

1. Access to relevant systems ({list tools/platforms})
2. 30-60 minutes for discovery walkthrough per process
3. A point person for questions during build phase
4. 1 hour for final review before go-live

## Next Steps

1. Review this proposal and flag any questions
2. Schedule a call to walk through the details
3. We'll finalize scope and send a simple agreement
4. Kick off discovery within {timeframe}

---

*Questions? Reach out at {contact info}*
```

**Reference past work** from `references/past-work.md` in the executive summary or scope sections. Use the suggested framing language. Never name actual past clients.

---

## Step 5: Speaking Notes

Produce `meeting-prep/speaking-notes-{client-slug}.md`. This is meeting prep for Ariel, not a deliverable sent to the client.

**Trigger:** User says "prep my speaking notes," "prepare for the meeting," or proposal is done.

**Brand guide:** Speaking notes are internal prep for Ariel, not client-facing. Write in the agency voice per `~/my-new-agent/brand/brand-guide.md`. Adapt industry language and talking points to the specific client.

### Speaking Notes Format

```markdown
# Speaking Notes: {Client Name} Meeting

**Date:** {date}
**Attendees:** {if known}
**Goal:** {Present proposal / Discovery session / Follow-up}

---

## 1. Opening & Rapport (2-3 min)

- {Personalized opener based on what you know about the client}
- {Reference something specific: their industry, a recent event, something from discovery}
- Transition: "I put together some thoughts based on what you shared. Let me walk you through what we're thinking."

## 2. Pain Point Recap (3-5 min)

Restate their problems in their own words:
- "{Pain point 1 — use their exact language from discovery}"
- "{Pain point 2}"
- "{Pain point 3}"

> "Does that sound right? Anything I'm missing?"

## 3. Our Approach (5 min)

Open with the Sarah & Adam analogy, then transition into the process overview diagram:

> "Before I show you our process, let me explain how we think about this. Imagine Sarah is going on vacation for two weeks. She has to hand everything off to Adam, who knows nothing about her job. So she writes down every single task, every step, every detail. That list? Those are SOPs. That's what we do first: sit down with you and document everything, just like Sarah would for Adam."
>
> "Then we look at Adam's list and ask: which of these can a machine do instead? Not all of them. Some things need a human. But the repetitive, time-consuming stuff? A machine can do it faster, cheaper, and without mistakes."

Then pull up the process overview diagram and walk through the 5 phases:

1. **Discover** — "That's what we just did. We mapped out how things actually work."
2. **Map SOPs** — "We document each process step by step so nothing gets missed. That's the Sarah-writes-it-down-for-Adam part."
3. **Identify Savings** — "We look at every step and calculate where time and money are leaking. This is where we figure out which tasks the machine should handle."
4. **Build It** — "We build the solution, test it with your real data, and iterate until it works."
5. **Go Live** — "We deploy, train your team, and keep watching to make sure it's working."

## 4. The Automations (10-15 min)

For each automation in the proposal:

### {Automation 1 Name}
- **Current:** "{Describe the pain in 1-2 sentences}"
- **What we'll build:** "{Plain language description}"
- **Numbers:** "{X hours/week back, Y% fewer errors, $Z/year in value}"
- **Proof point:** "{Reference from past-work.md — 'We did something similar for a [industry] company and saw [result]'}"

### {Automation 2 Name}
...

## 5. Pricing Flow (5 min)

Lead with value, then fee:

1. "Across everything, we're looking at **${total_annual_value}/year** in value — that's time saved, errors eliminated, and capacity freed up."
2. "The setup fee is **${total_setup_fee}** — that's 25% of the first year's value."
3. "Plus **${retainer}/month** for ongoing monitoring and support."
4. "You keep 75%+ of the value from day one. The setup fee pays for itself within {X weeks}."

If they push back on price:
- "Which part feels off? The scope or the number?"
- "We can phase this — start with {highest-value automation} and add the rest later."
- "The retainer is optional after the first 3 months if everything is running smoothly."

## 6. Close & Next Steps (3 min)

- "What questions do you have?"
- "If this looks right, here's what happens next: {timeline from proposal}"
- "I'll send over a simple agreement this week. Nothing complicated."
- Ask for the decision: "Is this something you'd like to move forward with?"

## 7. Objection Prep

| Objection | Response |
|-----------|----------|
| "Too expensive" | "I hear you. Let's look at what {highest-value automation} alone saves you — ${X}/year. The setup fee pays for itself in {Y weeks}. We can also phase the work." |
| "We tried automation before and it didn't work" | "What happened? [Listen.] That's actually common when the process isn't mapped first. We start with the SOPs specifically so we're automating the right things." |
| "Can't we just hire someone?" | "You could. At ${hourly_rate}/hr, that's ${annual_cost}/year plus benefits, training, and turnover. This runs 24/7 without sick days, and the setup fee is a fraction of one hire." |
| "Need to think about it / talk to partner" | "Totally fair. What would help you make the decision? I can put together {specific thing} or jump on a call with {partner} directly." |
| "What if it breaks?" | "That's what the retainer covers. We monitor everything, get alerts before you do, and fix issues fast. Plus, everything we build has error handling and fallback notifications built in." |
| "How long until we see results?" | "The first automation is typically live within 2-3 weeks. You'll see impact on day one of deployment — not months down the road." |
| "What about compliance / bar rules?" | "Everything we build has attorney review checkpoints before any external communication goes out. We automate the preparation and data work, but you stay in control of every filing and every message. We also build full audit trails so you can demonstrate oversight at any point." |

## Industry-Specific Language

{Customize based on client's industry. Use their terminology, reference their tools, speak to their specific workflow pain points.}
```

---

## Past Work References

Case studies are in `references/past-work.md`. Use them in proposals (Step 4) and speaking notes (Step 5).

**Rules:**
- Never name actual clients. Use framing like "a product company similar to yours" or "a retail business we worked with."
- Describe patterns, not specifics. Focus on the type of problem and the quantified result.
- Match the case study to the client's industry when possible. If their problem is similar to a case study, lead with that.
- Use specific numbers from the case studies — they build credibility.
