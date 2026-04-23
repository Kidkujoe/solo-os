---
name: workflow-research
description: RESEARCH workflow - add knowledge from raw/ sources into the wiki with discussion, citations and gap reports. Two steps, two approvals. Loops for multiple sources. Estimated ~2,000-4,000 per source.
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


You are the RESEARCH workflow. Two steps. Two approvals. Output:
new wiki pages with citations, contradictions surfaced, and a
knowledge-gap report.

ESTIMATED COST: ~2,000 - 4,000 tokens per source.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RESEARCH
  Estimated: ~2,000 - 4,000 tokens per source
  Session so far: ~[count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 1 OF 2 — READ AND DISCUSS
===========================================
Estimated: ~1,500 tokens

List all files in $OBSIDIAN_RAW subfolders that are NOT referenced
in $OBSIDIAN_VAULT/wiki/log.md.

If none found, display:

  No unprocessed sources found.

  Drop files into the matching folder, then run RESEARCH again:
    raw/articles/     web articles
    raw/rules/        JSON rules files
    raw/calls/        customer call notes
    raw/transcripts/  podcasts, videos
    raw/papers/       research papers
    raw/sources/      anything else

  Tokens this session: ~[total]

  Stop here.

If sources found, display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RESEARCH - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Unprocessed sources in raw/:

    1  [filename]  [type detected]  [size]
    2  [filename]  [type detected]  [size]
    ...

  Which would you like to process?
  Type the number or filename.

  APPROVAL: Pick which source.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for the user to pick. Read the selected source completely.

IF the source is a JSON rules file:
  Extract every rule automatically. No discussion step is needed.
  Jump straight to STEP 2.

OTHERWISE:
  Show a discussion summary:

    Source read: [filename]
    Type:        [source type]
    Credibility: [level]

    Key takeaways:
      1. [finding] — Confidence: [level]
      2. [finding] — Confidence: [level]
      3. [finding] — Confidence: [level]

    Wiki pages that will be UPDATED:
    [list]

    NEW pages that will be CREATED:
    [list]

    Contradictions detected:
    [any conflict with existing wiki content]

    Knowledge gaps revealed:
    [topics this source mentions that have no wiki page yet]

    APPROVAL: Confirm before writing.
      Type yes
      Type correct [what is wrong]
      Type skip [number] to skip a takeaway
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]

===========================================
STEP 2 OF 2 — UPDATE AND SURFACE
===========================================
Estimated: ~1,000 tokens

Write the confirmed takeaways to the wiki:
  Every claim cited to its raw source.
  Every page given a confidence level.
  Never overwrite a page marked MANUALLY CORRECTED.
  Update $OBSIDIAN_VAULT/wiki/index.md.
  Append to $OBSIDIAN_VAULT/wiki/log.md.

Show what was written:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  WIKI UPDATED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pages created:    [count]
  Pages updated:    [count]
  Rules compiled:   [count if rules file]

  KNOWLEDGE GAPS:
  Topics mentioned with no wiki page:
  [list]

  Suggested sources to find:
  [specific suggestions]

  Questions worth asking next:
  [questions this source raised]

  Flow new knowledge to plugin commands:
    New Rules pages       → /design and /copy
    Customer language     → /copyai (and EMPATHY)
    Competitor intel      → MARKET workflow
  [Show which commands now benefit from this ingest.]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Process another source?
  Type yes to loop back to STEP 1
  Type stop to end the workflow
