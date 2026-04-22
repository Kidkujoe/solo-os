---
name: reviews
description: Branch and review status board. Shows all open branches, their review status, what is blocking merge and detects conflicts across branches.
allowed-tools: Bash
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

Display the full branch and review status board.

STEP 1 - GET ALL BRANCHES:
Run `git branch -a` and `git branch -r`.

STEP 2 - STATUS OF EACH BRANCH:
For each non-default branch:
- Last commit: `git log [branch] -1 --format="%H %s %ar"`
- Ahead/behind: `git rev-list --left-right --count [DEFAULT_BRANCH]...[branch]`
- Changed files: `git diff [DEFAULT_BRANCH]...[branch] --name-only`
- Check for open PR on platform (via `gh pr list --head [branch]`)

STEP 3 - READ REVIEW HISTORY:
Read $PROJECT_CONTEXT/REVIEWS.md and match each branch to its review record.

STEP 4 - CONFLICT DETECTION:
For every pair of non-default branches:
Run `git diff [branch-a]...[branch-b] --name-only`.
If any file appears in both: flag as potential conflict.
Recommend merge order based on which branch was created earlier.

STEP 5 - DISPLAY STATUS BOARD:

  BRANCH AND REVIEW STATUS — [timestamp]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  For each branch:

  [branch-name]
  Last commit: [message] ([time ago])
  Changes: [count] files, +[added] -[removed] lines
  Status: READY TO MERGE / REVIEW IN PROGRESS / FIXES NEEDED /
          NOT REVIEWED / PR OPEN
  Review: [date or NEVER]
  Quality: [score or N/A]
  Findings: [fixed] / [total]
  PR: [link or NONE]
  Blocking: [what is stopping merge or NOTHING]

  CONFLICT WARNINGS:
  [branch-a] and [branch-b] both modified: [files]
  Recommended merge order:
  1. [branch] first (branched earlier)
  2. [branch] second (re-review after first merges)

  SUMMARY
  Total: [count]  Ready: [count]  Review needed: [count]
  Fixes needed: [count]  Conflicts: [count]

  Commands:
    /review-cycle [branch] - start review
    /merge-ready [branch]  - check merge readiness
    /rollback [feature]    - rollback a merge
