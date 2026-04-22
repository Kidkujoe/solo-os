---
name: pillars
description: Run the Four Pillars of Production Readiness audit without running a full visual test
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

Run a deep production readiness audit against this codebase.

Do not run visual tests or code review. Just audit the six pillars.
Read every key file in the project. Do not skim — actually read the
code and make a real judgement. Be specific — name files and line
numbers where issues are found. Do not give generic advice.

STEP 1 - LOAD CONTEXT
- Read $PRODUCT_MD silently if it exists
- Read $SESSION_FILE
- Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
- Detect project type and tech stack

STEP 2 - PILLAR 1: RELIABILITY
Rate each: Strong / Adequate / Weak / Missing

Error Boundaries:
- Check for React Error Boundaries at meaningful levels
- Flag data-fetching components without them
- Check fallback UI is helpful not just blank

Loading States:
- Every async operation has a visible loading state
- Buttons disabled during submission
- States clear on success and failure

Try/Catch Coverage:
- All API routes, server functions, DB operations wrapped
- External API calls wrapped
- Errors handled specifically not silently
- Meaningful status codes in responses

Transaction Safety:
- Multi-step DB writes use transactions with rollback
- Flag multi-table writes without transactions

Timeout/Retry:
- External calls have timeouts set
- Retry logic for transient failures
- Graceful degradation when services down

STEP 3 - PILLAR 2: SECURITY
Rate each appropriately per sub-check.

Hardcoded Secrets:
- Scan every file for sk-, pk-, JWT patterns, 32+ char strings,
  DB connection strings, private keys, OAuth secrets, webhook secrets
- Check .env in .gitignore, no .env committed

Session Leakage:
- Every data endpoint has ownership check
- No ID-only queries without user ID filter
- Admin endpoints verify admin role

Middleware:
- Auth before all protected routes
- No backdoors: dev skips, debug endpoints, test routes in prod
- CORS not set to allow all origins

Input Validation:
- Server-side validation on all user input
- File upload: type, size, filename validated
- SQL injection check especially on raw queries

Auth Security:
- Password requirements, login rate limiting
- JWT expiry reasonable, refresh token rotation
- Password reset and magic link tokens expire and are single use
- HTTPS enforced

STEP 4 - PILLAR 3: SCALABILITY
Rate each appropriately per sub-check.

State Storage:
- In-memory state that should be in DB
- Single instance vs multi-instance ready

Heavy Queries:
- No LIMIT on growing tables, SELECT * on large tables
- N+1 patterns, missing indexes, full table loads to filter in app

Connection Pooling:
- Pooled vs fresh per request, size configured, properly closed

Caching:
- Expensive ops cached, API responses cached
- Invalidation logic, works across instances

File Handling:
- Object storage vs local server
- Large file processing async vs blocking

Bundle Size:
- Large dependencies imported fully when only parts needed
- Duplicate dependencies

Image Optimisation:
- Images not oversized for display, modern formats
- Width/height set, lazy loading, hero images not blocking render
- Report largest with actual vs ideal sizes

Time to Interactive:
- First meaningful content, time to interactive
- Pages over 2s to load

STEP 5 - PILLAR 4: OBSERVABILITY
Rate each appropriately per sub-check.

Logging:
- Library vs console.log, errors with context
- Severity levels, no sensitive data logged

Error Monitoring:
- Sentry/Datadog/etc integrated, user context, source maps

Health Checks:
- Endpoint exists, tests dependencies not just returns 200

Alerting:
- Downtime and error rate alerts configured

Audit Trail:
- User actions, admin actions, data changes logged

NOTE: Design, responsive, and accessibility checks are best done
with /test or /test-deep which use the browser. This standalone
audit focuses on code-level concerns. Run /test for visual checks.

STEP 6 - DISPLAY RESULTS

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FOUR PILLARS AUDIT RESULTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  PILLAR 1 - RELIABILITY
  [sub-check]: [rating] [icon]
  Score: [X]/10

  PILLAR 2 - SECURITY
  [sub-check]: [rating] [icon]
  Score: [X]/10

  PILLAR 3 - SCALABILITY
  [sub-check]: [rating] [icon]
  Score: [X]/10

  PILLAR 4 - OBSERVABILITY
  [sub-check]: [rating] [icon]
  Score: [X]/10

  OVERALL PRODUCTION READINESS: [X]/10

  9-10: PRODUCTION READY
  7-8: NEARLY THERE
  5-6: NOT QUITE READY
  Below 5: NEEDS WORK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Icons: Strong/Clean/Fast = checkmark, Adequate/Partial = warning,
Weak/Missing/Vulnerable = cross

STEP 7 - SAVE AND OFFER NEXT STEPS

Save findings to ~/.claude/context/pillars-audit.json

Ask:
Would you like me to fix the issues found?
Type yes to spawn the agent fix team
Type report to generate an HTML report of the audit
Type prioritise to show what to fix first in order
