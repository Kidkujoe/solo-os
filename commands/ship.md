---
name: ship
description: Lightweight daily driver for small commits that do not need the full review cycle. Quick check, generated commit message, commit with approval and push. For tweaks, copy changes, small fixes.
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

$ARGUMENTS can describe what was changed. If empty detect from git diff.

DECISION GUIDE:
USE /ship WHEN: typo, copy change, small UI tweak, minor bug fix in
non-critical area, docs update, config change, adding a test.

USE /review-cycle INSTEAD WHEN: new feature, auth/payment/security changes,
database schema changes, API endpoints added/modified, major refactor.

STEP 1 - CHECK WHAT CHANGED:
Run `git status --porcelain` and `git diff --stat HEAD`.
If no changes: "Nothing to ship. No uncommitted changes." Stop.

STEP 2 - QUICK SECRETS SCAN:
Scan changed files only for patterns: sk_live_, pk_live_, ghp_, gho_,
ghu_, AKIA, AIza, Bearer [long-string], password=, secret=, api_key=,
*_SECRET, *_KEY in non-example files.
If found: STOP immediately. Same rules as /review-cycle GATE 1.

STEP 3 - BUILD CHECK (FAST):
Run build with 30 second timeout. If fails ask fix-or-skip.

STEP 4 - QUICK BROWSER CHECK:
If Chrome connected do 10 second visual spot check on primary changed area.
Not a full test. Just confirm nothing is obviously broken.

STEP 5 - GENERATE COMMIT MESSAGE:
Read git diff. Generate conventional commits format:
type(scope): description

Types: feat, fix, docs, style, refactor, test, chore, perf.

Examples:
- fix(auth): correct session timeout handling
- feat(dashboard): add export button
- docs(readme): update installation steps
- style(landing): fix button alignment

Offer 3 message options from the diff. Ask: 1/2/3 or custom.

STEP 6 - COMMIT AND PUSH:
Display READY TO SHIP panel: count files, chosen message, current branch,
push target platform + remote. Wait for explicit yes.

Execute:
  git add -A
  git commit -m "[message]"
  git push origin [CURRENT_BRANCH]

Show SHIPPED panel: commit hash, message, branch, URL to commit on platform.

STEP 7 - ATLAS QUICK UPDATE:
Silently update $HEALTH_MD with ship timestamp. Note as minor change,
not a full feature.
