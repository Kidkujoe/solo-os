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

STEP 3 - INTELLIGENT EDGE CASE DISCOVERY
Run this silently after the project scan. Think like an
experienced QA engineer who has seen many apps fail in
unexpected ways. Do not follow a generic checklist. Reason
specifically about THIS app based on what was found.

PHASE 1 - DEEP APP ANALYSIS

Silently read and analyse the entire codebase. Look for:

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
than the most obvious path.

BOUNDARY CONDITIONS
The edges of what the system accepts.

UNHAPPY PATH SCENARIOS
Things users do that they should not.

BROKEN ENVIRONMENT SCENARIOS
Things that break the environment around the user action.

INTEGRATION FAILURE SCENARIOS
What happens when connected services fail.

PERMISSION EDGE CASES
Unusual combinations of access.

STATE CORRUPTION SCENARIOS
What could leave the app in a bad state.

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
but still save and proceed to the deep test flow below.

If user picked option 2, skip the standard visual test
and go directly to edge case execution, then to report.

STEP 4 - CONFIRMATION
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

STEP 5 - PRE-TEST CHECKS
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

STEP 6 - AUTHENTICATION (FULL)
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

STEP 7 - VISUAL TESTING (COMPREHENSIVE)
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

STEP 8 - RESPONSIVE TESTING (FULL)
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

STEP 9 - CONSOLE AND NETWORK MONITORING
- Capture ALL console errors, warnings and info
- Capture ALL failed network requests
- Flag slow requests over 2 seconds
- Check for CORS errors
- Check for mixed content warnings
- Check for deprecation warnings
- Check for memory leaks (long running pages)

STEP 10 - ACCESSIBILITY AUDIT
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

STEP 11 - CODE REVIEW (COMPREHENSIVE)
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

STEP 12 - CODERABBIT SWEEP
If CodeRabbit CLI is installed:
- Run a full sweep on the project
- Capture all findings
- Cross-reference with manual code review
- Remove duplicates
- Add unique CodeRabbit findings to the report

If not installed, skip this step.

STEP 13 - ISSUE TRIAGE AND FIX APPROVAL
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

Wait for response. If 4, skip to STEP 14.

STEP 13B - MULTI-AGENT FIX SYSTEM
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

CONFLICT RESOLUTION:
If two agents need the same file and changes conflict:
- Pause both agents
- Show the user what each agent wants to change
- Apply a merged fix or let user decide
- Notify both agents when resolved

ESCALATION:
If an agent fails three times on a fix:
- Show what was tried
- Give user options: skip, more context, manual, retry
- Other agents continue while waiting

TEST AGENT VERIFICATION:
After each agent completes, Test Agent:
- Navigates to the affected area in Chrome
- Retests the exact scenario that was broken
- Takes screenshots and checks console
- Reports: VERIFIED / PARTIALLY FIXED / DID NOT WORK
- Sends failed fixes back for retry (max 3 attempts)

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

STEP 14 - MAGIC LINK SECURITY AUDIT
If the project uses magic links:
- Check token randomness and length
- Check token expiry time
- Check single use enforcement
- Check rate limiting on generation
- Check email scope (tied to user)
- Check for enumeration vulnerabilities
- Write security findings to test-session.md

STEP 15 - FOUR PILLARS PRODUCTION READINESS AUDIT
This runs automatically in deep test mode.
Read the actual code and make a real judgement on each pillar.
Be specific — name files and line numbers. No generic advice.

PILLAR 1 - RELIABILITY (Logic Agent)
Rate each: Strong / Adequate / Weak / Missing
- Error Boundaries: meaningful levels, not just top-level. Flag data-fetching
  components without them. Check fallback UI is helpful.
- Loading States: every async operation has visible loading state. Buttons
  disabled during submission. States clear on success and failure.
- Try/Catch Coverage: all API routes, server functions, DB operations,
  external API calls wrapped. Errors handled specifically. Meaningful status codes.
- Transaction Safety: multi-step DB writes use transactions with rollback.
  Flag multi-table writes without transactions.
- Timeout/Retry: external calls have timeouts. Retry logic for transient
  failures. Graceful degradation when services down.

