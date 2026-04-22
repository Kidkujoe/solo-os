---
name: status
description: Get a snapshot of the current test session at any point
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

Read $PRODUCT_MD silently if it exists
Read $SESSION_FILE
Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
Read $AGENT_STATE if it exists

Display:
Session started: [time]
Project: [name]
Testing: [what]
Auth type: [type]
Test account: [email or none]

Progress:
[tick] Section 1 Visual Testing - [status]
[tick] Section 2 Code Review - [status]
[tick] Section 3 Console Monitoring - [status]
[tick] Section 4 Responsive - [status]
[tick] Section 5 Accessibility - [status]
[tick] Section 6 CodeRabbit - [status]
[tick] Section 7 Edge Cases - [status]
[tick] Section 8 Fix Team - [status]
[tick] Section 9 HTML Report - [status]

Restricted areas:
[list each restricted area and access status]

Issues found: [count]
Issues fixed: [count]
Warnings remaining: [count]
Current confidence score: [score]/10
Currently on: [current section]
Next up: [what comes next]

If agent-state.json exists and has data for this project:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGENT TEAM STATUS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [emoji] [agent name]  [status] [current task]
  [for each agent in the state file]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Agent messages: [count] ([unread] unread)
  Conflicts: [count pending]
  Blocked fixes: [count waiting for user]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Files currently claimed:
  [filename] — [agent name] ([reason])
  [for each claimed file]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If there are blocked fixes show:
  BLOCKED — NEEDS YOUR INPUT:
  [issue description] — [agent name] waiting
  Type /resume to address this

REVIEW STATUS:
Read $PROJECT_CONTEXT/REVIEWS.md if it exists.
Run `git branch` to get all branches.

Display:

  REVIEW STATUS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Open branches:        [count]
  Ready to merge:       [count]
  Review in progress:   [count]
  Fixes needed:         [count]
  Conflicts detected:   [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If any branch is ready to merge:
  [branch-name] is ready to merge.
  Run /merge-ready [branch] to proceed.

If any review is stale (>48h old):
  [branch-name] review is [X] hours old.
  Consider re-running /review-cycle.

ASYNC CODERABBIT REVIEW POLLING:
Async CodeRabbit review completion is only detected when /status or
/reviews is run. It is NOT checked in the background between sessions.

For each branch with an open PR:
Fetch: GET /repos/[owner]/[repo]/pulls/[pr-number]/reviews
Compare against last recorded state.

If a CodeRabbit review completed since last check:

  CODERABBIT REVIEW READY
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Branch: [name]
  PR: [url]
  Findings: [count] ([severity breakdown])
  Completed: [timestamp]

  Run /review-cycle [branch] to review findings and apply fixes.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DEPLOYMENT STATUS:
Last deploy: [timestamp or NEVER]
Platform: [detected or UNKNOWN]
Production URL: [url or NOT SET]
Post-deploy smoke test: [PASSED / FAILED / NOT RUN]

DEPENDENCY HEALTH:
Last /deps run: [date or NEVER]
Outdated packages: [count or UNKNOWN]
Security vulnerabilities: [count or UNKNOWN]
If never run: "Run /deps for a health check"

ENVIRONMENT:
Last /env-diff run: [date or NEVER]
Missing in production: [count or UNKNOWN]
If never run: "Run /env-diff to verify"

PERFORMANCE:
Last /performance run: [date or NEVER]
Performance score: [value or NEVER RUN]
If not run in 30+ days: "Run /performance for up-to-date scores"
