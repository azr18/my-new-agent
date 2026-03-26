# My New Agent - Brand Guide

**Last updated:** 2026-03-25

---

## Part 1: Voice

### Voice Character

My New Agent sounds like a knowledgeable friend explaining something at a whiteboard. Confident without being pushy, specific without being dense. We lead with numbers and outcomes because that is what business owners care about. We treat our clients as smart people who just have not had time to figure out automation yet.

### Core Attributes

#### 1. Direct
Say what we mean. No hedging, no filler, no five-paragraph build-up before the point. If the answer is "this will save you $47,000 a year," open with that, then explain how. Short paragraphs. Bullet points. Tables when the data calls for it.

#### 2. Practical
Everything we say ties back to something the client can see, measure, or act on. We talk in hours saved, dollars recovered, errors eliminated. We do not sell visions. We sell specific outcomes with timelines: "live in 2-6 weeks."

#### 3. Human
We use "we" and "you." We tell stories (the client handoff analogy, not case study #47). We admit what we do not know. We never sound like a press release or a chatbot.

### Vocabulary

#### Always Use
- "We" for the agency, "you" for the client
- Concrete numbers: "$X/year," "Y hours/week," "Z% reduction"
- Time framing: "live in weeks, not months," "2-6 week delivery"
- Process language: "map," "automate," "build," "track," "trigger"
- ROI language: "annual savings," "setup fee," "monthly retainer," "payback period"
- Natural connectors: "because," "so," "that means," "in practice"

#### Never Use
- Em dashes (use commas, periods, or parentheses)
- Corporate buzzwords: "leverage," "synergy," "paradigm," "best-in-class," "holistic," "robust," "cutting-edge," "innovative solution"
- AI-typical patterns: "I'd be happy to," "Great question," "Let me," "Here's," "Certainly," "Absolutely"
- Vague claims without numbers: "significant savings," "improved efficiency," "enhanced productivity"
- Passive constructions when active works: "savings were achieved" vs. "you save"

#### Signature Devices

**The Client Handoff Analogy**
Use when explaining SOPs to clients: "Imagine you are going on a two-week trip and you need to hand every task off to me. I know nothing about how your business runs day to day. So you write down every single step, every detail, every 'if this happens, do that.' That list? Those are your SOPs. Then we look at that list and ask: which of these tasks can a machine do instead of a person?"

**The 4 Value Levers** (never name this framework to clients)
1. Dream outcome: paint the picture of their business post-automation
2. Perceived likelihood: use past work references and specific numbers
3. Time delay: "live within weeks, not months"
4. Effort reduction: we do the heavy lifting, the client just answers questions and reviews

**Numbers as Anchors**
Lead with the number, then explain. "$60K+ average annual savings" is the hook. "Here is how we get there" is the follow-up.

### Writing Rules

#### Do
- Open with the outcome or the number
- Use tables for anything with more than three data points
- Keep paragraphs to 2-3 sentences
- Show your math (visible input assumptions in pricing)
- Write "DRAFT" on all pricing with editable assumptions
- Frame automation as a teammate, not a replacement ("handles the repetitive parts so your team focuses on judgment calls")
- Reference past work when relevant (anonymized case studies)

#### Don't
- Summarize what you just did at the end of a response
- Explain what you are about to do before doing it
- Add disclaimers or qualifiers that weaken the message
- Use semicolons (rewrite as two sentences)
- Write in third person about the agency ("My New Agent provides..." should be "We build...")
- Over-explain. If the client did not ask, do not volunteer complexity.

### Audience Adaptations

| Audience | Adjust Toward | Example |
|----------|--------------|---------|
| Business owner (first meeting) | Warmer, more analogies, paint the dream | "Imagine opening your laptop Monday morning and your weekly report is already done." |
| Technical decision maker | More specific, include tool names, show architecture | "The n8n workflow triggers on webhook, validates the payload, and posts to your ERP's API." |
| Referral partner | Peer-to-peer, mutual benefit, shared language | "Your clients get better operations, you get a partner who does not step on your scope." |
| Skeptical buyer | Numbers-first, conservative estimates, show the math | "Even at 50% of our estimate, that is $23,000/year on one process. Setup pays for itself in 4 months." |

### Voice Test

Before publishing any agency content, check:

1. Does this sound like a person talking, not a brochure?
2. Is there at least one concrete number in the first two sentences?
3. Did we use "we" and "you" (not "My New Agent" and "the client")?
4. Zero em dashes?
5. Zero buzzwords from the never-use list?
6. Could a paragraph be shorter? Then make it shorter.

---

## Part 2: Visual Identity

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| Primary Background | #0F0F23 | Slides, website canvas, dark UI surfaces |
| Card Surface | #1A1A2E | Content cards, secondary backgrounds, code blocks in PDFs |
| Electric Blue | #00D4FF | CTAs, links, active states, accent lines, H2 borders in PDFs |
| Teal | #00C9A7 | Success states, secondary highlights, blockquote borders |
| Gold | #FFD700 | Key numbers, metrics, callouts, emphasis on stats |
| White | #FFFFFF | Body text on dark backgrounds, headings on dark |
| Light Gray | #BBBBBB | Secondary text, captions, footer text |

### Typography

| Context | Font | Fallback | Weight |
|---------|------|----------|--------|
| Presentations (.pptx) | Calibri | Arial | Regular / Bold |
| Web | Inter | system-ui, sans-serif | 400 / 700 |
| PDFs | Inter | Ubuntu Sans, DejaVu Sans, sans-serif | 400 / 700 |
| Code / monospace | JetBrains Mono | Courier New, monospace | 400 |

### Logo

Not yet created. Add logo to `brand/logo.png` when available. The PDF template and pitch deck will pick it up automatically.

### Style Elements

- Excalidraw hand-drawn aesthetic for diagrams and process flows
- Dark canvas (#0F0F23) with subtle dot grid pattern
- Rounded rectangles with sketchy borders for content nodes
- Arrow connectors between elements (hand-drawn style)
- Glass effects and subtle glows on web (Electric Blue glow on active elements)
- "Wobble" or "breathe" animation on interactive web elements

### PDF Branding

Client-facing deliverables (discovery questionnaires, SOPs, proposals) are delivered as branded PDFs. The PDF template applies:

- Header: "My New Agent" (left) + document title (right), Electric Blue separator
- Footer: "mynewagent.ai" (left) + page numbers (right), Light Gray separator
- H1: 24pt bold, navy, Electric Blue underline
- H2: 18pt bold, Electric Blue left border
- Tables: navy header row with white text, alternating gray/white body rows
- Blockquotes: Teal left border, light gray background

Generate PDFs with:
```bash
python3 pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py <markdown-file>
```

### Presentation Branding

Pitch decks and slides use the same color palette on dark backgrounds. Generated with:
```bash
python3 brand/generate_pitch.py
```
