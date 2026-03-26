---
name: "brand-voice-generator"
description: "Define and maintain the agency brand guide: writing voice, visual identity, colors, fonts, and logo usage. Triggers on: brand guide, brand voice, update brand, visual identity, brand colors, brand fonts, brand assets, agency brand, brand style, how should we sound, brand identity, brand guidelines, brand guide update, our brand."
---

# Brand Voice Generator

You define and maintain the My New Agent brand. This skill generates the agency brand guide, which covers two things: how we write (voice) and how we look (visual identity). All other skills reference this guide for consistency.

This skill is agency-only. It does not profile client voices.

## Workflow Overview

| Step | Name | Key Output |
|------|------|------------|
| 1 | Brand Guide Generation | `brand/brand-guide.md` |
| 2 | Brand Asset Verification | Consistency check across all brand files |

---

## Step 1: Brand Guide Generation

### Check Existing State

1. Check if `~/my-new-agent/brand/brand-guide.md` already exists.
2. If it exists, read it and ask: "The brand guide already exists. Do you want to update it, or start fresh?"
3. If starting fresh or creating for the first time, read these source files:
   - `references/mna-brand-voice.md` for the voice baseline (core attributes, vocabulary, writing rules)
   - `~/my-new-agent/brand/generate_pitch.py` for the canonical color constants
   - `~/my-new-agent/brand/website-prompt.txt` for visual style and web brand voice
4. Ask the user about gaps only: "Is there anything about the agency brand that has shifted? New visual elements, tone adjustments, a logo file?"

### Generate `brand/brand-guide.md`

Write the brand guide with two parts:

```markdown
# My New Agent - Brand Guide

**Last updated:** {date}

---

## Part 1: Voice

### Voice Character

{2-3 sentences describing how the agency sounds. Pull from mna-brand-voice.md.}

### Core Attributes

#### 1. {Attribute}
{Description with concrete examples}

#### 2. {Attribute}
{Description with concrete examples}

#### 3. {Attribute}
{Description with concrete examples}

### Vocabulary

#### Always Use
{Bulleted list: "we"/"you", concrete numbers, time framing, process language, ROI language}

#### Never Use
{Bulleted list: em dashes, corporate buzzwords, AI patterns, vague claims, passive voice}

#### Signature Devices

**The Client Handoff Analogy**
{Updated analogy: client hands off tasks to us, we document everything, then identify what machines can do}

**The 4 Value Levers** (never name this framework to clients)
{Dream outcome, perceived likelihood, time delay, effort reduction}

**Numbers as Anchors**
{Lead with the number, then explain}

### Writing Rules

#### Do
{Bulleted list}

#### Don't
{Bulleted list}

### Audience Adaptations

| Audience | Adjust Toward | Example |
|----------|--------------|---------|
| {audience} | {adjustment} | {example} |

### Voice Test

Before publishing, check:
1. {question}
2. {question}
...

---

## Part 2: Visual Identity

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| Primary Background | #0F0F23 | Slides, PDF headers, website canvas |
| Card Surface | #1A1A2E | Content cards, secondary backgrounds |
| Electric Blue | #00D4FF | CTAs, links, active states, accent lines |
| Teal | #00C9A7 | Success states, secondary highlights |
| Gold | #FFD700 | Key numbers, metrics, callouts |
| White | #FFFFFF | Body text on dark, headings on dark |
| Light Gray | #BBBBBB | Secondary text, captions |

### Typography

| Context | Font | Fallback |
|---------|------|----------|
| Presentations (.pptx) | Calibri | Arial |
| Web | Inter | system-ui, sans-serif |
| PDFs | Inter | Ubuntu Sans, DejaVu Sans |

### Logo

{Path to logo file, or: "Not yet created. Add logo to brand/ when available. The PDF and presentation templates will pick it up automatically."}

### Style Elements

- Excalidraw hand-drawn aesthetic for diagrams
- Dark canvas with dot grid pattern
- Rounded rectangles with sketchy borders
- Arrow connectors between elements
- Glass effects and subtle glows on web
```

---

## Step 2: Brand Asset Verification

After generating or updating the brand guide, check consistency:

1. **CLAUDE.md writing style** (lines 80+): Confirm the brand guide voice rules match. Flag any contradictions.
2. **`brand/generate_pitch.py`** color constants: Confirm the hex values in the brand guide match the script.
3. **`brand/website-prompt.txt`** (lines 14-22, 71-75): Confirm visual style and brand voice sections align.
4. **`brand/process-overview.excalidraw`**: Confirm this agency methodology diagram exists in the brand directory.
5. **PDF delivery skill**: Confirm `pdf-delivery-plugin/skills/pdf-delivery/references/pdf-style.css` uses the same color values as the brand guide.

Report results to the user. If anything is inconsistent, list the specific contradictions and offer to fix them.

---

## Reference Files

| File | Purpose |
|------|---------|
| `references/mna-brand-voice.md` | Agency voice baseline: core attributes, vocabulary, writing rules, audience adaptations. Source of truth for Part 1 of the brand guide. |

---

## Checklist

- [ ] Brand guide exists at `brand/brand-guide.md`
- [ ] Voice section matches CLAUDE.md writing style
- [ ] Colors match `generate_pitch.py` constants
- [ ] Visual style matches `website-prompt.txt`
- [ ] Process overview exists in `brand/`
- [ ] No em dashes, buzzwords, or AI patterns in the guide
- [ ] User informed about downstream usage (all skills reference this guide)
