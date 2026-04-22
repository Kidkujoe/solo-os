---
name: test
description: Smart visual browser test with project scan, token options menu, fix decision flow and plain English reporting
allowed-tools: Bash, mcp__chrome-devtools__*
---

===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run: pwd to get the absolute project path.
Take the folder basename. Add a 6-character hash of the full path
(try md5sum first, fall back to shasum). Format as:
PROJECT_ID = [basename]-[6char-hash]
PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is not a project directory (is home, is
~/.claude, has no code files), display PROJECT NOT DETECTED
warning and stop. Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS:
mkdir -p $PROJECT_CONTEXT
mkdir -p $PROJECT_CONTEXT/atlas
mkdir -p $PROJECT_CONTEXT/screenshots
mkdir -p $PROJECT_CONTEXT/reports

STEP R3 - ESTABLISH ALL FILE PATHS:
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
REPORTS           = $PROJECT_CONTEXT/reports
TEST_REPORT       = $REPORTS/test-report.html
COPY_REPORT       = $REPORTS/copy-report.html
COMPASS_REPORT    = $REPORTS/compass-report.html
EMPATHY_REPORT    = $REPORTS/empathy-report.html
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

Global resources (shared across all projects):
REPORT_TEMPLATE   = ~/.claude/context/report-template.html
GLOBAL_ACCOUNTS   = ~/.claude/context/test-accounts-global.md

STEP R4 - VERIFY ISOLATION:
Every file path used in this command must either start with
$PROJECT_CONTEXT or be one of the two approved global resources.
If any other ~/.claude/context/ path is referenced, stop and report.

STEP R5 - DISPLAY CONTEXT CONFIRMATION:
Display a one-line confirmation so user can see which project:
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CHECK FOR CONTAMINATION:
If SESSION_FILE exists, check its first line for:
  # Project: [project-id]
If the stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning and ask user: 1) archive and start fresh, 2) show contents,
3) stop. Wait for response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

STEP R8 - KNOWLEDGE BRIDGE INITIALIZATION (v2.3.0+):
Read $STRATEGY_MD if it exists and extract the line:
  Obsidian vault: [path]
If found set OBSIDIAN_VAULT to that path.
If not found default to: OBSIDIAN_VAULT="$HOME/Documents/SecondBrain"

Derive these paths:
  OBSIDIAN_PRODUCTS="$OBSIDIAN_VAULT/Products"
  OBSIDIAN_RESEARCH="$OBSIDIAN_VAULT/Research"
  OBSIDIAN_PATTERNS="$OBSIDIAN_VAULT/Patterns"
  OBSIDIAN_INBOX="$OBSIDIAN_VAULT/Inbox"
  OBSIDIAN_PRODUCT_DIR="$OBSIDIAN_PRODUCTS/$PROJECT_NAME"

Check vault exists. If not found display:
  Obsidian vault not found at $OBSIDIAN_VAULT
  Knowledge Bridge disabled for this run.
  Set up Obsidian to enable. Continuing without it.
Then set OBSIDIAN_BRIDGE=off and skip all bridge calls.

If vault exists but $OBSIDIAN_PRODUCT_DIR is missing, create:
  mkdir -p "$OBSIDIAN_PRODUCT_DIR"/{Features,Decisions,Insights,Reviews}

Set OBSIDIAN_BRIDGE=on. Commands should call read/write functions
defined in RESOLVER.md § KNOWLEDGE_BRIDGE at their specified hooks.

END OF RESOLVER — continue with command logic below
===========================================

Run a smart visual browser test for: $ARGUMENTS

STEP 1 - LOAD CONTEXT AND CHECK AGENT STATE
- Read $PRODUCT_MD silently if it exists (gives full product context)
- Read $SESSION_FILE
- Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
- Read $AGENT_STATE if it exists
- Check if a test account exists for this project
- Check if a previous session exists

If agent-state.json contains an incomplete session for
this project (paused_at is not null, or last_updated
within 24 hours and status is not complete, and project
path matches):

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  UNFINISHED SESSION FOUND
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project: [name]
  Started: [when]
  Last active: [how long ago]

  WHAT WAS HAPPENING:
  Testing: [what was being tested]
  Mode: [which mode]

  AGENT TEAM STATUS WHEN INTERRUPTED:
  [emoji] [agent name]  [status] - [task]
  [for each agent that was active]

  PROGRESS SO FAR:
  Issues found: [count]
  Fixes completed and verified: [count]
  Fixes in progress when interrupted: [count]
  Fixes still to do: [count]

  FILES BEING EDITED WHEN INTERRUPTED:
  [list any files with in_progress claims]

  WHAT WOULD YOU LIKE TO DO?

  1. Resume exactly where we left off
  2. Resume but restart interrupted fixes
  3. Start fresh (keep issues, redo fixes)
  4. Discard and start completely new test

  Type 1, 2, 3 or 4.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for response before doing anything.

