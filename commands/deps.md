---
name: deps
description: Proactive dependency health audit. Outdated packages, abandoned packages, breaking changes in major upgrades, security vulnerabilities, safe vs risky upgrade classification.
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

PHASE 1 - DETECT PACKAGE MANAGER:
- package.json + package-lock.json -> npm
- package.json + yarn.lock -> yarn
- package.json + pnpm-lock.yaml -> pnpm
- requirements.txt or pyproject.toml -> pip
- Gemfile -> bundler
- go.mod -> go modules
- Cargo.toml -> cargo

If multiple found: audit each.

PHASE 2 - OUTDATED PACKAGES:
For npm/yarn/pnpm: `npm outdated --json`. Parse each outdated package.
For pip: `pip list --outdated --format=json`.

Classify each:
- PATCH (1.2.3 -> 1.2.4): very low risk, bug fix only
- MINOR (1.2.3 -> 1.4.0): usually safe, new features, backward compatible
- MAJOR (1.2.3 -> 2.0.0): breaking changes likely, review required

For each MAJOR update, search for breaking change notes in the package's
changelog. Summarise what breaks.

PHASE 3 - ABANDONED PACKAGES:
For each dependency check npm registry or equivalent:
- Last publish date
- Weekly download count
- GitHub repo status

Flag ABANDONED: not updated in 2+ years AND fewer than 1000 weekly downloads.
Flag AT RISK: not updated in 1+ year OR downloads declining significantly.

PHASE 4 - SECURITY CHECK:
`npm audit --json` across all dependencies. Parse all severities
(critical, high, moderate, low).

PHASE 5 - DISPLAY AND RECOMMEND:

  DEPENDENCY HEALTH REPORT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total dependencies: [count]
  Up to date: [count]
  Outdated: [count]

  SAFE TO UPGRADE NOW ([count]):
  [package] [current] -> [latest] (patch)
  Command: npm update [package]

  REVIEW BEFORE UPGRADING ([count]):
  [package] [current] -> [latest] (minor)
  No breaking changes found.
  Command: npm install [package]@[latest]

  BREAKING CHANGES - PLAN CAREFULLY ([count]):
  [package] [current] -> [latest] (major)
  Breaking: [summary]
  Guide: [link to migration guide]

  ABANDONED PACKAGES ([count]):
  [package] - last updated [date]
  Alternatives: [suggestions from search]

  SECURITY VULNERABILITIES ([count]):
  Critical: [count]  High: [count]

  Run /deps fix to apply safe updates.
  Run /deps upgrade [package] for guided major upgrade.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If $ARGUMENTS is "fix":
Apply all patch and safe minor updates.
Run build to verify nothing broke.
Run test suite. Show results.

If $ARGUMENTS is "upgrade [package]":
Show breaking change summary.
Offer to create a backup branch first.
Run the upgrade. Build. Test. Show results.
If anything breaks offer to rollback.
