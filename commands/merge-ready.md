---
name: merge-ready
description: Check if a branch is ready to merge. Runs all readiness checks, detects conflicts, creates PR if needed and requests merge with explicit approval.
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