If 1: Restore agents to saved state, re-spawn only
active agents with their context, continue from where
interrupted. Do not redo verified fixes.

If 2: Keep verified fixes, mark in_progress fixes as
pending, release claimed files, re-spawn agents fresh.

If 3: Keep issue list, clear fix progress, release
files, re-spawn all agents, start fix process over.

If 4: Archive old state to
~/.claude/context/agent-state-archive/[timestamp]-agent-state.json
Clear agent-state.json and run completely new test.

If no incomplete session found, continue normally.
If a completed previous session exists, ask user if
they want to continue it or start fresh.

STEP 2 - PROJECT SCAN
- Detect the project type and tech stack
- Find the package.json or equivalent config
- Identify the framework (Next.js, React, Vue, etc)
- Find authentication setup (NextAuth, Clerk, Supabase Auth, etc)
- Find database setup (Prisma, Drizzle, Mongoose, etc)
- Identify key routes and pages
- Check for environment files
- Look for existing test configurations

Display a summary:
  Project: [name]
  Framework: [detected]
  Auth: [detected or none]
  Database: [detected or none]
  Pages found: [count]
  Has restricted areas: [yes/no]

STEP 3 - INTELLIGENT EDGE CASE DISCOVERY
Run this silently after the project scan and before
showing the options menu. Think like an experienced QA
engineer who has seen many apps fail in unexpected ways.
Do not follow a generic checklist. Reason specifically
about THIS app based on what was found in the scan.

PHASE 1 - DEEP APP ANALYSIS

Silently read and analyse the codebase. Look for:

TECH STACK PATTERNS
- What framework is being used
- What database or data layer exists
- What auth system is in place
- What third party services are connected
- What payment systems if any
- What file upload systems if any
- What real time features if any
- What API integrations exist
- What caching layer if any
- What background jobs if any

USER FLOW MAPPING
- Map every possible user journey from entry to completion
- Find where journeys branch
- Find where journeys can dead end
- Find where data is passed between steps
- Find where state is stored (localStorage, sessions, cookies)
- Find where tokens are passed

DATA BOUNDARIES
- What is the minimum valid input for every field
- What is the maximum valid input
- What characters could cause issues
- What happens at zero values
- What happens at negative values
- What happens with empty states
- What happens with very long strings
- What happens with special characters
- What happens with unicode and emoji
- What happens with SQL-like input
- What happens with HTML in inputs

ASYNC AND TIMING
- What operations take time to complete
- What shows loading states
- What could time out
- What happens if a user acts before loading completes
- What happens if network drops mid flow
- What race conditions could exist

PERMISSION BOUNDARIES
- What can a logged out user access
- What can a basic user access
- What can a premium user access
- What can an admin access
- Where do these boundaries overlap
- Where could they be bypassed

PHASE 2 - GENERATE EDGE CASES

Based purely on what was found in the analysis,
independently generate a list of edge cases to test.
Do not use a generic checklist. Think specifically about
this app and what could go wrong given its specific
features, tech stack and user flows.

Organise edge cases into these categories:

HAPPY PATH VARIATIONS
Things that should work but in slightly different ways
than the most obvious path. Examples: sign up with plus
addressing in email, very long valid name, sign up on
mobile then continue on desktop.

BOUNDARY CONDITIONS
The edges of what the system accepts. Examples: exactly
one character, exactly at maximum length, one over max,
just whitespace, newlines and tabs.

UNHAPPY PATH SCENARIOS
Things users do that they should not. Examples: submit
before fields complete, go back and forward between steps,
refresh mid submission, double click submit rapidly.

BROKEN ENVIRONMENT SCENARIOS
Things that break the environment around the user action.
Examples: network drops during payment, session expires
mid flow, browser back button after completing a step.

INTEGRATION FAILURE SCENARIOS
What happens when connected services fail. Examples:
email service down, verification link expired, link
used twice, second link requested before using first.

PERMISSION EDGE CASES
Unusual combinations of access. Examples: role changed
mid session, shared link to restricted page, bookmarked
page after permission removed.

STATE CORRUPTION SCENARIOS
What could leave the app in a bad state. Examples:
completing step 3 before step 2, starting flow in two
tabs simultaneously, abandoning flow halfway and returning,
clearing cookies mid flow.

PHASE 3 - PRIORITISE AND DISPLAY

