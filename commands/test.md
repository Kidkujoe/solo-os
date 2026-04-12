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

STEP 7 - VISUAL TESTING
For each page found in the project:
- Navigate to the page
- Wait for full load
- Screenshot the page
- Click every button, link and interactive element
- Fill all forms with realistic test data
- Test form validation with empty and invalid data
- Check error handling and success states
- Note any visual issues or broken layouts
- Write findings to test-session.md after each page

STEP 8 - RESPONSIVE CHECKS
- Test at desktop width 1440px and screenshot
- Test at tablet width 768px and screenshot
- Test at mobile width 375px and screenshot
- Note any layout breaks or overflow issues

STEP 9 - CONSOLE MONITORING
- Capture all console errors during the test
- Capture all console warnings
- Capture any failed network requests
- Flag any requests taking longer than 2 seconds

STEP 10 - ACCESSIBILITY BASICS
- Check all images have alt text
- Check all buttons have visible labels or aria-labels
- Check text contrast looks reasonable visually
- Check form inputs have labels
- Check keyboard navigation on key interactive elements

STEP 11 - CODE REVIEW
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

STEP 12 - FIX DECISION FLOW
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

STEP 13 - WRITE SESSION DATA
- Write all findings to test-session.md
- Save structured data to test-data.json
- Ensure all screenshots are in the screenshots folder

STEP 14 - GENERATE HTML REPORT
- Read the report template from ~/.claude/context/report-template.html
- Fill in all sections with findings from this session
- Write plain English summaries anyone can understand
- Include all screenshots taken
- Include the health scorecard
- Include recommended next steps as simple actions
- Save report to ~/.claude/context/test-report.html
- Open the report in Chrome

STEP 15 - FINAL SUMMARY
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
