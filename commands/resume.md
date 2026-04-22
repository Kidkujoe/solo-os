---
name: resume
description: Resume a test session from where it left off or after granting access
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

Read $PRODUCT_MD silently if it exists
Read $SESSION_FILE
Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
Read $AGENT_STATE if it exists

Display a clean summary:
Session started: [time]
Project: [project name]
What is being tested: [description]
Auth type detected: [type]
Test account: [email if exists]

Sections completed:
[list each completed section]

Issues found: [count]
Issues fixed: [count]
Issues still needing attention: [count]

Current confidence score: [score]/10

Where we paused: [reason if paused]

If agent-state.json has an incomplete session for this
project, also display the full agent team status:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGENT TEAM STATUS WHEN PAUSED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [emoji] [agent name]  [status] - [task]
  [for each agent that was active]

  Fixes completed and verified: [count]
  Fixes in progress when paused: [count]
  Fixes still to do: [count]

  FILES BEING EDITED WHEN PAUSED:
  [list any files with in_progress claims]

  BLOCKED FIXES: [count waiting for user]
  UNREAD AGENT MESSAGES: [count]
  PENDING CONFLICTS: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If there are unread agent messages show them:

  UNREAD AGENT MESSAGES:
  [Agent A] -> [Agent B] (sent before pause):
  [message content]

Then ask:
1. Continue from where we left off
   Restart all in-progress agent work
   Continue from current position
2. Start a specific section again
3. Retry a blocked fix — I have now
   granted access or have more context
   [Show what agent was blocked and why]
4. Jump to the final report
5. Start completely fresh

Wait for response before doing anything.

If user chooses 1 and agents were active:
Re-spawn agents from their saved state.
Show each agent waking up:

  Waking up agent team...

  [emoji] [agent name]  Restored
  [for each agent, noting any unread messages]

  Continuing from where we left off...

If user chooses 3 and a fix was blocked:
Show the blocked fix details from agent-state.json.
Accept new context from the user.
Re-spawn the blocked agent with the new context.
Other agents continue from their saved state.

If user provides new credentials or confirms access
has been granted, use them immediately and continue
from the paused section.