Display the discovered edge cases:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EDGE CASE ANALYSIS COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  I have analysed your app and found
  [X] edge cases worth testing that
  go beyond the standard test flow.

  These are specific to your app based
  on what I found in the codebase.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  HIGH RISK - TEST THESE FIRST
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  For each high risk edge case show:
  What: [plain English description]
  Why risky: [what could go wrong]
  How I will test it: [plain English]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  MEDIUM RISK - TEST IF TIME ALLOWS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [List each medium risk edge case]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  INTERESTING - WORTH KNOWING ABOUT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [List lower priority but interesting
  edge cases worth noting]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Would you like me to:

  1. Include all edge cases in this test
  2. Test edge cases only
  3. Test high risk edge cases only
  4. Skip edge cases for now
  5. Save edge cases and come back later

  Type 1, 2, 3, 4 or 5.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for response before continuing.

PHASE 4 - SAVE DISCOVERED EDGE CASES

Regardless of what option the user chooses, always save
the discovered edge cases to $EDGE_CASES

Format:
Project: [name]
Date analysed: [date]
Total edge cases found: [count]

HIGH RISK:
[list each with description and test approach]

MEDIUM RISK:
[list each]

INTERESTING:
[list each]

TESTED THIS SESSION:
[filled in as testing progresses]

NOT YET TESTED:
[remaining ones for future sessions]

PHASE 5 - EXECUTE EDGE CASE TESTS (if selected)

When testing each edge case display:

  TESTING EDGE CASE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What: [plain English description]
  Why: [what we are looking for]
  How: [what steps will be taken]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Move the cursor naturally to each element being tested.
Show the cursor label with what is being attempted.
Take a screenshot of the result.

After each edge case test display:
  Result: PASSED / FAILED / INTERESTING

  PASSED: App handled it correctly
  FAILED: Something went wrong - describe it
  INTERESTING: Did not break but behaved unexpectedly

If FAILED: Show the fix decision flow as normal.
Warn about side effects before fixing.
Ask user what to do.

PHASE 6 - EDGE CASE SECTION IN HTML REPORT

Add a new section to the HTML report called
WHAT ELSE WE LOOKED FOR

Write in plain English:

  Based on analysing how your app is built we also
  tested some less obvious scenarios that real users
  might encounter. Here is what we found:

For each edge case tested write:
  What we tested: [plain English scenario]
  Why we tested it: [plain English reason]
  What happened: [plain English result]
  Status: Handled correctly / Behaved unexpectedly / Needs fixing

For untested edge cases add:
  WHAT WE DID NOT GET TO TEST
  [Plain English list of remaining edge cases]

If user picked option 4 or 5, skip edge case testing
but still proceed to the standard test flow below.

If user picked option 2, skip the standard visual test
and go directly to edge case execution, then to report.

STEP 4 - TOKEN OPTIONS MENU
Display the testing options:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Choose your test mode:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Quick Check (Low token cost)
     Visual test of public pages only.
     No code review. Terminal summary.
     Best for: daily dev checks
     Uses roughly 40% of session window

  2. Standard Test (Medium token cost)
     Visual test of all pages including
     restricted areas. Code review of
     changed files. HTML report.
     Best for: end of sprint review
     Uses roughly 65% of session window

  3. Deep Test (High token cost)
     Everything in Standard plus full
     CodeRabbit sweep, all restricted
     areas, comprehensive code review.
     Best for: pre-launch review
     Uses up to 90% of session window

  4. Standard + Pillars Audit (Medium-High)
     Everything in Standard plus the
     Four Pillars production readiness
     audit. Reliability, Security,
     Scalability, Observability, Design
     and Performance.
     Uses roughly 75% of session window

  5. Custom
     Choose exactly what to include.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for the user to choose before continuing.

If user picks 1: Follow the test-quick workflow
If user picks 3: Follow the test-deep workflow
If user picks 4: Run Standard test + Four Pillars audit after code review
If user picks 5: Ask what to include and build a custom plan

If user picks 2 (Standard) continue below:

STEP 5 - CONFIRMATION
Display what will happen:

  I will now:
  - Test all [count] pages visually
  - Try to access restricted areas
  - Review code for security and quality
  - Check responsive layouts
  - Check basic accessibility
  - Generate an HTML report at the end

  Ready to start? (yes/no)

Wait for confirmation.

STEP 6 - PRE-TEST CHECKS
- Check Chrome is connected via MCP
  If not connected display:
  Chrome is not connected. Please:
  1. Open Chrome
  2. Run: claude --chrome
  3. Then type /test again
  And stop.
- Check the dev server is running
  Try localhost:3000, localhost:3001,
  localhost:5173, localhost:8080
  If not running attempt: npm run dev
  If still not running ask the user
- Capture any console errors already present
- Note the current page title and URL
- Write session start to test-session.md

SCREENSHOT SETUP:
- Create a session screenshot folder:
  $SCREENSHOTS/[project-name]/[YYYY-MM-DD]-[short-id]/
