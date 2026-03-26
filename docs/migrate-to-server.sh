#!/usr/bin/env bash
# =============================================================================
# Migration Script: Claude Code Environment -> Home Server (mna@mna-server)
# Run this ON THE SERVER as user 'mna'
# =============================================================================
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

step() { echo -e "\n${GREEN}==> $1${NC}"; }
warn() { echo -e "${YELLOW}    WARNING: $1${NC}"; }
fail() { echo -e "${RED}    FAILED: $1${NC}"; exit 1; }
ok()   { echo -e "${GREEN}    OK${NC}"; }

# ---------------------------------------------------------------------------
# Phase 1: System Dependencies
# ---------------------------------------------------------------------------
step "Phase 1a: Installing system packages (WeasyPrint deps + jq)"
sudo apt update -qq
sudo apt install -y -qq \
  python3-pip python3-venv \
  libcairo2-dev libpango1.0-dev libgdk-pixbuf-2.0-dev libffi-dev \
  libxml2-dev libxslt1-dev shared-mime-info jq

step "Phase 1b: Installing Python packages"
pip3 install --user --quiet weasyprint markdown-it-py jinja2 reportlab python-pptx

step "Phase 1c: Installing npm global packages (gws CLI, agent-browser)"
sudo npm install -g @googleworkspace/cli agent-browser 2>/dev/null || true

step "Phase 1d: Ensuring ~/.local/bin is in PATH"
if ! grep -q '.local/bin' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/.local/bin:$PATH"

step "Phase 1: Verification"
python3 -c "import weasyprint; print('  weasyprint OK')" || warn "weasyprint import failed"
python3 -c "import markdown_it; print('  markdown-it OK')" || warn "markdown-it import failed"
python3 -c "import jinja2; print('  jinja2 OK')" || warn "jinja2 import failed"
python3 -c "import reportlab; print('  reportlab OK')" || warn "reportlab import failed"
python3 -c "import pptx; print('  python-pptx OK')" || warn "python-pptx import failed"
which gws >/dev/null 2>&1 && echo "  gws CLI OK" || warn "gws CLI not found"
which agent-browser >/dev/null 2>&1 && echo "  agent-browser OK" || warn "agent-browser not found"
jq --version >/dev/null 2>&1 && echo "  jq OK" || warn "jq not found"

# ---------------------------------------------------------------------------
# Phase 2: Clone Repository
# ---------------------------------------------------------------------------
step "Phase 2: Cloning repository"
mkdir -p /home/mna/projects
if [ -d /home/mna/projects/my-new-agent ]; then
  warn "Repository already exists, pulling latest instead"
  cd /home/mna/projects/my-new-agent
  git pull origin main
else
  cd /home/mna/projects
  git clone --recurse-submodules https://github.com/azr18/my-new-agent.git
  cd my-new-agent
fi

step "Phase 2: Verification"
[ -f /home/mna/projects/my-new-agent/CLAUDE.md ] && echo "  CLAUDE.md OK" || warn "CLAUDE.md missing"
[ -f /home/mna/projects/my-new-agent/.claude-plugin/marketplace.json ] && echo "  marketplace.json OK" || warn "marketplace.json missing"
[ -d /home/mna/projects/my-new-agent/google-workspace-plugin ] && echo "  google-workspace-plugin OK" || warn "google-workspace-plugin missing"
[ -d /home/mna/projects/my-new-agent/pdf-delivery-plugin ] && echo "  pdf-delivery-plugin OK" || warn "pdf-delivery-plugin missing"

# Set git identity
git config user.name "azr18"
git config user.email "ariel.r08@gmail.com"

# ---------------------------------------------------------------------------
# Phase 3: Claude Code Configuration
# ---------------------------------------------------------------------------
step "Phase 3a: Creating ~/.claude directory structure"
mkdir -p /home/mna/.claude/plugins
mkdir -p /home/mna/.claude/plans

