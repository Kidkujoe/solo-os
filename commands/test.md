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

STEP 3 - TOKEN OPTIONS MENU
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

STEP 4 - CONFIRMATION
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

STEP 5 - PRE-TEST CHECKS
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

STEP 6 - AUTHENTICATION
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

STEP 7 - INJECT VISIBLE CURSOR SYSTEM
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

STEP 8 - VISUAL TESTING
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

STEP 9 - RESPONSIVE CHECKS
- Test at desktop width 1440px and screenshot
- Test at tablet width 768px and screenshot
- Test at mobile width 375px and screenshot
- Note any layout breaks or overflow issues

STEP 10 - CONSOLE MONITORING
- Capture all console errors during the test
- Capture all console warnings
- Capture any failed network requests
- Flag any requests taking longer than 2 seconds

STEP 11 - ACCESSIBILITY BASICS
- Check all images have alt text
- Check all buttons have visible labels or aria-labels
- Check text contrast looks reasonable visually
- Check form inputs have labels
- Check keyboard navigation on key interactive elements

STEP 12 - CODE REVIEW
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

STEP 13 - FIX DECISION FLOW
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

STEP 14 - WRITE SESSION DATA
- Write all findings to test-session.md
- Save structured data to test-data.json
- Ensure all screenshots are in the screenshots folder

STEP 15 - GENERATE HTML REPORT
- Read the report template from ~/.claude/context/report-template.html
- Fill in all sections with findings from this session
- Write plain English summaries anyone can understand
- Include all screenshots taken
- Include the health scorecard
- Include recommended next steps as simple actions
- Save report to ~/.claude/context/test-report.html
- Open the report in Chrome

STEP 16 - FINAL SUMMARY
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