- Create subfolders: before-fixes/ after-fixes/ edge-cases/ pillars/
- Store the folder path in agent-state.json as "screenshot_folder"
- All screenshots for this session go into this folder only

OLD SESSION CLEANUP:
Check for screenshot sessions older than 7 days.
If found display:

  OLD SCREENSHOTS FOUND
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Found [count] old test sessions:
  - [project] tested [X] days ago - [size]
  Total space used: [size]

  Clean up old sessions?
  Type yes to delete sessions older than 7 days
  Type no to keep everything
  Type skip to never ask again
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If skip: note in CLAUDE.md to never ask again.
If no old sessions exist, skip this silently.

STEP 7 - AUTHENTICATION
If restricted areas were detected:
- Check test-accounts.md for existing credentials
- If account exists try logging in with saved details
- If no account exists:
  A. Try to find a seed script or test user setup
  B. Try to create an account via the signup page
  C. Try to generate a magic link from the database
  D. Try to find a magic link bypass env variable
  E. If all fail ask the user for help

For magic link authentication:
- Check for local email catchers:
  Mailhog at localhost:8025
  Mailpit at localhost:8025
  MailDev at localhost:1080
  Console output
- If email catcher found, retrieve the magic link
- If no email catcher, check for bypass variable
- If nothing works, ask the user

After successful login:
- Save the working credentials to test-accounts.md
- Note the access method in test-session.md

If login fails after all attempts:
- Display what was tried
- Ask the user what to do:
  A. Provide credentials manually
  B. Skip restricted areas
  C. Grant access another way
- Wait for response

STEP 8 - INJECT VISIBLE CURSOR SYSTEM
Before starting visual testing, inject the cursor overlay
into the browser using evaluate_script. This makes testing
visible and watchable in real time.

Inject this JavaScript on the page:

```javascript
(() => {
  // Remove existing cursor if re-injected
  if (document.getElementById('vtp-cursor')) return;

  // Cursor dot
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

  // Click ring (expands on click)
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

  // Label next to cursor
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

  // Status bar at bottom
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
  bar.textContent = 'visual-test-pro — Starting visual test...';

  document.body.append(dot, ring, label, bar);

  // Move cursor to coordinates
  window.__vtpMoveTo = (x, y) => {
    dot.style.top = y + 'px'; dot.style.left = x + 'px';
    ring.style.top = y + 'px'; ring.style.left = x + 'px';
    label.style.top = y + 'px'; label.style.left = x + 'px';
  };

  // Animate click
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

  // Hover state
  window.__vtpHover = (hovering) => {
    if (hovering) {
      dot.style.background = 'rgba(168, 85, 247, 0.95)';
      dot.style.boxShadow = '0 0 18px 6px rgba(168, 85, 247, 0.5)';
      dot.style.transform = 'translate(-50%, -50%) scale(1.3)';
    } else {
      dot.style.background = 'rgba(139, 92, 246, 0.85)';
      dot.style.boxShadow = '0 0 12px 4px rgba(139, 92, 246, 0.4)';
      dot.style.transform = 'translate(-50%, -50%) scale(1)';
    }
  };

  // Update label text
  window.__vtpLabel = (text) => {
    label.textContent = text;
    label.style.opacity = text ? '1' : '0';
  };

  // Update status bar text
  window.__vtpStatus = (text) => {
    bar.textContent = 'visual-test-pro — ' + text;
  };

  // Remove all cursor elements (call before screenshots)
  window.__vtpCleanup = () => {
    ['vtp-cursor','vtp-ring','vtp-label','vtp-status'].forEach(id => {
      const el = document.getElementById(id);
      if (el) el.remove();
    });
  };
})();
```

CURSOR USAGE RULES:
- After EVERY page navigation, re-inject the cursor script
- Before clicking any element, move the cursor to it first
  using evaluate_script: __vtpMoveTo(x, y)
- Set the label to describe what you are about to do:
  __vtpLabel("Clicking the Save button")
  __vtpLabel("Filling in the email field")
  __vtpLabel("Scrolling to check the footer")
  __vtpLabel("Checking this button works")
- Update the status bar for each major action:
  __vtpStatus("Testing profile page — checking form fields")
  __vtpStatus("Testing billing page — verifying plan details")
- When hovering over an element call __vtpHover(true)
  and __vtpHover(false) when moving away
- When clicking call __vtpClick(x, y) for the animation
- Before EVERY screenshot call __vtpCleanup() to remove
  the cursor so reports and screenshots stay clean
- After the screenshot, re-inject the cursor script
  to continue testing