step "Phase 3b: Creating settings.json"
cat > /home/mna/.claude/settings.json << 'SETTINGS'
{
  "permissions": {
    "defaultMode": "plan"
  },
  "statusLine": {
    "type": "command",
    "command": "bash /home/mna/.claude/statusline-command.sh"
  },
  "enabledPlugins": {
    "skill-creator@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true,
    "superpowers@claude-plugins-official": true,
    "client-onboarding@my-new-agent": true,
    "brand-voice-generator@my-new-agent": true,
    "pdf-delivery@my-new-agent": true,
    "cli-anything@cli-anything": true,
    "firecrawl@claude-plugins-official": true,
    "google-workspace@my-new-agent": true
  },
  "extraKnownMarketplaces": {
    "my-new-agent": {
      "source": {
        "source": "directory",
        "path": "/home/mna/projects/my-new-agent"
      }
    },
    "CLI-Anything": {
      "source": {
        "source": "github",
        "repo": "HKUDS/CLI-Anything"
      }
    },
    "cli-anything": {
      "source": {
        "source": "github",
        "repo": "HKUDS/CLI-Anything"
      }
    }
  },
  "effortLevel": "high",
  "skipDangerousModePermissionPrompt": true,
  "autoDreamEnabled": true
}
SETTINGS
ok

step "Phase 3c: Creating settings.local.json"
cat > /home/mna/.claude/settings.local.json << 'LOCAL'
{
  "permissions": {
    "allow": [
      "Bash(npx vite:*)",
      "Bash(./node_modules/.bin/vite build:*)",
      "Bash(node:*)"
    ]
  }
}
LOCAL
ok

step "Phase 3d: Creating statusline script (embedded, paths pre-fixed for /home/mna)"
cat > /home/mna/.claude/statusline-command.sh << 'STATUSLINE'
#!/usr/bin/env bash
# Claude Code status line script
# Layout:
#   Line 1: Model | tokens_used/tokens_total [bar] pct% | thinking: high/medium/low/off | $x.xx | $x.xx | $x.xx
#   Line 2: Current (5h): <progressbar> PCT% | Weekly (7d): <progressbar> PCT%
#   Line 3: reset: Current <time> | reset: Weekly <date time>

input=$(cat)

# ---------------------------------------------------------------------------
# ANSI colours using RGB (256-color sequences)
# ---------------------------------------------------------------------------
RESET=$'\033[0m'
DIM=$'\033[2m'
BLUE=$'\033[38;2;0;153;255m'
ORANGE=$'\033[38;2;255;176;85m'
GREEN=$'\033[38;2;0;160;0m'
CYAN=$'\033[38;2;46;149;153m'
RED=$'\033[38;2;255;85;85m'
YELLOW=$'\033[38;2;230;200;0m'
WHITE=$'\033[38;2;220;220;220m'

# 256-color codes for bar/percentage coloring
BAR_RED=$'\033[38;5;196m'
BAR_RED_BLINK=$'\033[5m\033[38;5;196m'
BAR_ORANGE=$'\033[38;5;208m'
BAR_YELLOW=$'\033[38;5;220m'
BAR_GREEN=$'\033[38;5;29m'
BAR_GRAY=$'\033[38;5;240m'

# ---------------------------------------------------------------------------
# Helper: pick a 256-color bar colour based on a percentage
# ---------------------------------------------------------------------------
pct_color() {
  local pct="$1"
  local pct_int
  pct_int=$(printf "%.0f" "$pct")
  if   [ "$pct_int" -gt 95 ]; then printf '%s' "${BAR_RED_BLINK}"
  elif [ "$pct_int" -gt 85 ]; then printf '%s' "${BAR_ORANGE}"
  elif [ "$pct_int" -gt 70 ]; then printf '%s' "${BAR_YELLOW}"
  else                              printf '%s' "${BAR_GREEN}"
  fi
}

