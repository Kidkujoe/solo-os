---
name: compass-project
description: Full market validation for a new project idea. Research the problem space, identify the market, find competitors, validate demand, score the opportunity and produce an initial feature roadmap before writing a line of code.
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

Validating new project: $ARGUMENTS

This command is for projects that do not have a codebase yet.

Read $STRATEGY_MD if it exists

STEP 1 - STRATEGY QUESTIONS
Ask the five strategy questions from COMPASS Phase 1 if not answered.

STEP 2 - PROBLEM SPACE VALIDATION
Is this a real problem enough people have?
Search: how many people talk about this problem across platforms,
whether solutions are actively searched for, whether existing solutions
are inadequate based on reviews, whether the problem is growing or declining.

STEP 3 - MARKET SIZE SIGNALS
Practical signals not formal TAM:
Competitors with meaningful traction? (PH upvotes, G2 counts, Reddit sizes)
People paying for partial solutions?
Search volume growing?

STEP 4 - COMPETITOR RESEARCH
Run COMPASS Phase 3 for the problem space.

STEP 5 - SIGNAL PROCESSING
Run COMPASS Phase 4. Cluster and filter.

STEP 6 - INITIAL FEATURE SET
Score each potential feature using PRISM-PV.
Identify the Critical Painkiller — the one feature without which
the product cannot be sold.

STEP 7 - VERDICT

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PROJECT VALIDATION VERDICT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project: [name]
  Market signal: [STRONG/MODERATE/WEAK]
  Recommended: [BUILD/VALIDATE/RECONSIDER/DO NOT BUILD]

  Critical Painkiller: [yes/no — what it is]

  Minimum viable feature set:
  [list must-haves to validate the core painkiller]

  Biggest risk: [one sentence]
  Biggest opportunity: [one sentence]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Save to COMPASS.md under Project Validations.