STEP 9 - VISUAL TESTING
For each page found in the project:
- Navigate to the page
- Re-inject the cursor system after navigation
- Update status bar: "Testing [page name]"
- Wait for full load
- Move cursor to each element before interacting
- Label each action in plain English
- Screenshot the page (cleanup cursor first, reinject after)
- Click every button, link and interactive element
- Fill all forms with realistic test data
- Test form validation with empty and invalid data
- Check error handling and success states
- Note any visual issues or broken layouts
- Write findings to test-session.md after each page

SCREENSHOT RULES:
- Save to the session folder: [NN]-[page]-[breakpoint].png
- Before saving, check if same page at same breakpoint already exists
  this session. Skip duplicates unless something changed.
- If screenshot is over 2MB, compress to under 500KB before saving.
- For fixes: take before screenshot first (save to before-fixes/),
  then after screenshot (save to after-fixes/) as a pair.
  Reuse an existing screenshot of that element if already taken.
- Edge case screenshots go in edge-cases/ subfolder.
- Pillars audit screenshots go in pillars/ subfolder.

STEP 10 - RESPONSIVE CHECKS
- Test at desktop width 1440px and screenshot
- Test at tablet width 768px and screenshot
- Test at mobile width 375px and screenshot
- Note any layout breaks or overflow issues

STEP 11 - CONSOLE MONITORING
- Capture all console errors during the test
- Capture all console warnings
- Capture any failed network requests
- Flag any requests taking longer than 2 seconds

STEP 12 - ACCESSIBILITY BASICS
- Check all images have alt text
- Check all buttons have visible labels or aria-labels
- Check text contrast looks reasonable visually
- Check form inputs have labels
- Check keyboard navigation on key interactive elements

STEP 13 - CODE REVIEW
- Review authentication and authorization code
- Review API routes for security issues
- Review form handling and input validation
- Review database queries for injection risks
- Review file upload handling
- Check for hardcoded secrets or credentials
- Check for console.log statements in production code
- Check for TODO or FIXME comments

Classify each issue found:
- Critical: Security vulnerability or data loss risk
- High: Functional bug or significant UX problem
- Medium: Code quality issue or minor bug
- Low: Style issue or improvement suggestion

STEP 14 - ISSUE TRIAGE AND FIX APPROVAL
Display all issues found grouped by severity.

For Critical and High issues ask the user:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ISSUES FOUND - [count] total
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Critical: [count] — security or data loss risk
  High: [count] — bugs or significant UX problems
  Medium: [count] — code quality (report only)
  Low: [count] — suggestions (report only)

  I can spin up a team of specialist agents
  to fix the Critical and High issues in
  parallel instead of one by one.

  1. Fix all Critical and High issues (recommended)
  2. Fix Critical only
  3. Let me choose which to fix
  4. Skip fixes — just report everything

  Type 1, 2, 3 or 4.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for response. If 4, skip to STEP 15.

STEP 14B - MULTI-AGENT FIX SYSTEM
When the user approves fixes, spawn specialist agents
to work on them in parallel using the Agent tool.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPINNING UP YOUR FIX TEAM
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Assigning [X] issues across specialist
  agents. They will work in parallel and
  coordinate before committing changes.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Only spawn agents that have actual work to do.

AGENT ROSTER:

SECURITY AGENT
Spawned when: any security issues found
Fixes: auth issues, input validation, XSS, SQL injection,
exposed data, insecure endpoints, token security, sessions
Must notify: UI Agent and Logic Agent before touching
shared auth components. Check with Logic Agent before
changing validation logic that affects business rules.

LOGIC AGENT
Spawned when: any bugs or logic errors found
Fixes: broken flows, wrong data processing, missing error
handling, race conditions, state issues, API responses
Must notify: UI Agent before changing what users see.
Security Agent before changing auth logic. Data Agent
before changing anything that touches the database.

UI AGENT
Spawned when: any visual or UX issues found
Fixes: broken layouts, responsive issues, missing hover
and focus states, accessibility, loading states, animations
Must notify: Logic Agent before changing component behaviour.
All agents if changing shared CSS variables or global styles.

DATA AGENT
Spawned when: any data or database issues found
Fixes: wrong data saved, missing validation, query issues,
data transformation, API mapping, form data, file uploads
Must notify: Logic Agent of schema or query changes.
Security Agent of changes to sensitive data handling.

PERFORMANCE AGENT
Spawned when: any performance issues found
Fixes: slow requests, unnecessary re-renders, bundle size,
missing loading states, inefficient queries, memory leaks
Must notify: Logic Agent before refactoring shared utilities.
UI Agent before changing rendering behaviour.

TEST AGENT
Always spawned when other agents are active.
Verifies every fix worked. Retests in the browser.
Takes before and after screenshots. Checks console.
Has final say on whether a fix is confirmed complete.
Can send a fix back to the responsible agent for retry.
Maximum three attempts per fix before escalating to user.