# ---------------------------------------------------------------------------
# Helper: render a block-style progress bar, width=10
# ---------------------------------------------------------------------------
progress_bar() {
  local pct="$1"
  local width=10
  local filled
  filled=$(printf "%.0f" "$(echo "$pct $width" | awk '{printf "%.0f", $1 * $2 / 100}')")
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$(( width - filled ))
  local fill_col
  fill_col=$(pct_color "$pct")
  local bar=""
  local i
  for (( i=0; i<filled; i++ )); do bar="${bar}${fill_col}█"; done
  for (( i=0; i<empty;  i++ )); do bar="${bar}${RESET}${BAR_GRAY}░"; done
  bar="${bar}${RESET}"
  printf '%s' "$bar"
}

# ---------------------------------------------------------------------------
# Helper: format token count (>=1M -> "1.0m", >=1K -> "50k", else raw)
# ---------------------------------------------------------------------------
fmt_tokens() {
  local n="$1"
  if [ -z "$n" ] || [ "$n" = "null" ]; then
    printf '0'
    return
  fi
  echo "$n" | awk '{
    if ($1 >= 1000000)      printf "%.1fm", $1/1000000
    else if ($1 >= 1000)    printf "%.0fk", $1/1000
    else                    printf "%d", $1
  }'
}

# ---------------------------------------------------------------------------
# Helper: format a unix epoch timestamp
# ---------------------------------------------------------------------------
fmt_epoch() {
  local epoch="$1"
  local mode="${2:-short}"
  if [ -z "$epoch" ] || [ "$epoch" = "null" ]; then
    printf ''
    return
  fi
  if [ "$mode" = "long" ]; then
    date -d "@${epoch}" +"%-d, %-I:%M%P" 2>/dev/null | awk '{
      cmd="date -d @'"$epoch"' +%a"
      cmd | getline dow; close(cmd)
      printf "%s %s", dow, $0
    }'
  else
    date -d "@${epoch}" +"%-I:%M%P" 2>/dev/null
  fi
}

# ---------------------------------------------------------------------------
# Helper: format a dollar cost amount
# ---------------------------------------------------------------------------
fmt_cost() {
  local amount="$1"
  echo "$amount" | awk '{
    if ($1 < 100) printf "$%.2f", $1
    else          printf "$%.0f", $1
  }'
}

