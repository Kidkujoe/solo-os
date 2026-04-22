---
name: ship
description: Lightweight daily driver for small commits that do not need the full review cycle. Quick check, generated commit message, commit with approval and push. For tweaks, copy changes, small fixes.
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
