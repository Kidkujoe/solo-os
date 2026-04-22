---
name: test-quick
description: Fast lightweight visual check with terminal summary only. Low token cost.
allowed-tools: Bash, mcp__chrome-devtools__*
---


===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run `pwd` to get the absolute project path.
Derive PROJECT_ID = [basename]-[6char hash of full path] using md5sum
(fall back to shasum if unavailable).
Set PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is NOT a project directory (is home, is ~/.claude,
no code files present), display PROJECT NOT DETECTED warning and stop.
Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS if missing:
mkdir -p $PROJECT_CONTEXT/atlas $PROJECT_CONTEXT/screenshots $PROJECT_CONTEXT/reports

STEP R3 - ALL PATHS (use these variables, never hardcode):
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
TEST_REPORT       = $PROJECT_CONTEXT/reports/test-report.html
COPY_REPORT       = $PROJECT_CONTEXT/reports/copy-report.html
COMPASS_REPORT    = $PROJECT_CONTEXT/reports/compass-report.html
EMPATHY_REPORT    = $PROJECT_CONTEXT/reports/empathy-report.html
ATLAS             = $PROJECT_CONTEXT/atlas
PRODUCT_MD        = $ATLAS/PRODUCT.md
DESIGN_MD         = $ATLAS/DESIGN.md
DECISIONS_MD      = $ATLAS/DECISIONS.md
DEPENDENCIES_MD   = $ATLAS/DEPENDENCIES.md
REGRESSIONS_MD    = $ATLAS/REGRESSIONS.md
HEALTH_MD         = $ATLAS/HEALTH.md
STRATEGY_MD       = $ATLAS/STRATEGY.md
VOICE_MD          = $ATLAS/VOICE.md
SEO_MD            = $ATLAS/SEO.md

Approved global resources (shared across all projects):
REPORT_TEMPLATE   = $REPORT_TEMPLATE
GLOBAL_ACCOUNTS   = ~/.claude/context/test-accounts-global.md

STEP R4 - VERIFY ISOLATION:
Every path used must start with $PROJECT_CONTEXT or be one of the two
approved globals. Any other ~/.claude/context/ path is a violation.

STEP R5 - DISPLAY CONFIRMATION (one line):
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CONTAMINATION CHECK:
If $SESSION_FILE exists, check its first line for `# Project: [id]`.
If stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning with options: archive + start fresh / show contents / stop.
Wait for user response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

TEST-ACCOUNTS USAGE:
When reading accounts, read $GLOBAL_ACCOUNTS and filter to the section
matching PROJECT_ID. Never read another project's section.
When writing accounts, update the $PROJECT_ID section only.

END OF RESOLVER — command-specific logic follows
===========================================

Run a quick visual check for: $ARGUMENTS

This is the low token cost mode. No code review.
No HTML report. Terminal summary only.

STEP 1 - LOAD CONTEXT
- Read $PRODUCT_MD silently if it exists
- Read $SESSION_FILE
- Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
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

STEP 3 - INJECT VISIBLE CURSOR SYSTEM
Before starting visual testing, inject the cursor overlay
into the browser using evaluate_script. This makes testing
visible and watchable in real time.

Inject this JavaScript on the page:

```javascript
(() => {
  if (document.getElementById('vtp-cursor')) return;

  const dot = document.createElement('div');
  dot.id = 'vtp-cursor';
  dot.style.cssText = `
    position: fixed; z-index: 999999; pointer-events: none;
    width: 18px; height: 18px; border-radius: 50%;
    background: rgba(139, 92, 246, 0.85);
    box-shadow: 0 0 12px 4px rgba(139, 92, 246, 0.4);
    transition: transform 0.15s ease, background 0.15s ease, box-shadow 0.15s ease;
    transform: translate(-50%, -50%);
    top: -100px; left: -100px;
  `;

  const ring = document.createElement('div');
  ring.id = 'vtp-ring';
  ring.style.cssText = `
    position: fixed; z-index: 999998; pointer-events: none;
    width: 18px; height: 18px; border-radius: 50%;
    border: 2px solid rgba(139, 92, 246, 0.6);
    transform: translate(-50%, -50%) scale(1);
    opacity: 0; top: -100px; left: -100px;
    transition: transform 0.4s ease-out, opacity 0.4s ease-out;
  `;

  const label = document.createElement('div');
  label.id = 'vtp-label';
  label.style.cssText = `
    position: fixed; z-index: 999999; pointer-events: none;
    background: rgba(139, 92, 246, 0.9); color: white;
    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
    font-size: 12px; font-weight: 500; padding: 4px 10px;
    border-radius: 6px; white-space: nowrap;
    transform: translate(16px, -50%);
    top: -100px; left: -100px;
    transition: opacity 0.2s ease;
  `;

  const bar = document.createElement('div');
  bar.id = 'vtp-status';
  bar.style.cssText = `
    position: fixed; bottom: 0; left: 0; right: 0;
    z-index: 999999; pointer-events: none;
    background: rgba(139, 92, 246, 0.92); color: white;
    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
    font-size: 13px; font-weight: 500;
    padding: 8px 20px; text-align: center;
    backdrop-filter: blur(8px);
  `;
  bar.textContent = 'visual-test-pro — Quick check starting...';

  document.body.append(dot, ring, label, bar);

  window.__vtpMoveTo = (x, y) => {
    dot.style.top = y + 'px'; dot.style.left = x + 'px';
    ring.style.top = y + 'px'; ring.style.left = x + 'px';
    label.style.top = y + 'px'; label.style.left = x + 'px';
  };
  window.__vtpClick = (x, y) => {
    dot.style.top = y + 'px'; dot.style.left = x + 'px';
    ring.style.top = y + 'px'; ring.style.left = x + 'px';
    dot.style.transform = 'translate(-50%, -50%) scale(0.6)';
    ring.style.opacity = '1';
    ring.style.transform = 'translate(-50%, -50%) scale(2.5)';
    setTimeout(() => {
      dot.style.transform = 'translate(-50%, -50%) scale(1)';
      ring.style.opacity = '0';
      ring.style.transform = 'translate(-50%, -50%) scale(1)';
    }, 350);
  };
  window.__vtpHover = (h) => {
    dot.style.background = h ? 'rgba(168, 85, 247, 0.95)' : 'rgba(139, 92, 246, 0.85)';
    dot.style.boxShadow = h ? '0 0 18px 6px rgba(168, 85, 247, 0.5)' : '0 0 12px 4px rgba(139, 92, 246, 0.4)';
    dot.style.transform = h ? 'translate(-50%, -50%) scale(1.3)' : 'translate(-50%, -50%) scale(1)';
  };
  window.__vtpLabel = (t) => { label.textContent = t; label.style.opacity = t ? '1' : '0'; };
  window.__vtpStatus = (t) => { bar.textContent = 'visual-test-pro — ' + t; };
  window.__vtpCleanup = () => {
    ['vtp-cursor','vtp-ring','vtp-label','vtp-status'].forEach(id => {
      const el = document.getElementById(id); if (el) el.remove();
    });
  };
})();
```

CURSOR USAGE RULES:
- After EVERY page navigation, re-inject the cursor script
- Before interacting with any element, move cursor to it
- Set the label to describe what you are checking:
  __vtpLabel("Checking this link works")
  __vtpLabel("Looking at the navigation")
- Update status bar for each page:
  __vtpStatus("Quick check — scanning homepage")
- Before EVERY screenshot call __vtpCleanup()
- After the screenshot, re-inject the cursor to continue

STEP 4 - QUICK VISUAL SCAN
For each public page (no login required):
- Navigate to the page
- Re-inject the cursor system after navigation
- Update status bar: "Quick check — scanning [page name]"
- Wait for full load
- Move cursor to key elements while checking them
- Label each check in plain English
- Screenshot the page (cleanup cursor first, reinject after)
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

STEP 5 - RESPONSIVE SPOT CHECK
Pick the main page and one other page:
- Test at desktop 1440px
- Test at mobile 375px
- Note any obvious layout breaks

STEP 6 - CONSOLE CHECK
- Capture any console errors
- Capture any failed network requests
- Ignore warnings unless they indicate a real problem

STEP 7 - TERMINAL SUMMARY
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
  Fixes are handled by a team of specialist
  agents working in parallel. Available in
  /test and /test-deep modes.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- Write findings to test-session.md
- Do NOT generate an HTML report

IMPORTANT RULES:
- Keep this fast and lightweight
- Do not expand scope beyond what is listed above
- Write findings to test-session.md when done
- If Chrome is not connected, stop immediately