# ---------------------------------------------------------------------------
# Parse input JSON
# ---------------------------------------------------------------------------
model=$(echo "$input" | jq -r '.model.display_name // empty')

ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
cur_in=$(echo "$input"  | jq -r '.context_window.current_usage.input_tokens // 0')
cur_out=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
cur_cc=$(echo "$input"  | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cur_cr=$(echo "$input"  | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

# Session-level totals
sess_in=$(echo "$input"  | jq -r '.context_window.total_input_tokens // 0')
sess_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Model ID for pricing
model_id=$(echo "$input" | jq -r '.model.id // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')

# Total tokens used = input + cache_creation + cache_read
tokens_used=$(( cur_in + cur_cc + cur_cr ))

used_pct=$(echo "$input"      | jq -r '.context_window.used_percentage // empty')
remain_pct=$(echo "$input"    | jq -r '.context_window.remaining_percentage // empty')

five_pct=$(echo "$input"      | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input"    | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input"      | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input"    | jq -r '.rate_limits.seven_day.resets_at // empty')

# ---------------------------------------------------------------------------
# Cost calculations
# ---------------------------------------------------------------------------
cost_seg=""

read -r rate_in rate_out rate_cw rate_cr <<< "$(echo "$model_id" | awk '{
  id = $0
  if (index(id, "claude-opus-4") > 0)
    printf "15 75 18.75 1.50"
  else
    printf "3 15 3.75 0.30"
}')"

chat_cost=$(awk -v in_tok="$cur_in" -v out_tok="$cur_out" \
               -v cc_tok="$cur_cc" -v cr_tok="$cur_cr" \
               -v r_in="$rate_in" -v r_out="$rate_out" \
               -v r_cw="$rate_cw" -v r_cr="$rate_cr" \
  'BEGIN {
    cost = (in_tok * r_in + out_tok * r_out + cc_tok * r_cw + cr_tok * r_cr) / 1000000
    printf "%.6f", cost
  }')

sess_cost=$(awk -v in_tok="$sess_in" -v out_tok="$sess_out" \
               -v r_in="$rate_in" -v r_out="$rate_out" \
  'BEGIN {
    cost = (in_tok * r_in + out_tok * r_out) / 1000000
    printf "%.6f", cost
  }')

# ---------------------------------------------------------------------------
# Weekly cost log
# ---------------------------------------------------------------------------
COST_LOG="/home/mna/.claude/cost-log.csv"

[ -f "$COST_LOG" ] || touch "$COST_LOG"

if [ -n "$session_id" ] && [ "$session_id" != "null" ]; then
  last_logged=$(awk -F',' -v sid="$session_id" '
    $2 == sid { last = $3 }
    END { print last+0 }
  ' "$COST_LOG")

  changed=$(awk -v cur="$sess_cost" -v prev="$last_logged" \
    'BEGIN { print (cur != prev) ? "1" : "0" }')

  if [ "$changed" = "1" ]; then
    now_epoch=$(date +%s)
    printf '%s\n' "${now_epoch},${session_id},${sess_cost}" >> "$COST_LOG"
  fi
fi

week_ago=$(date -d '7 days ago' +%s 2>/dev/null || date -v-7d +%s 2>/dev/null)
weekly_cost=$(awk -F',' -v cutoff="$week_ago" '
  $1 >= cutoff {
    sessions[$2] = $3
  }
  END {
    total = 0
    for (sid in sessions) total += sessions[sid]
    printf "%.6f", total
  }
' "$COST_LOG")

chat_cost_fmt=$(fmt_cost "$chat_cost")
sess_cost_fmt=$(fmt_cost "$sess_cost")
weekly_cost_fmt=$(fmt_cost "$weekly_cost")

cost_seg="${WHITE}| ${CYAN}${chat_cost_fmt}${RESET} ${WHITE}| ${CYAN}${sess_cost_fmt}${RESET} ${WHITE}| ${CYAN}${weekly_cost_fmt}${RESET}"

# ---------------------------------------------------------------------------
# Thinking status
# ---------------------------------------------------------------------------
effort_level=$(jq -r '.effortLevel // empty' /home/mna/.claude/settings.json 2>/dev/null)
case "$effort_level" in
  high)   thinking_label="${ORANGE}high${RESET}" ;;
  medium) thinking_label="${YELLOW}medium${RESET}" ;;
  low)    thinking_label="${GREEN}low${RESET}" ;;
  *)      thinking_label="${DIM}off${RESET}" ;;
esac

# ---------------------------------------------------------------------------
# LINE 1
# ---------------------------------------------------------------------------
line1=""
if [ -n "$model" ]; then
  line1="${BLUE}${model}${RESET}"
fi

tok_used_fmt=$(fmt_tokens "$tokens_used")
tok_total_fmt=$(fmt_tokens "$ctx_size")

if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  used_pct_int=$(printf "%.0f" "$used_pct")
  used_col=$(pct_color "$used_pct")
  ctx_bar=$(progress_bar "$used_pct")
  line1="${line1} ${WHITE}|${RESET} ${WHITE}${tok_used_fmt}/${tok_total_fmt}${RESET} ${ctx_bar} ${used_col}${used_pct_int}%${RESET}"
fi

line1="${line1} ${WHITE}|${RESET} ${WHITE}thinking:${RESET} ${thinking_label}"
[ -n "$cost_seg" ] && line1="${line1} ${cost_seg}"

# ---------------------------------------------------------------------------
# LINE 2
# ---------------------------------------------------------------------------
line2=""
if [ -n "$five_pct" ] && [ "$five_pct" != "null" ]; then
  five_int=$(printf "%.0f" "$five_pct")
  five_col=$(pct_color "$five_pct")
  five_bar=$(progress_bar "$five_pct")
  line2="${CYAN}Current (5h):${RESET} ${five_bar} ${five_col}${five_int}${WHITE}%${RESET}"
