---
name: test-deep
description: Full comprehensive pre-launch test including CodeRabbit sweep and all restricted area testing
allowed-tools: Bash, mcp__chrome-devtools__*
---

Run a full deep test for: $ARGUMENTS

This is the high token cost mode. Everything is included.
Best run before a major release or launch.

STEP 1 - LOAD CONTEXT
- Read ~/.claude/context/test-session.md
- Read ~/.claude/context/test-accounts.md
- Check if a test account exists for this project
- Check if a previous session exists
- If a session exists ask if the user wants to continue or start fresh

STEP 2 - PROJECT SCAN
- Detect the project type and tech stack
- Find the package.json or equivalent config
- Identify the framework
- Find authentication setup
- Find database setup
- Identify ALL routes and pages including dynamic routes
- Check for environment files
- Look for API routes and serverless functions
- Map out the full application structure

Display a detailed summary:
  Project: [name]
  Framework: [detected]
  Auth: [detected or none]
  Database: [detected or none]
  Total pages: [count]
  API routes: [count]
  Restricted areas: [list]
  Environment: [dev/staging/prod]

STEP 3 - CONFIRMATION
Display:

  DEEP TEST MODE
  This will use up to 90% of your session window.
  Best run at the end of the day or before a launch.

  I will:
  - Test every page visually including all restricted areas
  - Try every form, button and interaction
  - Full code review of all key files
  - Run CodeRabbit sweep (if installed)
  - Test all responsive breakpoints
  - Full accessibility audit
  - Check all API routes
  - Generate a comprehensive HTML report

  This will take a while. Ready? (yes/no)

Wait for confirmation.

STEP 4 - PRE-TEST CHECKS
- Check Chrome is connected via MCP
- Check the dev server is running
- Check if CodeRabbit CLI is installed
  If not installed display:
  CodeRabbit is not installed.
  For the best deep test results install it:
  curl -fsSL https://cli.coderabbit.ai/install.sh | sh
  Continue without it? (yes/no)
- Capture baseline console state
- Write session start to test-session.md

STEP 5 - AUTHENTICATION (FULL)
Follow the complete authentication flow:
- Check test-accounts.md for existing credentials
- If account exists try logging in
- If no account exists try ALL methods:
  A. Seed script or test user setup
  B. Signup page registration
  C. Magic link from database
  D. Magic link bypass env variable
  E. Direct database user creation
  F. Ask the user

For magic link authentication:
- Check all local email catchers
- Check for bypass variables
- If nothing works, ask the user

After login:
- Save working credentials
- Test account permissions and role
- Verify access to all restricted areas
- Note which areas are accessible and which are not

STEP 6 - VISUAL TESTING (COMPREHENSIVE)
For EVERY page in the application:
- Navigate to the page
- Wait for full load including lazy loaded content
- Screenshot the page at full scroll height
- Click every button and interactive element
- Fill all forms with realistic data
- Test form validation thoroughly:
  Empty submissions
  Invalid email formats
  Too short / too long inputs
  Special characters
  SQL injection attempts (safe ones)
  XSS attempts (safe ones)
- Test all dropdowns, modals, tooltips
- Test loading states and error states
- Test empty states where applicable
- Check all images load correctly
- Check all external links work
- Write findings to test-session.md after each page

STEP 7 - RESPONSIVE TESTING (FULL)
Test every page at:
- Desktop 1440px
- Laptop 1024px
- Tablet 768px
- Mobile 375px
- Small mobile 320px

For each breakpoint:
- Screenshot the page
- Check navigation works
- Check forms are usable
- Check text is readable
- Check images scale correctly
- Check no horizontal overflow

STEP 8 - CONSOLE AND NETWORK MONITORING
- Capture ALL console errors, warnings and info
- Capture ALL failed network requests
- Flag slow requests over 2 seconds
- Check for CORS errors
- Check for mixed content warnings
- Check for deprecation warnings
- Check for memory leaks (long running pages)

STEP 9 - ACCESSIBILITY AUDIT
- Check all images have meaningful alt text
- Check all buttons have labels
- Check all form inputs have associated labels
- Check colour contrast ratios
- Check keyboard navigation works throughout
- Check focus indicators are visible
- Check skip links exist
- Check heading hierarchy is correct
- Check ARIA attributes are used correctly
- Check screen reader announcements for dynamic content

STEP 10 - CODE REVIEW (COMPREHENSIVE)
Review ALL key files:

Security:
- Authentication and authorization code
- API route protection and middleware
- Input validation and sanitisation
- Database query safety
- File upload handling
- CSRF protection
- Rate limiting
- Session management
- Secret handling

Quality:
- Error handling patterns
- TypeScript types coverage
- Dead code and unused imports
- Console.log in production
- TODO and FIXME comments
- Performance anti-patterns
- Memory leak patterns
- Proper cleanup in useEffect

Classify each issue:
- Critical: Security vulnerability or data loss risk
- High: Functional bug or significant UX problem
- Medium: Code quality issue or minor bug
- Low: Style issue or improvement suggestion

STEP 11 - CODERABBIT SWEEP
If CodeRabbit CLI is installed:
- Run a full sweep on the project
- Capture all findings
- Cross-reference with manual code review
- Remove duplicates
- Add unique CodeRabbit findings to the report

If not installed, skip this step.

STEP 12 - FIX DECISION FLOW
For each issue found, follow the same fix decision
flow as the standard test:

Critical: Display full details, side effect warning,
ask permission before fixing.

High: Display and recommend. Ask permission.

Medium and Low: List in report only.

After each fix:
- Verify in the browser
- Screenshot after fix
- Write to test-session.md
- Note side effects

STEP 13 - MAGIC LINK SECURITY AUDIT
If the project uses magic links:
- Check token randomness and length
- Check token expiry time
- Check single use enforcement
- Check rate limiting on generation
- Check email scope (tied to user)
- Check for enumeration vulnerabilities
- Write security findings to test-session.md

STEP 14 - WRITE ALL SESSION DATA
- Write complete findings to test-session.md
- Save all structured data to test-data.json
- Ensure all screenshots are organised in screenshots folder
- Create a screenshots index

STEP 15 - GENERATE COMPREHENSIVE HTML REPORT
- Read the report template
- Fill in ALL sections with full detail
- Write plain English summaries
- Include every screenshot taken
- Include the full health scorecard
- Include CodeRabbit findings if available
- Include magic link security audit if applicable
- Include detailed recommended next steps
- Save to ~/.claude/context/test-report.html
- Open in Chrome

STEP 16 - FINAL SUMMARY
Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  DEEP TEST COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total pages tested: [count]
  Total issues found: [count]
    Critical: [count]
    High: [count]
    Medium: [count]
    Low: [count]
  Issues fixed: [count]
  Still needs attention: [count]
  CodeRabbit findings: [count or skipped]
  Auth security: [pass/fail/not applicable]

  Confidence score: [score]/10

  Your comprehensive report is ready at:
  ~/.claude/context/test-report.html
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IMPORTANT RULES:
- Write findings to test-session.md after EACH section
- Never move to next section until current is saved
- If context is getting long, summarise earlier sections
- Never assume a section is done unless recorded
- If unsure where you are, read test-session.md first
- After fixing any issue, confirm the fix in the browser
- Never store magic links in test-accounts.md
- Always review magic link security
- If stuck after multiple login attempts, ask the user
- Never proceed past an access block without user confirmation
- If token usage is getting high, warn the user and offer:
  A. Continue and finish
  B. Skip to report generation
  C. Save progress and resume later with /resume
