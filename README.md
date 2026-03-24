# My New Agent (mynewagent.ai)

AI automation consulting agency. We build custom business automations for clients in 2-6 weeks with measurable ROI.

This repo contains the Claude Code plugin (client-onboarding skill), all active client data, and brand materials. Use this to set up a new Claude Code environment with full agency context.

---

## Agency Overview

**What we do:** Build custom AI automations for businesses. We map their processes (SOPs), identify automation opportunities, calculate ROI, build the automations, and provide ongoing support.

**Business model:**
- Setup fee = 25% of estimated annual value
- Monthly retainer = $200-500/mo (monitoring, adjustments, support)
- Default hourly rate for calculations: $25/hr (adjust to client's actual labor cost)
- All pricing is DRAFT with visible input assumptions until confirmed with client

**Owner:** Ariel (azr18 on GitHub, ariel.r08@gmail.com)

**Tech stack:**
- Next.js 16 + Supabase + Stripe (TypeScript) for SaaS projects
- Python for data processing and automation scripts
- n8n for workflow automation
- Excalidraw (via cli-anything-excalidraw) for process diagrams
- WSL2 (Ubuntu on Windows), Node.js v20 via nvm

---

## 5-Step Client Onboarding Workflow

Every client goes through this process. The full skill definition is in `client-onboarding-plugin/skills/client-onboarding/SKILL.md`.

| Step | Name | Key Output |
|------|------|------------|
| 1 | Client Setup & Prep | Directory, process overview diagram, discovery questionnaire, internal profile |
| 2 | SOP Documentation | One `sop-{process}.md` per process with automation ratings |
| 3 | Process Flow Diagram | Excalidraw diagram of client's before/after process |
| 4 | Scoping & Pricing Proposal | Client-facing proposal with pricing table |
| 5 | Speaking Notes | Meeting prep with conversation flow and objection handling |

### File structure per client

```
~/clients/{client-slug}/deliverables/
  process-overview.excalidraw          # Step 1: Agency methodology diagram
  discovery-questionnaire.md           # Step 1: Tailored questions
  internal-client-profile.md           # Step 1: Internal tracking (never share)
  sop-{process-name}.md               # Step 2: One per process
  flow-{process-name}.excalidraw      # Step 3: Before/after process diagram
  proposal-{client-slug}.md           # Step 4: Scoping & pricing
  speaking-notes-{client-slug}.md     # Step 5: Meeting prep
```

### Pricing formulas

- **Labor Savings** = (hours_per_week x hourly_rate x 52) x automation_percentage
- **Cost Avoidance** = (error_rate x cost_per_error x occurrences_per_year)
- **Error Reduction** = (current_errors_per_month x avg_cost_per_error x 12) x reduction_percentage
- **Setup Fee** = Annual Value x 25%

### Value positioning (4 levers, never name the framework)

1. **Dream outcome** -- paint the picture of what their business looks like after automation
2. **Perceived likelihood** -- use past work references and specific numbers
3. **Time delay** -- emphasize speed: "live within weeks, not months"
4. **Effort reduction** -- we do the heavy lifting, client just answers questions and reviews

---

## Writing Style Rules

All client-facing deliverables must follow these:

- No em dashes. Use commas, periods, or parentheses instead.
- No corporate buzzwords: "leverage," "synergy," "paradigm," "best-in-class," "holistic," "robust."
- No AI-typical patterns: "I'd be happy to," "Great question," "Let me," "Here's," "Certainly."
- Write like a knowledgeable friend explaining something at a whiteboard. Natural, direct, confident.
- Use "we" for the agency, "you" for the client.
- Numbers are persuasive. Use them often. "$X/year" beats "significant savings."
- Short paragraphs. No walls of text. Use tables and bullet points for scannable content.

---

## The Sarah & Adam Talking Point

Use this analogy when explaining SOPs to clients:

> "Think of it this way. Imagine Sarah is going on vacation for two weeks. She has to hand everything off to Adam, who knows nothing about her job. So she writes down every single task, every step, every detail. That list? In our world, those are called SOPs. That's what we do in phases 1 and 2: sit down with you and document everything, just like Sarah would for Adam."
>
> "Then we look at Adam's list and ask: which of these tasks can a machine do instead? Not all of them. Some things need a human. But the repetitive, time-consuming stuff? A machine can do it faster, cheaper, and without mistakes. That's phase 3, 4, and 5."

---

## Active Clients (as of 2026-03-24)

All client data is in the `clients/` directory. Each has deliverables at various stages of the 5-step workflow.

### 1. Adam Schwartzbaum -- Mass Arbitration Attorney

- **Status:** Discovery Phase (started 2026-03-23)
- **Industry:** Legal / Mass Arbitration
- **Slug:** `adam-schwartzbaum`
- **Pain points:** Managing high-volume arbitration claims manually. Needs an "arbitration manager" system for operational complexity (intake, filing, deadline tracking, doc generation, communication, settlement management).
- **Complexity:** Medium-Large (6-8 processes, high volume, multiple institutions, compliance requirements)
- **Compliance notes:** Bar association rules on automated communications, claimant PII data privacy, attorney review checkpoints required before any external-facing automated communication or filing, audit trail requirements.
- **Key automation opportunities:**
  - Claimant intake and data management (custom intake, outreach, registration, validation/dedup)
  - Document generation and filing (demand letters, batch PDFs, automated filing to AAA/JAMS/NAM)
  - Deadline and calendar management (45-day answer windows, 60-day inactivity windows, hearing scheduling)
  - Claimant communication portal (status updates, bulk SMS/email, FAQ chatbot)
  - Case tracking and reporting dashboards
  - Settlement management (offer templates, e-signature, distribution calculation, release collection targeting 90-95% signed)
- **Deliverables completed:** Process overview diagram, discovery questionnaire, internal profile
- **Next step:** Step 2 (SOP Documentation) after discovery session

### 2. Schwatzbaum Class Action Law Firm

- **Status:** Discovery Phase (started 2026-03-22)
- **Industry:** Legal / Class Action Litigation
- **Slug:** `schwatzbaum-class-action`
- **Size:** Solo practitioner, just starting
- **Tech stack:** Clio (practice management), Harvey (AI legal research)
- **Pain points:** Solo handling everything: case management, intake, document prep, billing, class member communication. High admin overhead relative to billable work.
- **Complexity:** Medium (4-6 processes)
- **Key context:** Harvey integration opportunity. Clio API has automation features. Price-sensitive but high ROI for automation. Solo + class action means automation could be the equalizer.
- **Deliverables completed:** Process overview diagram, discovery questionnaire, internal profile
- **Next step:** Step 2 (SOP Documentation) after discovery session

### 3. Seven Seas International / Ygal Fish -- Frozen Seafood Distribution

- **Status:** Discovery Phase (started 2026-03-17)
- **Industry:** International frozen seafood distribution (import/export, wholesale, private label)
- **Slug:** `ygal-fish-import`
- **Contact:** Ygal Fish, Senior (ygal@sevenseasfoods.com, 401.433.8256)
- **HQ:** 66 W Flagler St, Suite #912, Miami, FL 33130
- **Scale:** 72 countries supplied, 20M+ lbs/year processed, 18 countries, 20+ nationalities, 24/7 timezone coverage
- **Product lines:** Retail/Food Service, Bait/Feed, Industry/Canning
- **Certifications:** BAP, MSC, BRC, IFS, Kosher (via partner facilities)
- **Pain points:** Logistics/trucking, coordination complexity across regions and timezones, multi-currency invoicing
- **Complexity:** Large (5-8 processes, international B2B, multi-facility, multi-currency, compliance-heavy)
- **Key automation opportunities:**
  - Order-to-fulfillment pipeline (order intake across countries, routing to correct facility, dispatch coordination)
  - International logistics (multi-carrier management, customs docs, bill of lading, freight forwarding)
  - Cold chain compliance (temperature monitoring, cert tracking, audit trail)
  - Customer communication (order status across time zones, multi-language support)
  - Inventory management (stock levels across partner facilities, seasonal supply)
  - Private label workflow (custom packaging specs, label generation, QC checklists)
  - Invoicing and AR (multi-currency, payment tracking across 72 countries)
  - Compliance document management (cert tracking, expiration alerts, audit prep)
- **Deliverables completed:** Process overview diagram, discovery questionnaire, internal profile, case study diagrams
- **Next step:** Discovery session, then Step 2

---

## Past Work / Case Studies

Use these as social proof in proposals and speaking notes. Never name actual clients. Full details in `client-onboarding-plugin/skills/client-onboarding/references/past-work.md`.

| Case Study | Framing | Result | Annual Value |
|------------|---------|--------|-------------|
| E-Commerce Shipping Automation | "a product company similar to yours" | 85% time reduction in shipping operations | ~$27,600/year |
| Order Confirmation Workflow | "a retail business we worked with" | Zero data handoff errors for 4+ months | ~$15,000-19,000/year |
| Blog Content Automation | "an e-commerce brand we work with" | 87% time reduction per blog post | ~$6,400-10,000/year |

---

## Objection Handling

Pre-built responses for common objections (used in Step 5 speaking notes):

| Objection | Response Strategy |
|-----------|-------------------|
| "Too expensive" | Break down per-automation ROI, show payback period in weeks, offer phased approach |
| "We tried automation before" | Ask what happened, explain SOP-first approach prevents automating the wrong things |
| "Can't we just hire someone?" | Compare: annual hire cost + benefits + training + turnover vs. one-time setup fee that runs 24/7 |
| "Need to think about it" | Ask what would help them decide, offer to jump on a call with their partner |
| "What if it breaks?" | Retainer covers monitoring, alerts before they notice, error handling and fallback notifications built in |
| "How long until results?" | First automation typically live within 2-3 weeks, impact on day one of deployment |
| "What about compliance / bar rules?" | Attorney review checkpoints before any external communication, full audit trails, automate preparation not judgment |

---

## Brand & Marketing

### Website (mynewagent.ai)

Design prompt in `brand/website-prompt.txt`. Key elements:
- Excalidraw-style flowchart navigation on dark canvas (#0F0F23)
- 5 nodes: Hero, Moment, Process, Proof, CTA
- Electric Blue (#00D4FF) active elements, Teal (#00C9A7) secondary
- Hero: "Your Business Runs on Repetition. It Doesn't Have To."
- Key metrics: "4-6 Week Delivery" / "$60K+ Avg Annual Savings" / "75%+ Value Stays With You"

### Pitch deck

`brand/generate_pitch.py` generates `Why_Your_Business_Needs_AI_Automation.pptx` programmatically.

### Brand voice

- Direct, confident, no buzzwords
- Speak to business owners, not engineers
- Money, time, and competitive advantage language
- Short sentences. Numbers for credibility. Show don't tell.

---

## Discovery Question Bank

51 questions organized by category in `client-onboarding-plugin/skills/client-onboarding/references/discovery-questions.md`:

- **General Business** (8 questions): business model, team, revenue, tech stack, magic wand, good/bad months, past attempts, 90-day success
- **SOP Mapping** (8 questions): process walkthrough, roles, tools per step, time per step, what goes wrong, error detection, data copying, conditional logic
- **Industry sections** (select one per client):
  - Logistics/Shipping (6 questions)
  - E-commerce (6 questions)
  - Professional Services (6 questions)
  - Healthcare/Medical (5 questions)
  - Legal/Mass Arbitration (8 questions)
- **Closing** (4 questions): personal impact, decision makers, timeline, budget

---

## Repo Structure

```
.claude-plugin/
  marketplace.json                     # Claude Code marketplace manifest

client-onboarding-plugin/              # The skill plugin
  .claude-plugin/plugin.json
  skills/client-onboarding/
    SKILL.md                           # Full 5-step workflow definition (659 lines)
    references/
      discovery-questions.md           # 51 discovery questions by category
      past-work.md                     # 3 anonymized case studies

clients/                               # Active client data
  adam-schwartzbaum/deliverables/
    internal-client-profile.md
    discovery-questionnaire.md
    process-overview.excalidraw
    process-overview.json
  schwatzbaum-class-action/deliverables/
    internal-client-profile.md
    discovery-questionnaire.md
    process-overview.excalidraw
    process-overview.json
  ygal-fish-import/deliverables/
    internal-client-profile.md
    discovery-questionnaire.md
    process-overview.excalidraw
    process-overview.json
    our-process.excalidraw
    case-study-shipping.excalidraw
    case-study-blog.excalidraw

brand/
  website-prompt.txt                   # Landing page design spec
  generate_pitch.py                    # Pitch deck generator
  Why_Your_Business_Needs_AI_Automation.pptx
```

---

## Setting Up a New System

### 1. Install the Claude Code plugin

Add to `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "my-new-agent": {
      "source": {
        "source": "github",
        "repo": "azr18/my-new-agent"
      }
    }
  },
  "enabledPlugins": {
    "client-onboarding@my-new-agent": true
  }
}
```

Restart Claude Code.

### 2. Set up the client directory

Clone this repo and copy client data to the expected location:

```bash
git clone git@github.com:azr18/my-new-agent.git ~/my-new-agent
cp -r ~/my-new-agent/clients ~/clients
```

### 3. Create a CLAUDE.md

Use the information in this README to create a project-level CLAUDE.md. Key things to include:

- Agency identity (My New Agent, mynewagent.ai)
- File structure convention (`~/clients/{slug}/deliverables/`)
- Writing style rules (no em dashes, no buzzwords, no AI patterns)
- Active client status and next steps
- Pricing model (25% setup fee, $200-500/mo retainer)
- The Sarah & Adam analogy for SOP explanations
- Value positioning framework (4 levers, never name it)
- Reference to the `/client-onboarding` skill for the full workflow

### 4. Install supporting tools

- Excalidraw MCP server (for diagram generation via cli-anything-excalidraw)
- n8n (for workflow automation)
- Node.js v20+ via nvm
- Python 3.12+
