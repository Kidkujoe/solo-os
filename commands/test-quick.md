---
name: test-quick
description: Fast lightweight visual check with terminal summary only. Low token cost.
allowed-tools: Bash, mcp__chrome-devtools__*
---

Run a quick visual check for: $ARGUMENTS

This is the low token cost mode. No code review.
No HTML report. Terminal summary only.

STEP 1 - LOAD CONTEXT
- Read ~/.claude/context/test-session.md
- Read ~/.claude/context/test-accounts.md
- Check if a previous session exists

STEP 2 - PRE-TEST CHECKS
- Check Chrome is connected via MCP
  If not connected display:
  Chrome is not connected. Please:
  1. Open Chrome
  2. Run: claude --chrome
  3. Then type /test-quick again
  And stop.
- Check the dev server is running
  Try localhost:3000, localhost:3001,
  localhost:5173, localhost:8080
  If not running attempt: npm run dev
- Write session start to test-session.md

STEP 3 - QUICK VISUAL SCAN
For each public page (no login required):
- Navigate to the page
- Wait for full load
- Screenshot the page
- Check for obvious visual breaks
- Check for console errors
- Check all links and buttons are visible
- Check forms render correctly

Do NOT:
- Fill in forms
- Test form validation
- Click through every interaction
- Test restricted areas
- Do code review

STEP 4 - RESPONSIVE SPOT CHECK
Pick the main page and one other page:
- Test at desktop 1440px
- Test at mobile 375px
- Note any obvious layout breaks

STEP 5 - CONSOLE CHECK
- Capture any console errors
- Capture any failed network requests
- Ignore warnings unless they indicate a real problem

STEP 6 - TERMINAL SUMMARY
Display results directly in the terminal:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  QUICK CHECK COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pages checked: [count]
  Visual issues: [count or none]
  Console errors: [count or none]
  Responsive issues: [count or none]

  [List any issues found in plain English]

  Quick confidence: [score]/10

  Want a deeper test? Type /test
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- Write findings to test-session.md
- Do NOT generate an HTML report

IMPORTANT RULES:
- Keep this fast and lightweight
- Do not expand scope beyond what is listed above
- Write findings to test-session.md when done
- If Chrome is not connected, stop immediately
