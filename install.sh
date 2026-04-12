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
mkdir -p ~/.claude/context/screenshots

# ─── COPY COMMAND FILES ───────────────────────

cp "$SCRIPT_DIR/commands/test.md" ~/.claude/commands/test.md
cp "$SCRIPT_DIR/commands/test-quick.md" ~/.claude/commands/test-quick.md
cp "$SCRIPT_DIR/commands/test-deep.md" ~/.claude/commands/test-deep.md
cp "$SCRIPT_DIR/commands/report.md" ~/.claude/commands/report.md
cp "$SCRIPT_DIR/commands/resume.md" ~/.claude/commands/resume.md
cp "$SCRIPT_DIR/commands/status.md" ~/.claude/commands/status.md
cp "$SCRIPT_DIR/commands/addaccount.md" ~/.claude/commands/addaccount.md

echo "  ✓ Commands installed"

# ─── COPY CONTEXT FILES ──────────────────────

cp "$SCRIPT_DIR/context/report-template.html" ~/.claude/context/report-template.html
echo "  ✓ Report template installed"

# Create data files only if they don't already exist
# This preserves existing test accounts and session data
if [ ! -f ~/.claude/context/test-session.md ]; then
  cp "$SCRIPT_DIR/context/test-session.md" ~/.claude/context/test-session.md
  echo "  ✓ Session file created"
else
  echo "  ✓ Existing session file preserved"
fi

if [ ! -f ~/.claude/context/test-accounts.md ]; then
  cp "$SCRIPT_DIR/context/test-accounts.md" ~/.claude/context/test-accounts.md
  echo "  ✓ Accounts file created"
else
  echo "  ✓ Existing accounts file preserved"
fi

if [ ! -f ~/.claude/context/test-data.json ]; then
  cp "$SCRIPT_DIR/context/test-data.json" ~/.claude/context/test-data.json
  echo "  ✓ Data file created"
else
  echo "  ✓ Existing data file preserved"
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
echo "  YOUR COMMANDS ARE READY:"
echo ""
echo "  /test         Smart test with options"
echo "  /test-quick   Fast daily check"
echo "  /test-deep    Full pre-launch review"
echo "  /report       Generate HTML report"
echo "  /resume       Continue a session"
echo "  /status       Check progress"
echo "  /addaccount   Save login details"
echo ""
echo "  TO GET STARTED:"
echo ""
echo "  1. Open your project folder"
echo "  2. Make sure Chrome is open"
echo "  3. Run: claude --chrome"
echo "  4. Start your app: npm run dev"
echo "  5. Type: /test"
echo ""
echo "  Claude will scan your project and"
echo "  give you options before starting."
echo ""
echo "  NEED HELP?"
echo "  Read the docs at:"
echo "  ~/visual-test-pro/docs/"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