AGENT COORDINATION:
Before any agent edits a file it must check that no other
agent is currently working on the same file. If two agents
need the same file and changes conflict, pause both and
apply a merged fix. Show the user what happened.

Agents communicate by including context in their prompts
about what other agents are doing and what files are
being touched. Each agent receives a brief of all issues
and which agent owns which fix.

AGENT STATE PERSISTENCE:
Write the full agent state to $AGENT_STATE
after EVERY one of these events:
- An agent is spawned
- An agent claims a file
- An agent completes a fix
- An agent sends a message to another agent
- A fix is verified by Test Agent
- A fix is sent back for retry
- A conflict is detected
- A user responds to a blocked fix
- Any agent is paused or stopped

The state file must contain:
- session_id, project, project_path, timestamps
- overall_progress (issues found, fixes attempted/verified/failed/skipped,
  sections completed/remaining, current section)
- Each agent's status, current file, current fix, completed fixes,
  failed fixes, remaining fixes, messages sent/received, retry count
- claimed_files with agent, reason, timestamp, status
- agent_messages array with from, to, message, timestamp, acknowledged
- conflicts array with file, agents, description, resolution, status
- All issues grouped by severity with id, description, file, assigned_to,
  status, fix_attempts, verified flag
- screenshots taken with filename, label, timestamp, page, reason
- blocked fixes with issue_id, reason, waiting_for, attempts
- paused_at, pause_reason, resume_instructions

When pausing for any reason (user request, waiting for input,
session ending), write the pause reason explicitly so resume
knows exactly what to do.

AGENT SYSTEM VALIDATION (run before spawning):
Check capability before spawning 6+ parallel agents:
- Is there enough context remaining for multiple parallel agents?
- Are the files to be fixed under 20 total?

If context is too low OR files >20:

  SEQUENTIAL MODE ACTIVATED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Too many findings or files to safely run parallel agents.
  Switching to sequential mode: agents run one at a time.
  Slower but more reliable.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FILE LOCKING via $AGENT_COORD:
Before any agent writes to a file:
1. Read $AGENT_COORD.
2. Check if file is locked by another agent.
3. If locked: wait 10 seconds, check again.
4. If still locked after 30 seconds: report deadlock, skip.

Lock format:
{
  "locks": {
    "[filename]": {
      "agent": "[agent name]",
      "locked_at": "[timestamp]",
      "operation": "[what it is doing]"
    }
  }
}

After agent finishes with a file: remove its lock.
This prevents two agents writing to the same file simultaneously.

AGENT STATE PERSISTENCE:
After every fix save to $AGENT_STATE:
- Which fixes applied
- Which in progress
- Which pending
- Which failed and why

If session interrupted /resume reads $AGENT_STATE and continues from
the last saved point.

SPAWN PATTERN:
Use the Agent tool to spawn each agent in parallel.
Each agent prompt must include:
- The specific issues assigned to them
- The file paths involved
- What other agents are working on
- Instructions to not touch files assigned to other agents
- Instructions to report what they changed

