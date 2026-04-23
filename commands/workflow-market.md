---
name: workflow-market
description: MARKET workflow - understand your market and build a ranked product roadmap with evidence. Three steps, two approvals. PRISM-PV scoring. Estimated ~10,000-15,000 tokens.
allowed-tools: Bash, mcp__chrome-devtools__*
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


You are the MARKET workflow. Three steps. Two approvals. Output:
a ranked product roadmap with evidence and an anti-roadmap.

ESTIMATED COST: ~10,000 - 15,000 tokens.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MARKET
  Estimated: ~10,000 - 15,000 tokens
  Session so far: ~[count]
  Continue? Type yes to proceed or stop to cancel.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for confirmation.

===========================================
STEP 1 OF 3 — WHAT WE ALREADY KNOW
===========================================
Estimated: ~1,000 tokens

Read silently:
  $OBSIDIAN_VAULT/wiki/index.md
  Every Competitor-*.md page in wiki/
  Every Concept-*.md page about customer pain points
  $COMPASS_FILE if it exists

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MARKET - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Existing wiki intelligence:
    Competitors tracked: [count]
    Customer concepts:   [count]
    Last MARKET run:     [date or never]

  Known competitors:
  [list from wiki, one per line]

  What should I research next?

    A  All competitors fresh research
    B  Specific competitor: [user names them]
    C  New competitors only (skip ones already tracked)
    D  Customer pain signals only
    E  Everything from scratch

  APPROVAL: Choose research scope (A-E)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for selection.

===========================================
STEP 2 OF 3 — RESEARCH
===========================================
Estimated: ~8,000 - 12,000 tokens

Based on the approved scope, run the research pipeline.

MINE THESE SOURCES:
  Reddit threads about the problem space
  G2 and Capterra competitor reviews
  Product Hunt comments
  Twitter and Hacker News discussions
  App-store reviews if relevant

FOR EACH COMPETITOR:
  Extract what customers love.
  Extract what customers hate.
  Extract migration triggers.
  Extract feature requests.
  Update the wiki Competitor page automatically (write_competitor_note).

SCORE EVERY OPPORTUNITY (PRISM-PV):
  P  Pain signal strength
  R  Revenue and retention impact
  I  Implementation difficulty
  S  Strategic fit
  M  Market demand
  PV Painkiller vs Vitamin classification

Show progress as it runs:

  Researching Reddit...     done
  Researching G2...         done
  Researching Capterra...   done
  Scoring opportunities...  done

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STEP 2 COMPLETE
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 3 OF 3 — ROADMAP
===========================================
Estimated: ~1,000 tokens

Present the ranked opportunities:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  YOUR PRODUCT ROADMAP
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUILD THESE:

    1. [Feature name]
       Score: [PRISM-PV score]
       Type: [Painkiller / Vitamin]
       Evidence: [source count] sources
       Why: [one-sentence rationale]

    2. [Feature name]
       [same format]

    3. [Feature name]
       [same format]

  DO NOT BUILD:
    [Features researched but scored low]
    [One-line reason each]

  APPROVAL: Confirm top priority.
    Type the number to confirm
    Type adjust to change anything
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After approval:
  Save to $COMPASS_FILE.
  Update wiki with findings.
  Update Obsidian Research/ folder (write_competitor_note,
  write_insight_note, write_feature_note).

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
