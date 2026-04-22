---
name: deps
description: Proactive dependency health audit. Outdated packages, abandoned packages, breaking changes in major upgrades, security vulnerabilities, safe vs risky upgrade classification.
allowed-tools: Bash
---

===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run: pwd to get the absolute project path.
Take the folder basename. Add a 6-character hash of the full path
(try md5sum first, fall back to shasum). Format as:
PROJECT_ID = [basename]-[6char-hash]
PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is not a project directory (is home, is
~/.claude, has no code files), display PROJECT NOT DETECTED
warning and stop. Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS:
mkdir -p $PROJECT_CONTEXT
mkdir -p $PROJECT_CONTEXT/atlas
mkdir -p $PROJECT_CONTEXT/screenshots
mkdir -p $PROJECT_CONTEXT/reports

STEP R3 - ESTABLISH ALL FILE PATHS:
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
REPORTS           = $PROJECT_CONTEXT/reports
TEST_REPORT       = $REPORTS/test-report.html
COPY_REPORT       = $REPORTS/copy-report.html
COMPASS_REPORT    = $REPORTS/compass-report.html
EMPATHY_REPORT    = $REPORTS/empathy-report.html
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

Global resources (shared across all projects):
REPORT_TEMPLATE   = ~/.claude/context/report-template.html
GLOBAL_ACCOUNTS   = ~/.claude/context/test-accounts-global.md

STEP R4 - VERIFY ISOLATION:
Every file path used in this command must either start with
$PROJECT_CONTEXT or be one of the two approved global resources.
If any other ~/.claude/context/ path is referenced, stop and report.

STEP R5 - DISPLAY CONTEXT CONFIRMATION:
Display a one-line confirmation so user can see which project:
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CHECK FOR CONTAMINATION:
If SESSION_FILE exists, check its first line for:
  # Project: [project-id]
If the stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning and ask user: 1) archive and start fresh, 2) show contents,
3) stop. Wait for response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

STEP R8 - KNOWLEDGE BRIDGE INITIALIZATION (v2.3.0+):
Read $STRATEGY_MD if it exists and extract the line:
  Obsidian vault: [path]
If found set OBSIDIAN_VAULT to that path.
If not found default to: OBSIDIAN_VAULT="$HOME/Documents/SecondBrain"

Derive these paths:
  OBSIDIAN_PRODUCTS="$OBSIDIAN_VAULT/Products"
  OBSIDIAN_RESEARCH="$OBSIDIAN_VAULT/Research"
  OBSIDIAN_PATTERNS="$OBSIDIAN_VAULT/Patterns"
  OBSIDIAN_INBOX="$OBSIDIAN_VAULT/Inbox"
  OBSIDIAN_PRODUCT_DIR="$OBSIDIAN_PRODUCTS/$PROJECT_NAME"

Check vault exists. If not found display:
  Obsidian vault not found at $OBSIDIAN_VAULT
  Knowledge Bridge disabled for this run.
  Set up Obsidian to enable. Continuing without it.
Then set OBSIDIAN_BRIDGE=off and skip all bridge calls.

If vault exists but $OBSIDIAN_PRODUCT_DIR is missing, create:
  mkdir -p "$OBSIDIAN_PRODUCT_DIR"/{Features,Decisions,Insights,Reviews}

Set OBSIDIAN_BRIDGE=on. Commands should call read/write functions
defined in RESOLVER.md § KNOWLEDGE_BRIDGE at their specified hooks.

END OF RESOLVER — continue with command logic below
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
