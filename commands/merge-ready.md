---
name: merge-ready
description: Check if a branch is ready to merge. Runs all readiness checks, detects conflicts, creates PR if needed and requests merge with explicit approval.
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

Feedback-loop paths (v3.1.0+):
  OBSIDIAN_LESSONS_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME-lessons.md"
  SKIP_TRACKER="$PROJECT_CONTEXT/skip-tracker.json"
  DECISIONS_FILE="$PROJECT_CONTEXT/DECISIONS.md"
  Full feedback-loop protocol: ~/solo-os/docs/FEEDBACK_LOOP.md

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

Checking merge readiness for: $ARGUMENTS

STEP 1 - IDENTIFY BRANCH:
Use $ARGUMENTS if provided. Otherwise use CURRENT_BRANCH.

STEP 2 - READ REVIEW RECORD:
Find review record in $PROJECT_CONTEXT/REVIEWS.md for this branch.
If none: warn "NO REVIEW RECORD FOUND. Run /review-cycle [branch] first.
Or type proceed to merge anyway with risk noted."

STEP 3 - STALE REVIEW CHECK:
Run `git log [last-review-commit]..[branch] --oneline`.
If commits exist since review: show list, ask 1) re-review changed files,
2) full /review-cycle, or 3) proceed with stale noted.

STEP 4 - REVIEW EXPIRY:
If review >48 hours ago: warn. Recommend re-review.

STEP 5 - CONFLICT CHECK:
Run `git merge --no-commit --no-ff [DEFAULT_BRANCH]`.
If conflicts: list files, stop pipeline. Run `git merge --abort` to clean up.

STEP 6 - QUALITY GATE:
Check review quality score from record. Below 60: warn before proceeding.

STEP 7 - OUTSTANDING FINDINGS:
Check for skipped Critical or High findings. Show them, ask to address.

STEP 8 - SCORECARD:

  MERGE READINESS SCORECARD
  Branch: [name]  Target: [DEFAULT_BRANCH]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Review completed:    [YES/NO]
  Review quality:      [X]/100
  Review fresh:        [YES/STALE]
  Pre-review gates:    [ALL PASSED/SOME SKIPPED]
  CodeRabbit findings: [ALL RESOLVED/[count] PENDING]
  Visual test:         [PASSED/NOT RUN]
  No merge conflicts:  [YES/NO]
  Secrets clean:       [YES/NO]
  Docs updated:        [YES/NO]

  VERDICT: APPROVED / NEEDS ATTENTION / BLOCKED
  Blocking issues: [list]

STEP 9 - PRE-MERGE SNAPSHOT:
Save current DEFAULT_BRANCH head commit to
$PROJECT_CONTEXT/pre-merge-snapshot.txt for /rollback use.

STEP 10 - CREATE/UPDATE PR:
If no PR: `gh pr create --title "[feature]" --body "..." --base [DEFAULT_BRANCH]`
Show URL. If PR exists show status.

STEP 11 - MERGE APPROVAL:

  READY TO MERGE
  Branch: [name]  Into: [DEFAULT_BRANCH]
  Will merge [count] commits:
  [list messages]
  PR: [URL]
  All checks passed.

  Approve merge?  Type yes / no

Wait for explicit yes. Never merge without this confirmation.

STEP 12 - EXECUTE MERGE:
Prefer: `gh pr merge [pr-number] --merge --delete-branch`
Fallback:
  git checkout [DEFAULT_BRANCH]
  git merge --no-ff [branch] -m "Merge [branch]: [feature]"
  git push origin [DEFAULT_BRANCH]
  git branch -d [branch]
  git push origin --delete [branch]

STEP 13 - POST-MERGE VERIFICATION:
Open app in Chrome. Navigate to merged feature. Confirm:
- App loads
- Feature accessible
- Primary action works
- No console errors

  POST-MERGE VERIFICATION
  Merge commit: [hash]  Branch deleted: [yes/no]
  App loads: [yes/no]  Feature accessible: [yes/no]
  Console errors: [none/count]
  Verdict: ALL CLEAR / ISSUES FOUND

If issues: offer to run /rollback.

STEP 14 - UPDATE RECORDS:
Update REVIEWS.md with merge details, HEALTH.md with timestamp,
COMPASS.md if feature was on roadmap.
