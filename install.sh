#!/bin/bash

# visual-test-pro installer
# https://github.com/Kidkujoe/Visual-Test-Pro

set -e

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  visual-test-pro installer"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── CHECK REQUIREMENTS ───────────────────────

# Check Claude Code
if ! command -v claude &> /dev/null; then
  echo "  Claude Code is not installed."
  echo "  Install it with:"
  echo "  npm install -g @anthropic-ai/claude-code"
  echo "  Then run this installer again."
  echo ""
  exit 1
fi
echo "  ✓ Claude Code found"

# Check Node.js version
if ! command -v node &> /dev/null; then
  echo "  Node.js is not installed."
  echo "  Download it at https://nodejs.org"
  echo "  Install the LTS version then run"
  echo "  this installer again."
  echo ""
  exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  echo "  Node.js 18 or higher is required."
  echo "  You have Node.js v$(node -v | sed 's/v//')."
  echo "  Download it at https://nodejs.org"
  echo "  Install the LTS version then run"
  echo "  this installer again."
  echo ""
  exit 1
fi
echo "  ✓ Node.js v$(node -v | sed 's/v//') found"

# Check Chrome (warning only)
CHROME_FOUND=false
if command -v google-chrome &> /dev/null || \
   command -v google-chrome-stable &> /dev/null || \
   [ -f "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ] || \
   [ -f "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" ] || \
   [ -f "/c/Program Files/Google/Chrome/Application/chrome.exe" ] || \
   command -v chromium &> /dev/null || \
   command -v chromium-browser &> /dev/null; then
  CHROME_FOUND=true
fi

# Also check Windows paths from Git Bash / WSL
if [ "$CHROME_FOUND" = false ]; then
  if [ -f "$(echo $LOCALAPPDATA | sed 's|\\|/|g')/Google/Chrome/Application/chrome.exe" ] 2>/dev/null || \
     [ -f "$(echo $PROGRAMFILES | sed 's|\\|/|g')/Google/Chrome/Application/chrome.exe" ] 2>/dev/null; then
    CHROME_FOUND=true
  fi
fi

if [ "$CHROME_FOUND" = true ]; then
  echo "  ✓ Chrome found"
else
  echo ""
  echo "  ⚠ Chrome was not found on this machine."
  echo "  Visual browser testing requires Chrome."
  echo "  Download it at https://google.com/chrome"
  echo "  You can still use code review mode"
  echo "  without Chrome."
  echo ""
fi

# Check CodeRabbit CLI (info only)
if command -v coderabbit &> /dev/null || command -v cr &> /dev/null; then
  echo "  ✓ CodeRabbit found - will be used in deep test mode"
else
  echo ""
  echo "  ℹ CodeRabbit not found."
  echo "  Install it for the best test results:"
  echo "  curl -fsSL https://cli.coderabbit.ai/install.sh | sh"
  echo "  You can install it later - it is optional."
  echo ""
fi

# ─── CREATE FOLDERS ───────────────────────────

echo ""
echo "  Installing files..."
echo ""

mkdir -p ~/.claude/commands
mkdir -p ~/.claude/context
mkdir -p ~/.claude/context/projects

# ─── COPY ALL COMMAND FILES ───────────────────

cp "$SCRIPT_DIR/commands/"*.md ~/.claude/commands/
echo "  ✓ All commands installed"

# ─── COPY GLOBAL RESOURCES ONLY ──────────────
# Per-project files are created by the resolver at first command run
# inside each project folder. install.sh only creates global resources.

cp "$SCRIPT_DIR/context/report-template.html" ~/.claude/context/report-template.html
echo "  ✓ Report template installed (global)"

if [ ! -f ~/.claude/context/test-accounts-global.md ]; then
  touch ~/.claude/context/test-accounts-global.md
  echo "# Global Test Accounts" > ~/.claude/context/test-accounts-global.md
  echo "# Each project section is keyed by project identifier" >> ~/.claude/context/test-accounts-global.md
  echo "" >> ~/.claude/context/test-accounts-global.md
  echo "  ✓ Global accounts file created"
else
  echo "  ✓ Existing global accounts file preserved"
fi

# ─── MIGRATION CHECK ─────────────────────────
# Detect any v2.0.0 or earlier data at old global paths

NEEDS_MIGRATION=false
for f in test-session.md test-data.json agent-state.json edge-cases.md \
         COPYAI.md COMPASS.md EMPATHY.md test-report.html copy-report.html \
         compass-report.html empathy-report.html test-accounts.md; do
  if [ -f ~/.claude/context/"$f" ]; then
    NEEDS_MIGRATION=true
    break
  fi
done
if [ -d ~/.claude/context/atlas ] || [ -d ~/.claude/context/screenshots ]; then
  NEEDS_MIGRATION=true
fi

if [ "$NEEDS_MIGRATION" = true ]; then
  echo ""
  echo "  ⚠ Existing data found at old global paths."
  echo "  Run /atlas inside your project folder to trigger"
  echo "  the in-app migration wizard which will move data"
  echo "  to the correct per-project location and stamp it."
  echo ""
fi

# ─── REGISTER CHROME MCP SERVER ──────────────

echo ""
echo "  Registering Chrome MCP server..."

if claude mcp add chrome-devtools \
  --scope user \
  -- npx -y chrome-devtools-mcp@latest 2>/dev/null; then
  echo "  ✓ Chrome MCP server registered"
else
  echo ""
  echo "  ⚠ Chrome MCP could not be registered"
  echo "  automatically. You can set it up manually"
  echo "  by running /test and following the"
  echo "  Chrome setup guide that appears."
  echo ""
fi

# ─── SUCCESS ─────────────────────────────────

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ visual-test-pro installed successfully"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  HOW IT WORKS:"
echo ""
echo "  Each project gets its own isolated context folder."
echo "  Data from one project never affects another."
echo ""
echo "  When you run any command inside a project folder,"
echo "  a unique identifier is derived from the project path"
echo "  and all data is stored under that identifier."
echo ""
echo "  Project data lives at:"
echo "  ~/.claude/context/projects/[project-id]/"
echo ""
echo "  27 COMMANDS INSTALLED:"
echo "    Testing: /test /test-quick /test-deep /report /resume /status"
echo "    Atlas: /atlas /atlas-quick /atlas-map /atlas-check /atlas-feature"
echo "    Compass: /compass /compass-feature /compass-project /compass-retro"
echo "    Audits: /pillars /edgecases /design /seo /copy /copyai /copyai-research /empathy"
echo "    Utilities: /screenshots /addaccount /projects /vtpaudit"
echo ""
echo "  TO GET STARTED:"
echo ""
echo "  1. cd into your project folder"
echo "  2. claude --chrome"
echo "  3. Type: /atlas"
echo ""
echo "  The resolver creates your project's isolated context"
echo "  and Atlas builds the product brain."
echo ""
echo "  NEED HELP?"
echo "  Read the docs at:"
echo "  ~/visual-test-pro/docs/"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