fi

if [ -n "$week_pct" ] && [ "$week_pct" != "null" ]; then
  week_int=$(printf "%.0f" "$week_pct")
  week_col=$(pct_color "$week_pct")
  week_bar=$(progress_bar "$week_pct")
  week_seg="${CYAN}Weekly (7d):${RESET} ${week_bar} ${week_col}${week_int}${WHITE}%${RESET}"
  if [ -n "$line2" ]; then
    line2="${line2} ${WHITE}|${RESET} ${week_seg}"
  else
    line2="${week_seg}"
  fi
fi

# ---------------------------------------------------------------------------
# LINE 3
# ---------------------------------------------------------------------------
line3=""
if [ -n "$five_reset" ] && [ "$five_reset" != "null" ]; then
  five_reset_fmt=$(fmt_epoch "$five_reset" "short")
  line3="${DIM}reset: Current${RESET} ${CYAN}${five_reset_fmt}${RESET}"
fi

if [ -n "$week_reset" ] && [ "$week_reset" != "null" ]; then
  week_reset_fmt=$(fmt_epoch "$week_reset" "long")
  week_reset_seg="${DIM}reset: Weekly${RESET} ${CYAN}${week_reset_fmt}${RESET}"
  if [ -n "$line3" ]; then
    line3="${line3} ${WHITE}|${RESET} ${week_reset_seg}"
  else
    line3="${week_reset_seg}"
  fi
fi

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
printf '%s\n' "$line1"
[ -n "$line2" ] && printf '%s\n' "$line2"
[ -n "$line3" ] && printf '%s\n' "$line3"
STATUSLINE
chmod +x /home/mna/.claude/statusline-command.sh
ok

step "Phase 3e: Initializing cost log"
touch /home/mna/.claude/cost-log.csv
ok

step "Phase 3f: Blocklist"
# Create the blocklist directly (it has no path references)
cat > /home/mna/.claude/plugins/blocklist.json << 'BLOCKLIST'
{
  "fetchedAt": "2026-03-26T22:02:59.989Z",
  "plugins": [
    {
      "plugin": "code-review@claude-plugins-official",
      "added_at": "2026-02-11T03:16:31.424Z",
      "reason": "just-a-test",
      "text": "This is a test #5"
    },
    {
      "plugin": "fizz@testmkt-marketplace",
      "added_at": "2026-02-12T00:00:00.000Z",
      "reason": "security",
      "text": "this is a security test"
    }
  ]
}
BLOCKLIST
ok

step "Phase 3: Verification"
grep -q '/home/ariel' /home/mna/.claude/settings.json && warn "Stale paths in settings.json!" || echo "  settings.json paths OK"
if [ -f /home/mna/.claude/statusline-command.sh ]; then
  grep -q '/home/ariel' /home/mna/.claude/statusline-command.sh && warn "Stale paths in statusline!" || echo "  statusline paths OK"
fi

# ---------------------------------------------------------------------------
# Phase 4: Memory Files
# ---------------------------------------------------------------------------
step "Phase 4a: Creating memory directory"
MEMORY_DIR="/home/mna/.claude/projects/-home-mna-projects-my-new-agent/memory"
mkdir -p "$MEMORY_DIR"

step "Phase 4b: Creating MEMORY.md index"
cat > "$MEMORY_DIR/MEMORY.md" << 'MEMINDEX'
# Memory Index

- [user_ariel_profile.md](user_ariel_profile.md) -- Ariel owns both mynewagent.ai and Tabletops by Nomi (his own e-commerce business, agency case study)
- [feedback_n8n_cloud_plan.md](feedback_n8n_cloud_plan.md) -- n8n: Cloud cannot use $env, self-hosted can
- [project_gws_skills.md](project_gws_skills.md) -- GWS CLI authed, 93 base skills deployed, Layer 2 (mna-* agency skills) not yet started
- [project_savings_blog_direction.md](project_savings_blog_direction.md) -- Savings client wants lifestyle/magazine articles, not formal technical insurance content
MEMINDEX
ok

