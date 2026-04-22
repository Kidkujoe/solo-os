---
name: screenshots
description: Manage screenshots from all test sessions
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

Read the screenshots folder at:
$SCREENSHOTS/

Display a summary:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCREENSHOT MANAGER
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total screenshots: [count]
  Total size: [size]
  Oldest session: [date]
  Newest session: [date]

  BY PROJECT:
  [project name]
    [date] session: [count] screenshots [size]

  OPTIONS:
  1. Delete all screenshots older than 7 days
  2. Delete all screenshots older than 30 days
  3. Delete screenshots for a specific project
  4. Delete all screenshots everywhere
  5. Archive old sessions to zip files
  6. Open the screenshots folder
  7. Show me what is in a specific session

  Type a number to choose.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for user to choose.

Never delete anything without confirming exactly
what will be deleted and how much space will be freed.

For option 1 or 2:
List every session that would be deleted with its
date, project name, screenshot count and size.
Ask: Delete these [count] sessions? Type yes to confirm.

For option 3:
List all projects with sessions. Ask which project.
Then list all sessions for that project. Confirm before deleting.

For option 4:
Show total count and size. Warn this cannot be undone.
Confirm twice before deleting.

For option 5:
Compress each session folder older than 7 days to zip.
Delete the original folders after successful compression.
Show space saved.

For option 6:
Open the screenshots folder in the file explorer.

For option 7:
List all sessions. Ask which one.
List every screenshot in that session with filename,
size, and what page or element it shows.
