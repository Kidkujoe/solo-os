#!/bin/bash

# solo-os uninstaller
# https://github.com/Kidkujoe/solo-os

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  solo-os uninstaller"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  This will remove all solo-os"
echo "  commands from Claude Code."
echo ""
echo "  Are you sure? Type yes to continue"
echo "  or no to cancel."
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -r CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo ""
  echo "  Cancelled. Nothing was removed."
  echo ""
  exit 0
fi

# ─── REMOVE COMMAND FILES ────────────────────

echo ""
echo "  Removing commands..."

rm -f ~/.claude/commands/test.md
rm -f ~/.claude/commands/test-quick.md
rm -f ~/.claude/commands/test-deep.md
rm -f ~/.claude/commands/report.md
rm -f ~/.claude/commands/resume.md
rm -f ~/.claude/commands/status.md
rm -f ~/.claude/commands/addaccount.md

echo "  ✓ Commands removed"

# ─── ASK ABOUT DATA ─────────────────────────

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Do you want to keep your saved test"
echo "  data and account details?"
echo ""
echo "  Your data includes:"
echo "  - Test accounts saved with /addaccount"
echo "  - Session history"
echo "  - HTML reports generated"
echo "  - Screenshots taken"
echo ""
echo "  Type keep to keep your data"
echo "  Type remove to delete everything"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -r DATA_CHOICE

if [ "$DATA_CHOICE" = "remove" ]; then
  rm -f ~/.claude/context/test-session.md
  rm -f ~/.claude/context/test-accounts.md
  rm -f ~/.claude/context/test-data.json
  rm -f ~/.claude/context/test-report.html
  rm -f ~/.claude/context/report-template.html
  rm -rf ~/.claude/context/screenshots/
  echo ""
  echo "  Everything removed including your data."
else
  echo ""
  echo "  Commands removed. Your data was kept at:"
  echo "  ~/.claude/context/"
fi

# ─── DONE ────────────────────────────────────

echo ""
echo "  ✅ solo-os has been uninstalled."
echo "  To reinstall run: sh install.sh"
echo ""
