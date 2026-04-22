---
name: pillars
description: Run the Four Pillars of Production Readiness audit without running a full visual test
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
REPORT_TEMPLATE    = ~/.claude/context/report-template.html
GLOBAL_ACCOUNTS    = ~/.claude/context/test-accounts-global.md
DEVELOPER_PROFILE  = ~/.claude/context/DEVELOPER_PROFILE.md

STEP R4 - VERIFY ISOLATION:
Every file path used in this command must either start with
$PROJECT_CONTEXT or be one of the approved global resources listed
below.

Approved globals inside ~/.claude/:
  ~/.claude/context/report-template.html      (shared HTML template)
  ~/.claude/context/test-accounts-global.md   (keyed test accounts)
  ~/.claude/context/DEVELOPER_PROFILE.md      (cross-project developer profile, v2.4.0+)
  ~/.claude/context/projects/                 (parent of all project folders)
  ~/.claude/commands/                         (the commands themselves)

Approved globals inside ~/Documents/SecondBrain/ (v2.5.0+ Obsidian vault):
  $OBSIDIAN_VAULT and anything under it, including raw/, wiki/,
  schema/, program/, Products/, Research/, Patterns/, Inbox/,
  Templates/, Developer/. Resolved dynamically in STEP R8.

If any path outside these is referenced, stop and report.

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

Wiki-layer paths (v2.5.0+):
  OBSIDIAN_RAW="$OBSIDIAN_VAULT/raw"
  OBSIDIAN_WIKI="$OBSIDIAN_VAULT/wiki"
  OBSIDIAN_SCHEMA="$OBSIDIAN_VAULT/schema"
  OBSIDIAN_PROGRAM="$OBSIDIAN_VAULT/program"
  OBSIDIAN_PROGRAM_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME.md"

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

Save findings to $PROJECT_CONTEXT/pillars-audit.json

Ask:
Would you like me to fix the issues found?
Type yes to spawn the agent fix team
Type report to generate an HTML report of the audit
Type prioritise to show what to fix first in order