step "Phase 4c: Creating user profile memory"
cat > "$MEMORY_DIR/user_ariel_profile.md" << 'MEM1'
---
name: Ariel - agency owner and Tabletops by Nomi operator
description: Ariel runs mynewagent.ai AND owns Tabletops by Nomi (bynomi-bd) -- his own luxury e-commerce business used as the agency's flagship case study
type: user
---

Ariel owns both the agency (My New Agent / mynewagent.ai) and Tabletops by Nomi, a luxury custom tablecloth e-commerce business. The bynomi-bd codebase at `clients/tabletops-by-nomi/bynomi-bd/` is Ariel's own product, not a third-party client's.

Tabletops by Nomi serves as the agency's retrospective case study and proof of work: 50 phases shipped, 19 n8n workflows, $54K/year documented automation value. When Ariel asks about tabletops-by-nomi, he's working on his own business with full context and ownership.

GitHub: azr18. Email: ariel.r08@gmail.com. GWS domain: mynewagent.ai (ariel@mynewagent.ai).
MEM1
ok

step "Phase 4d: Creating n8n memory (updated for dual-instance)"
cat > "$MEMORY_DIR/feedback_n8n_cloud_plan.md" << 'MEM2'
---
name: n8n environment - cloud vs self-hosted
description: Two n8n instances available. Cloud (mynewagent3.app.n8n.cloud) cannot use $env variables. Self-hosted (localhost:5678) CAN use $env variables.
type: feedback
---

Two n8n instances are available:

1. **n8n Cloud** (mynewagent3.app.n8n.cloud) -- Do NOT use `{{ $env.VARIABLE }}` in workflows. Environment variables are Enterprise-only on Cloud.