PILLAR 2 - SECURITY (Security Agent)
- Hardcoded Secrets: scan for sk-, pk-, JWT, 32+ char strings, DB connection
  strings, private keys, OAuth secrets, webhook secrets. Check .env in .gitignore.
  Rate: Clean / Minor Issues / Critical Issues
- Session Leakage: every data endpoint has ownership check. No ID-only queries
  without user ID. Admin endpoints verify role. Rate: Strong / Adequate / Weak / Vulnerable
- Middleware: auth before all protected routes. No backdoors (dev skips, debug
  endpoints, test routes in prod). CORS not allow-all. Rate: Strong / Adequate / Weak / Backdoor Found
- Input Validation: server-side on all input. File upload validation (type, size,
  filename). Raw query SQL injection check. Rate: Strong / Adequate / Weak / Vulnerable
- Auth Security: password requirements, login rate limiting, JWT expiry, refresh
  rotation, reset token expiry, magic link single use, HTTPS. Rate: Strong / Adequate / Weak / Vulnerable

PILLAR 3 - SCALABILITY (Performance Agent)
- State Storage: in-memory that should be DB (sessions, counters, carts).
  Single vs multi-instance. Rate: Database-backed / Memory-bound / Risk Identified
- Heavy Queries: no LIMIT on growing tables, SELECT *, N+1 patterns, missing
  indexes, full table loads. Rate: Efficient / Acceptable / Needs Optimisation / Dangerous
- Connection Pooling: pooled vs fresh, size configured, properly closed.
  Rate: Properly Pooled / Needs Review / Risk Identified
- Caching: expensive ops cached, API responses cached, invalidation exists,
  works across instances. Rate: Well Cached / Partially Cached / No Caching Found
- File Handling: object storage vs local, async processing, image timing.
  Rate: Cloud-ready / Local-bound / Risk Identified
- Bundle Size: large dependencies imported fully when only parts needed,
  duplicate dependencies. Rate: Lean / Acceptable / Heavy / Critically Heavy
- Image Optimisation: images not oversized for display, modern formats,
  width/height set, lazy loading, hero images not blocking render.
  Report largest with actual vs ideal sizes.
  Rate: Optimised / Acceptable / Needs Optimisation
- Time to Interactive: first meaningful content, time to interactive,
  pages over 2s to load. Rate: Fast / Acceptable / Slow / Critically Slow

PILLAR 4 - OBSERVABILITY (Observability Agent — spawned for deep mode)
- Logging: library vs console.log, errors with context, severity levels,
  no sensitive data logged. Rate: Production Ready / Partial / Console Only / Missing
- Error Monitoring: Sentry/Datadog/etc integrated, user context, source maps.
  Rate: Integrated / Partial / Missing
- Health Checks: endpoint exists, tests dependencies not just returns 200.
  Rate: Meaningful / Superficial / Missing
- Alerting: downtime and error rate alerts, uptime monitoring.
  Rate: Configured / Partial / Missing
- Audit Trail: user actions, admin actions, data changes logged.
  Rate: Full / Partial / Missing

NOTE: Design, responsive, and accessibility checks are already covered
by the visual testing, responsive testing, and accessibility audit steps
earlier in this test. The pillars focus on code-level concerns that
those browser-based steps do not cover. Unique performance checks
(bundle size, image optimisation, time to interactive) are folded
into Pillar 3 Scalability above.

Display full results with scores and ratings for each pillar.
Overall Production Readiness score out of 10 with verdict:
9-10: PRODUCTION READY / 7-8: NEARLY THERE / 5-6: NOT QUITE READY / Below 5: NEEDS WORK

Save to ~/.claude/context/pillars-audit.json

For the HTML report: add PRODUCTION READINESS AUDIT section with four
pillar cards, score bars, rating badges, and every finding in plain
English with specific file references, why it matters, how to fix,
and urgency.

STEP 16 - WRITE ALL SESSION DATA
- Write complete findings to test-session.md
- Save all structured data to test-data.json
- Ensure all screenshots are organised in screenshots folder
- Create a screenshots index

STEP 17 - GENERATE COMPREHENSIVE HTML REPORT
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

STEP 18 - FINAL SUMMARY
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
