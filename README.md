# My New Agent — Claude Code Plugin

Client onboarding workflow plugin for AI automation agencies. Provides an end-to-end 5-step workflow:

1. **Client Setup & Prep** — directory creation, process overview diagram, discovery questionnaire, internal client profile
2. **SOP Documentation** — one SOP per process with automation ratings and annual value calculations
3. **Process Flow Diagrams** — before/after Excalidraw diagrams showing automation impact
4. **Scoping & Pricing Proposal** — client-facing proposal with ROI calculations
5. **Speaking Notes** — internal meeting prep with objection handling

## Installation

Add this to your `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "my-new-agent": {
      "source": {
        "source": "github",
        "repo": "GITHUB_USERNAME/my-new-agent"
      }
    }
  },
  "enabledPlugins": {
    "client-onboarding@my-new-agent": true
  }
}
```

Replace `GITHUB_USERNAME` with the actual GitHub username or org. Then restart Claude Code.

## Usage

Invoke with `/client-onboarding` or use trigger phrases:

- "new client", "onboard", "discovery session"
- "scope this", "price this automation"
- "client proposal", "meeting prep", "SOP"
- "speaking notes", "process flow", "automation opportunity"

## Structure

```
client-onboarding-plugin/
├── .claude-plugin/plugin.json
└── skills/client-onboarding/
    ├── SKILL.md                    — Main skill definition
    └── references/
        ├── discovery-questions.md  — 51 discovery questions by category
        └── past-work.md           — Case studies for social proof
```
