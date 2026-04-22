---
name: compass-feature
description: Evaluate a specific feature idea using the PRISM-PV framework. Research whether the pain signal is real, score it, classify as Painkiller or Vitamin, check strategic fit and recommend build, validate or decline.
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

Evaluating feature: $ARGUMENTS

Read $PRODUCT_MD silently if it exists
Read $STRATEGY_MD
Read $ATLAS/COMPASS.md

Run COMPASS Phases 0, 1, 3, 4, 5, 6 and 7 scoped to this feature.

Research this specific feature across all platforms with collection targets.
Tag and cluster data. Score using full PRISM-PV framework.
Run conflict checks. Provide validation recommendation if score 6-9.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FEATURE VERDICT: [name]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRISM-PV Score: [X]/25
  Classification: [BUILD/VALIDATE/DECLINE]
  PV Status: [Painkiller type / Vitamin type]
  Urgency: [ACUTE/GROWING/LATENT/TRIGGERED]

  P [pain]: [X]/6  R [revenue]: [X]/4
  I [effort]: [X]/2  S [strategic]: [X]/3
  M [market]: [X]/3  PV: [X]/2
  Modifiers: [+/- X]

  Build vs buy: [recommendation]
  Moat: [strength]
  Strategic fit: [rating]

  Evidence: [count] instances across [count] platforms

  Top quote:
  "[quote]"
  Platform: [name] | Date: [date]
  Behaviour: [action]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Add result to COMPASS.md under Feature Evaluations.
