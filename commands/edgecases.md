---
name: edgecases
description: Analyse the app and discover edge cases without running a full test
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

Analyse this codebase deeply and generate a comprehensive
list of edge cases specific to this app.

Do not run any tests. Just analyse and think.

STEP 1 - LOAD CONTEXT
- Read $PRODUCT_MD silently if it exists
- Read $SESSION_FILE
- Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
- Read $EDGE_CASES if it exists
- Check for previous edge case analysis

STEP 2 - DEEP CODEBASE ANALYSIS

Read every key file in the project. Map every user flow.
Find every data boundary. Identify every integration point.
Think about every failure scenario.

Analyse:

TECH STACK PATTERNS
- What framework is being used
- What database or data layer exists
- What auth system is in place
- What third party services are connected
- What payment systems if any
- What file upload systems if any
- What real time features if any
- What API integrations exist
- What caching layer if any
- What background jobs if any

USER FLOW MAPPING
- Map every possible user journey from entry to completion
- Find where journeys branch
- Find where journeys can dead end
- Find where data is passed between steps
- Find where state is stored (localStorage, sessions, cookies)
- Find where tokens are passed

DATA BOUNDARIES
- What is the minimum valid input for every field
- What is the maximum valid input
- What characters could cause issues
- What happens at zero values
- What happens at negative values
- What happens with empty states
- What happens with very long strings
- What happens with special characters
- What happens with unicode and emoji
- What happens with SQL-like input
- What happens with HTML in inputs

ASYNC AND TIMING
- What operations take time to complete
- What shows loading states
- What could time out
- What happens if a user acts before loading completes
- What happens if network drops mid flow
- What race conditions could exist

PERMISSION BOUNDARIES
- What can a logged out user access
- What can a basic user access
- What can a premium user access
- What can an admin access
- Where do these boundaries overlap
- Where could they be bypassed

STEP 3 - GENERATE EDGE CASES

Based purely on what was found in the analysis,
independently generate a list of edge cases.
Do not use a generic checklist. Think specifically
about this app.

Organise into:

HAPPY PATH VARIATIONS
Things that should work but in slightly different ways
than the most obvious path.

BOUNDARY CONDITIONS
The edges of what the system accepts.

UNHAPPY PATH SCENARIOS
Things users do that they should not.

BROKEN ENVIRONMENT SCENARIOS
Things that break the environment around the action.

INTEGRATION FAILURE SCENARIOS
What happens when connected services fail.

PERMISSION EDGE CASES
Unusual combinations of access.

STATE CORRUPTION SCENARIOS
What could leave the app in a bad state.

STEP 4 - DISPLAY FULL REPORT

Display all discovered edge cases organised by risk:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EDGE CASE ANALYSIS COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project: [name]
  Files analysed: [count]
  Edge cases found: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  HIGH RISK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  For each:
  What: [plain English description]
  Why risky: [what could go wrong]
  How to test: [plain English approach]
  Category: [which category above]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  MEDIUM RISK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  For each:
  What: [plain English description]
  Why: [brief reason]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  INTERESTING
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [List each with brief description]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 5 - SAVE TO FILE

Save all edge cases to $EDGE_CASES

Format:
# Edge Cases - [Project Name]

Date analysed: [date]
Total edge cases found: [count]

## HIGH RISK
[list each with description and test approach]

## MEDIUM RISK
[list each]

## INTERESTING
[list each]

## TESTED
[empty - filled in during test sessions]

## NOT YET TESTED
[all of them initially]

STEP 6 - ASK WHAT TO DO NEXT

Display:

  Edge cases saved to:
  $EDGE_CASES

  Would you like to run these edge cases now?
  Type yes to start /test with edge cases
  Type save to keep for later