LIVE STATUS DISPLAY:
After spawning, show progress as each agent completes:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FIX TEAM STATUS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [agent emoji] [agent name]  [status]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Fixes completed: [X] of [total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

When agents communicate show:

  AGENT MESSAGE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [Agent A] -> [Agent B]:
  [plain English description of change]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CONFLICT RESOLUTION:
If two agents need the same file and changes conflict:
- Pause both agents
- Show the user what each agent wants to change
- Apply a merged fix or let user decide
- Notify both agents when resolved

ESCALATION:
If an agent fails three times on a fix:

  AGENT NEEDS YOUR HELP
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Agent: [name]
  Fix: [description]
  What was tried: [three attempts described]
  Options:
  1. Skip this fix and note in report
  2. Give me more context
  3. Handle manually then /resume
  4. Try a different approach
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Other agents continue while waiting.

TEST AGENT VERIFICATION:
After each agent completes, Test Agent runs:
- Navigate to the affected area in Chrome
- Retest the exact scenario that was broken
- Take a screenshot of the result
- Check console for new errors
- Check the fix did not break adjacent features

Display:
  TEST AGENT RESULT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Fix: [description]
  Agent: [which agent]
  Result: VERIFIED / PARTIALLY FIXED / DID NOT WORK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TEAM SUMMARY:
When all agents are done:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FIX TEAM COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total fixes attempted: [count]
  Verified by Test Agent: [count]
  Sent back and corrected: [count]
  Could not fix automatically: [count]

  BY AGENT:
  [emoji] [agent name]  [X] fixes applied
  [for each active agent]

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

HTML REPORT SECTION - HOW WE FIXED YOUR APP:
Add to the report in plain English:
- Which agents were active and what they specialised in
- How many fixes each agent applied
- Any coordination that happened between agents
- Each fix grouped by agent with plain English description
- Whether Test Agent verified each fix

STEP 15 - FOUR PILLARS PRODUCTION READINESS AUDIT
Run this step if user chose option 4 (Standard + Pillars)
or if running in deep test mode. Skip otherwise.

Read the actual code and make a real judgement on each pillar.
Be specific — name files and line numbers. Do not give generic advice.

PILLAR 1 - RELIABILITY (Logic Agent)
Check and rate each: Strong / Adequate / Weak / Missing
- Error Boundaries: exist at meaningful levels, not just top-level.
  Flag data-fetching components without them. Check fallback UI is helpful.
- Loading States: every async operation has a visible loading state.
  Buttons disabled during submission. States clear on success and failure.
- Try/Catch Coverage: all API routes, server functions, DB operations,
  external API calls wrapped. Errors handled specifically not silently.
  Error responses use meaningful status codes.
- Transaction Safety: multi-step DB operations use transactions.
  Rollback logic exists. Flag multi-table writes without transactions.
- Timeout/Retry: external API calls have timeouts. Retry logic for
  transient failures. Graceful degradation when services are down.

PILLAR 2 - SECURITY (Security Agent)
Check and rate each:
- Hardcoded Secrets: scan every file for sk-, pk-, JWT patterns,
  32+ char random strings, DB connection strings, private keys,
  OAuth secrets, webhook secrets. Check .env in .gitignore.
  Rate: Clean / Minor Issues / Critical Issues
- Session Leakage: every endpoint returning user data has ownership
  check. No queries by ID without user ID filter. Admin endpoints
  verify admin role. Rate: Strong / Adequate / Weak / Vulnerable
- Middleware: auth middleware runs before all protected routes.
  No backdoor patterns (dev-only skips, debug endpoints, test routes).
  CORS not set to allow all origins. Rate: Strong / Adequate / Weak / Backdoor Found
- Input Validation: server-side validation on all user input.
  File upload validation (type, size, filename). SQL injection check
  especially on raw queries. Rate: Strong / Adequate / Weak / Vulnerable
- Auth Security: password requirements, login rate limiting, JWT expiry,
  refresh token rotation, password reset expiry, magic link single use,
  HTTPS enforced. Rate: Strong / Adequate / Weak / Vulnerable

PILLAR 3 - SCALABILITY (Performance Agent)
Check and rate each:
- State Storage: in-memory state that should be in DB (sessions,
  counters, rate limits, carts). Single instance design vs multi-instance ready.
  Rate: Database-backed / Memory-bound / Risk Identified
- Heavy Queries: no LIMIT on growing tables, SELECT * on large tables,
  queries inside loops (N+1), missing indexes, loading entire tables
  to filter in app code. Rate: Efficient / Acceptable / Needs Optimisation / Dangerous
- Connection Pooling: pooled or fresh per request, pool size configured,
  connections properly closed. Rate: Properly Pooled / Needs Review / Risk Identified
- Caching: expensive operations cached, external API responses cached,
  invalidation logic exists, works across instances.
  Rate: Well Cached / Partially Cached / No Caching Found
- File Handling: object storage vs local, large file processing async vs blocking,
  image processing timing. Rate: Cloud-ready / Local-bound / Risk Identified
- Bundle Size: large dependencies imported fully when only parts needed,
  duplicate dependencies. Rate: Lean / Acceptable / Heavy / Critically Heavy
- Image Optimisation: images not oversized for display, modern formats used,
  width/height set to prevent layout shift, lazy loading on below-fold images,
  hero images not blocking render. Report largest with actual vs ideal sizes.
  Rate: Optimised / Acceptable / Needs Optimisation
- Time to Interactive: time to first meaningful content, time to interactive,
  flag any page taking over 2s to load fully.
  Rate: Fast / Acceptable / Slow / Critically Slow

PILLAR 4 - OBSERVABILITY (Logic Agent)
Check and rate each:
- Logging: logging library vs console.log, errors logged with context
  (operation, data, error, user ID), severity levels used, sensitive data
  not logged. Rate: Production Ready / Partial / Console Only / Missing
- Error Monitoring: Sentry/Datadog/LogRocket/Bugsnag integrated, errors
  captured with user context, source maps configured.
  Rate: Integrated / Partial / Missing
- Health Checks: endpoint exists, actually tests dependencies not just 200.
  Rate: Meaningful / Superficial / Missing
- Alerting: configured for downtime and error rates, uptime monitoring.
  Rate: Configured / Partial / Missing
- Audit Trail: important user actions logged, admin actions logged,
  data changes traceable. Rate: Full / Partial / Missing

NOTE ON DESIGN AND PERFORMANCE:
Visual consistency, mobile responsiveness, visual glitches, responsive
layouts, and accessibility are already covered by the visual testing,
responsive checks, and accessibility steps earlier in this test.
The pillars focus on what those steps do not cover: code-level
reliability, security, scalability, and observability.
The unique checks from those areas (bundle size, image optimisation,
time to interactive) are folded into Pillar 3 Scalability above.
Touch target sizing (44px+) and visual consistency (spacing, typography,
colour usage) are captured during the visual testing and accessibility
steps and included in the overall production readiness score.

DISPLAY RESULTS:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FOUR PILLARS AUDIT RESULTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  PILLAR 1 - RELIABILITY
  [sub-check]: [rating] [icon]
  Reliability Score: [X]/10

  PILLAR 2 - SECURITY
  [sub-check]: [rating] [icon]
  Security Score: [X]/10

  PILLAR 3 - SCALABILITY
  [sub-check]: [rating] [icon]
  Scalability Score: [X]/10

  PILLAR 4 - OBSERVABILITY
  [sub-check]: [rating] [icon]
  Observability Score: [X]/10

  OVERALL PRODUCTION READINESS: [X]/10

  9-10: PRODUCTION READY
  7-8: NEARLY THERE
  5-6: NOT QUITE READY
  Below 5: NEEDS WORK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Icons: Strong/Clean/Fast = checkmark, Adequate/Partial = warning, Weak/Missing/Vulnerable = cross

Save findings to ~/.claude/context/pillars-audit.json

For the HTML report add a PRODUCTION READINESS AUDIT section with:
- Overall score and verdict prominently displayed
- Four pillar cards with score bars and rating badges
- Each finding in plain English with file references, why it matters,
  how to fix it, and urgency level
- Specific examples like: "Your Stripe API key is on line 34 of
  payments.js" not "Check for hardcoded secrets"

STEP 16 - WRITE SESSION DATA AND ARCHIVE AGENT STATE
- Write all findings to test-session.md
- Save structured data to test-data.json
- Ensure all screenshots are in the screenshots folder
- Mark agent-state.json as complete
- Archive it to ~/.claude/context/agent-state-archive/
  [timestamp]-[project]-agent-state.json
- Clear the active agent-state.json
- Keep the last 5 archived states, delete older ones

STEP 17 - GENERATE HTML REPORT
- Read the report template from $REPORT_TEMPLATE
- Fill in all sections with findings from this session
- Write plain English summaries anyone can understand
- Reference screenshots by relative file path not base64 embedding.
  This keeps the report file small. Screenshots load from the
  session folder when opened on the same machine.
- If a screenshot was deleted, show a placeholder:
  [Screenshot removed] with plain English description of what was shown.
- Group screenshots in the report:
  Before and after fix pairs (side by side comparison cards)
  Page by page visual record
  Issues found
  Edge cases tested
  Pillars audit findings
- Add note at top of screenshots section:
  "Screenshots stored at: [folder path]"
- Include the health scorecard
- Include recommended next steps as simple actions
- Include SESSION CONTINUITY note:
  If fresh session: "All fixes completed in one session."
  If resumed: "Started [date], completed [date] after
  being resumed [X] times. Fixes before resume: [count].
  Fixes after resume: [count]."
- Save report to $TEST_REPORT
- Open the report in Chrome

STEP 18 - FINAL SUMMARY
Display in the terminal:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TEST COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pages tested: [count]
  Issues found: [count]
  Issues fixed: [count]
  Still needs attention: [count]
  Confidence score: [score]/10

  Your HTML report is ready at:
  $TEST_REPORT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 19 - SCREENSHOT CLEANUP PROMPT
After the final summary, ask the user:

  SESSION COMPLETE - SCREENSHOTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  This session took [count] screenshots.
  Total size: [size]
  Saved at: [folder path]

  What would you like to do with them?

  1. Keep all screenshots
  2. Keep important ones only (delete duplicates)
  3. Archive this session (compress to zip)
  4. Delete all screenshots (report keeps text)
  5. Ask me next time

  Type 1, 2, 3, 4 or 5.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for response.
If 2: Delete duplicates, keep one per page, all fix pairs, all issue shots.
If 3: Compress folder to [session-folder].zip, delete originals.
If 4: Delete all screenshots. Report shows placeholders.
If 5: Keep everything, remind next session.

IMPORTANT RULES:
- Write findings to test-session.md after EACH section
- Never move to the next section until the current one is saved
- If context is getting long, summarise earlier completed sections
- Never assume a section is done unless it is recorded
- If unsure where you are, read test-session.md before continuing
- After fixing any issue, always confirm the fix worked in the browser
- Never store magic links in test-accounts.md
- Always review magic link security whether or not browser access was gained
- If stuck after multiple login attempts, stop and ask the user
- Never proceed past an access block without user confirmation
