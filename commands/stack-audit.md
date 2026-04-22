---
name: stack-audit
description: Health check on current project tech stack. Community health, known issues, version currency, technical debt score. --deep adds architecture assessment and migration planning.
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

Read ~/.claude/context/DEVELOPER_PROFILE.md and $PRODUCT_MD.
Detect stack from package.json or equivalent.

PHASE 1 - STACK INVENTORY:
List every dependency with current version. Classify as CORE (product
won't run without it), IMPORTANT (significant feature depends on it),
UTILITY (helper), DEV (dev only).

Display framework, database, auth, deployment, core deps count, total
deps count.

PHASE 2 - COMMUNITY HEALTH per CORE and IMPORTANT dependency:
Check npm registry: current vs latest version, weekly downloads, last
published date, repository.
web_search "[pkg] deprecated", "[pkg] abandoned", "[pkg] alternative".

Classify as:
HEALTHY: actively maintained, growing/stable downloads, no deprecation
WATCH: maintained but slowing, downloads declining, infrequent releases
AT RISK: not updated 1+ year, declining downloads, unresolved issues,
  community discussing alternatives
DEPRECATED/ABANDONED: official deprecation, or no updates 2+ years
  with no maintainer response

PHASE 3 - VERSION CURRENCY:
SAFE TO UPDATE (patch/minor): low risk, provide update command
REVIEW BEFORE UPDATING (minor with potential breaks): check changelog
MAJOR UPDATE - PLAN REQUIRED: breaking changes, migration guide,
  effort estimate

PHASE 4 - TECHNICAL DEBT SCORE:
Start at 100.
-10 per AT RISK dependency
-20 per DEPRECATED dependency
-5 per dep more than 2 major versions behind
-15 per dep with known CVEs
-25 per abandoned dep with no alternative

Score: 80-100 HEALTHY / 60-79 MANAGEABLE / 40-59 ACCUMULATING /
Below 40 CRITICAL.

PHASE 5 - DISPLAY:
Overall health score, status, HEALTHY/WATCH/AT RISK/DEPRECATED lists,
safe to update commands, major updates requiring planning, recommended
actions (this week / this month / this quarter).

IF --deep FLAG:
ARCHITECTURE ASSESSMENT: is current architecture appropriate for
current scale? First scaling bottlenecks? What changes at 10x usage?

MIGRATION PLANNING: for each AT RISK or DEPRECATED dep provide
specific migration plan: what to migrate to, why this alternative,
effort in hours/days, migration risk, recommended timing.

Update DEVELOPER_PROFILE.md with lessons from this audit.
Write to Obsidian LessonsLearned if vault exists.
