---
name: explore
description: The Solo OS entry point. Launches seven named workflows. Context-aware - reads project state before showing options. Token costs shown upfront. Type a number or describe what you want in plain English.
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
REPORT_TEMPLATE    = ~/.claude/context/report-template.html
GLOBAL_ACCOUNTS    = ~/.claude/context/test-accounts-global.md
DEVELOPER_PROFILE  = ~/.claude/context/DEVELOPER_PROFILE.md

STEP R4 - VERIFY ISOLATION:
Every file path used in this command must either start with
$PROJECT_CONTEXT or be one of the approved global resources listed
below.

Approved globals inside ~/.claude/:
  ~/.claude/context/report-template.html      (shared HTML template)
  ~/.claude/context/test-accounts-global.md   (keyed test accounts)
  ~/.claude/context/DEVELOPER_PROFILE.md      (cross-project developer profile, v2.4.0+)
  ~/.claude/context/projects/                 (parent of all project folders)
  ~/.claude/commands/                         (the commands themselves)

Approved globals inside ~/Documents/SecondBrain/ (v2.5.0+ Obsidian vault):
  $OBSIDIAN_VAULT and anything under it, including raw/, wiki/,
  schema/, program/, Products/, Research/, Patterns/, Inbox/,
  Templates/, Developer/. Resolved dynamically in STEP R8.

If any path outside these is referenced, stop and report.

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

Wiki-layer paths (v2.5.0+):
  OBSIDIAN_RAW="$OBSIDIAN_VAULT/raw"
  OBSIDIAN_WIKI="$OBSIDIAN_VAULT/wiki"
  OBSIDIAN_SCHEMA="$OBSIDIAN_VAULT/schema"
  OBSIDIAN_PROGRAM="$OBSIDIAN_VAULT/program"
  OBSIDIAN_PROGRAM_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME.md"

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


You are the Solo OS entry point. Read project state silently,
display only what needs attention, then offer the seven workflows.
You do NOT do work yourself — you read context, route the user to
the right workflow body file, and hand off.

===========================================
TOKEN-TRACKING NOTE
===========================================

Claude Code does not expose exact token counts via API. Use these
approximations and disclose that they are estimates:

  Reading files:        ~100 per file
  Web search:           ~500 per search
  Running a command:    ~1,000 - 3,000
  Full visual test:     ~5,000 - 8,000
  Full empathy audit:   ~8,000 - 12,000
  Full market research: ~10,000 - 15,000
  Full product audit:   ~30,000 - 50,000

Track a running session estimate from these. Show "~" prefix to
remind the user these are approximate.

===========================================
CONTEXT AWARENESS - RUNS SILENTLY FIRST
===========================================

Before showing anything, read silently:

READ 1 - PROJECT STATE
  $HEALTH_MD                       — current health scores
  $PRODUCT_MD                      — feature inventory
  Run: git log --oneline -20       — recent changes
  Run: git status --porcelain      — uncommitted

READ 2 - AUDIT STATE
  $PROJECT_CONTEXT/REVIEWS.md      — what was reviewed and when
  Cross-reference git log to find features changed since their
  last audit.

READ 3 - WIKI STATE
  If OBSIDIAN_BRIDGE=on:
    $OBSIDIAN_VAULT/wiki/log.md    — last ingest date
    Files under $OBSIDIAN_RAW not in log.md — unprocessed sources

READ 4 - EXPERIMENT STATE
  If OBSIDIAN_BRIDGE=on:
    $OBSIDIAN_VAULT/program/[PROJECT_NAME]-experiments.md
    (or $OBSIDIAN_PROGRAM_FILE)    — last EVOLVE run

Build a context picture from all four. Display only items that
need attention. Do not show clean items.

===========================================
DISPLAY
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VISUAL-TEST-PRO 3.0
  Project: [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [Show only lines that apply. If everything is clean, show nothing
  in this block. Examples:]

  [count] uncommitted changes
  [feature] changed [X] days ago, not yet audited
  [branch] ready to merge
  [count] unprocessed source(s) in raw/
  EVOLVE last ran [X] days ago

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What do you want to do?

  1  SHIP      audit and ship a feature
               or run a full product audit
  2  BRIEF     start of day focus
  3  MARKET    understand what to build
  4  BUILD     start a new project
  5  EMPATHY   see it as your users do
  6  RESEARCH  add knowledge to the wiki
  7  EVOLVE    improve autonomously

  Type a number or describe what you want
  in plain English.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for user input.

===========================================
ROUTING - NUMBER INPUT
===========================================

1 → Read ~/.claude/commands/workflow-ship.md and follow its body
    (everything after the END OF RESOLVER line).
2 → Read ~/.claude/commands/workflow-brief.md and follow its body.
3 → Read ~/.claude/commands/workflow-market.md and follow its body.
4 → Read ~/.claude/commands/workflow-build.md and follow its body.
5 → Read ~/.claude/commands/workflow-empathy.md and follow its body.
6 → Read ~/.claude/commands/workflow-research.md and follow its body.
7 → Read ~/.claude/commands/workflow-evolve.md and follow its body.

Each workflow body owns the rest of the session from that point.

===========================================
ROUTING - PLAIN ENGLISH
===========================================

If the input is not a number, route by intent:

  "finished [feature]" / "done with [feature]"
    → SHIP, pre-select that feature

  "something feels broken"
    → SHIP drift mode on recent changes

  "what should I build" / "build next"
    → MARKET

  "new idea" / "new project"
    → BUILD

  "how do users see this" / "user perspective"
    → EMPATHY

  "I found an article" / "add to wiki"
    → RESEARCH. If the article is not yet in raw/, remind the
      user to drop it into raw/articles/ first.

  "run overnight" / "autonomous" / "improve"
    → EVOLVE

  "morning" / "what to focus on" / "where to start"
    → BRIEF

  "demo tomorrow" / "going live" / "launching"
    → SHIP, pre-select Mode 3 (Full Product Audit)

  "not sure" / "what do I do"
    → BRIEF. Let the recommendation guide.

For anything unclear:

  Not sure which workflow fits.

  Most likely options:
  [list 2 or 3 with one line each]

  Which would you like?

===========================================
HAND OFF
===========================================

Once a workflow is selected, display a one-line header before
handing over:

  ━━━ Launching [WORKFLOW NAME] ━━━

Then read the workflow body file and follow it. The workflow takes
over from this point. Do not interleave routing logic with the
workflow's own output.