2. **Self-hosted n8n** (http://localhost:5678, Docker on mna-server) -- CAN use `{{ $env.VARIABLE }}` expressions. Environment variables work on self-hosted instances.

**Why:** The Cloud plan restriction caused recurring errors when the MCP server tried to use $env. The self-hosted instance running in Docker on the home server has no such limitation.

**How to apply:** When creating or updating n8n workflows, ask which instance is the target. For Cloud, hardcode values or use n8n's credential system. For self-hosted, env vars are fine.
MEM2
ok

step "Phase 4e: Creating GWS skills memory"
cat > "$MEMORY_DIR/project_gws_skills.md" << 'MEM3'
---
name: Google Workspace Skills Project
description: GWS CLI installed and authed for mynewagent.ai -- 93 base skills deployed, Layer 2 (agency-tailored mna-* skills) not yet started
type: project
---

GWS CLI (`@googleworkspace/cli`) installed globally, authenticated as ariel@mynewagent.ai (project: mynewagent-workspace-491314). Auth uses OS keyring.

**Layer 1 complete (2026-03-25):** 93 base skills (42 service, 10 persona, 41 recipe) in `google-workspace-plugin/skills/` and registered in `.claude-plugin/marketplace.json`.

**Layer 2 not started (as of 2026-03-25):** No `mna-*` skill directories exist yet. The plan file (`/home/mna/.claude/plans/iridescent-percolating-origami.md`) is a reusable prompt template for creating each agency skill, not a step-by-step plan.

**Priority order:** Gmail > Calendar > Drive > Docs > Sheets > Contacts > Tasks > Forms > Slides > Keep > Classroom > Admin

**Why:** So Claude can operate the agency's Google Workspace directly -- send client emails, manage calendar, organize Drive files, create docs, etc.

**How to apply:** To create an agency skill, use the prompt template in the plan file. Each skill goes at `google-workspace-plugin/skills/mna-{service}/SKILL.md`, wrapping the base GWS skill with agency workflows and guardrails.
MEM3
ok

step "Phase 4f: Creating savings blog memory"
cat > "$MEMORY_DIR/project_savings_blog_direction.md" << 'MEM4'
---
name: Savings blog content direction
description: Savings.co.il client wants lifestyle/magazine articles, NOT formal technical insurance content
type: project
---

Savings client (savings.co.il) clarified blog automation direction (2026-03-26): content should be lifestyle "fluff pieces" for a magazine section, not formal technical policy/insurance articles.

**Why:** Client explicitly stated they want less formal, more lifestyle-oriented content. The existing blog ("Living in Plus") has been doing technical guides, but the automation should target a different, lighter tone.

**How to apply:** When building the blog automation SOP, content templates, and any AI prompting strategy, optimize for casual lifestyle writing -- not SEO-heavy financial education. This affects tone, structure, compliance needs (lighter content likely needs less regulatory review), and example outputs used in demos/proposals.
MEM4
ok

# ---------------------------------------------------------------------------
# Phase 4g: Copy plan files from repo into ~/.claude/plans/
# ---------------------------------------------------------------------------
step "Phase 4g: Copying plan files"
if [ -f /home/mna/projects/my-new-agent/docs/gws-agency-skill-template.md ]; then
  cp /home/mna/projects/my-new-agent/docs/gws-agency-skill-template.md \
     /home/mna/.claude/plans/iridescent-percolating-origami.md
  echo "  GWS agency skill template copied to plans/"
fi
ok

# ---------------------------------------------------------------------------
# Phase 7: Fix Hardcoded Paths in Repo
# ---------------------------------------------------------------------------
step "Phase 7a: Fixing SKILL.md excalidraw path"
cd /home/mna/projects/my-new-agent
sed -i 's|/home/ariel/.claude/mcp-servers/excalidraw-mcp|/home/mna/.claude/plugins/marketplaces/cli-anything/excalidraw|g' \
  client-onboarding-plugin/skills/client-onboarding/SKILL.md
ok

step "Phase 7b: Updating CLAUDE.md tech stack"
sed -i 's|WSL2 (Ubuntu on Windows), Node.js v20 via nvm|Ubuntu Server 24.04 (Dell OptiPlex 7050), Node.js v22|g' CLAUDE.md
ok

step "Phase 7: Verification"
grep -q '/home/ariel' client-onboarding-plugin/skills/client-onboarding/SKILL.md && warn "Stale paths in SKILL.md!" || echo "  SKILL.md paths OK"
grep -q 'Ubuntu Server 24.04' CLAUDE.md && echo "  CLAUDE.md tech stack OK" || warn "CLAUDE.md not updated"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}  Migration script complete!${NC}"
echo -e "${GREEN}================================================================${NC}"
echo ""
echo "Remaining manual steps:"
echo ""
echo "  1. PLUGINS - Launch Claude Code to trigger automatic plugin installation:"
echo "     cd /home/mna/projects/my-new-agent && claude"
echo ""
echo "  2. GWS AUTHENTICATION:"
echo "     gws auth login --no-browser"
echo "     (Follow OAuth flow for ariel@mynewagent.ai)"
echo ""
echo "  3. n8n API KEY:"
echo "     Get API key from http://100.86.110.81:5678"
echo "     echo 'export N8N_API_KEY=\"your-key\"' >> ~/.bashrc && source ~/.bashrc"
echo ""
echo "  4. COMMIT PATH FIXES:"
echo "     cd /home/mna/projects/my-new-agent"
echo "     git add -A && git commit -m 'Update paths for home server (mna@mna-server)' && git push"
echo ""
echo "  5. VERIFY:"
echo "     python3 pdf-delivery-plugin/skills/pdf-delivery/references/generate_pdf.py clients/savings/deliverables/discovery/discovery-questionnaire.md"
echo "     gws auth whoami"
echo "     curl -s http://localhost:5678/healthz"
echo ""
