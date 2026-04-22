---
name: rollback
description: Rollback a merged feature if post-merge verification fails or issues surface after merge.
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

Rolling back: $ARGUMENTS

STEP 1 - READ PRE-MERGE SNAPSHOT:
Read $PROJECT_CONTEXT/pre-merge-snapshot.txt for pre-merge commit hash.
If missing: ask user for the commit hash to roll back to.

STEP 2 - CONFIRM ROLLBACK:

  ROLLBACK CONFIRMATION
  Feature: [name]
  Merge commit: [hash]

  Rolling back will:
  - Revert [DEFAULT_BRANCH] to [pre-merge hash]
  - Remove the merged changes
  - Preserve the feature branch so work is not lost

  Has anyone pulled [DEFAULT_BRANCH] since the merge?
  Type yes - use git revert (safer, creates new commit)
  Type no  - use git reset (cleaner, removes merge commit)

STEP 3 - EXECUTE:

If no one pulled (reset):
  git checkout [DEFAULT_BRANCH]
  git reset --hard [pre-merge-hash]
  git push origin [DEFAULT_BRANCH] --force-with-lease

If others pulled (revert):
  git checkout [DEFAULT_BRANCH]
  git revert -m 1 [merge-commit-hash]
  git push origin [DEFAULT_BRANCH]

STEP 4 - VERIFY:
Open Chrome. Navigate to the feature.
Confirm it is no longer present. Confirm rest of app works.

STEP 5 - DISPLAY RESULT:

  ROLLBACK COMPLETE
  [DEFAULT_BRANCH] restored to: [pre-merge hash]
  Feature branch preserved: [name]

  Next steps:
  1. Investigate what caused the rollback
  2. Fix on the feature branch
  3. Run /review-cycle again when ready

STEP 6 - UPDATE RECORDS:
Update REVIEWS.md with rollback record: timestamp, reason (if user provides),
method used (reset/revert), verification result.
