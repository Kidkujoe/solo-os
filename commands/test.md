---
name: test
description: Smart visual browser test with project scan, token options menu, fix decision flow and plain English reporting
allowed-tools: Bash, mcp__chrome-devtools__*
---

Run a smart visual browser test for: $ARGUMENTS

STEP 1 - LOAD CONTEXT
- Read ~/.claude/context/test-session.md
- Read ~/.claude/context/test-accounts.md
- Check if a test account exists for this project
- Check if a previous session exists
- If a session exists ask if the user wants to continue it or start fresh

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
the discovered edge cases to ~/.claude/context/edge-cases.md

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

  4. Custom
     Choose exactly what to include.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for the user to choose before continuing.

If user picks 1: Follow the test-quick workflow
If user picks 3: Follow the test-deep workflow
If user picks 4: Ask what to include and build a custom plan

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

STEP 14 - FIX DECISION FLOW
For each issue found:

If Critical:
  Display:
  CRITICAL ISSUE FOUND:
  [description in plain English]

  This should be fixed now because:
  [why it matters]

  I will fix this by:
  [what will change]

  SIDE EFFECT WARNING:
  [what might look or work differently after]

  Fix this now? (yes/no/skip)

  Wait for permission before fixing.

If High:
  Display the issue and recommendation.
  Ask permission before fixing.

If Medium or Low:
  List them in the report.
  Do not fix automatically.
  Let the user decide later.

After each fix:
- Verify the fix worked by checking the page
- Screenshot after the fix
- Write the fix to test-session.md
- Note any side effects observed

STEP 15 - WRITE SESSION DATA
- Write all findings to test-session.md
- Save structured data to test-data.json
- Ensure all screenshots are in the screenshots folder

STEP 16 - GENERATE HTML REPORT
- Read the report template from ~/.claude/context/report-template.html
- Fill in all sections with findings from this session
- Write plain English summaries anyone can understand
- Include all screenshots taken
- Include the health scorecard
- Include recommended next steps as simple actions
- Save report to ~/.claude/context/test-report.html
- Open the report in Chrome

STEP 17 - FINAL SUMMARY
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
  ~/.claude/context/test-report.html
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

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
