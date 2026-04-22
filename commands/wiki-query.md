---
name: wiki-query
description: Ask any question and get an answer synthesised from the compiled wiki with full citations. Every useful answer is automatically filed back as a Synthesis page so explorations compound in the knowledge base.
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

Run the RESOLVER first.

Then read:
- `$OBSIDIAN_VAULT/schema/WIKI_SCHEMA.md` — governance rules
- `$OBSIDIAN_VAULT/wiki/index.md` — master catalog of wiki pages

$ARGUMENTS is the question.

===========================================
QUERY PHASE 1 - FIND RELEVANT PAGES
===========================================

Read `wiki/index.md`. Identify every page relevant to answering the
question. Read only those pages. Do not read `raw/` sources unless a
specific claim needs verification.

===========================================
QUERY PHASE 2 - SYNTHESISE THE ANSWER
===========================================

Build the answer from wiki pages only. For every claim, state the
confidence level and cite the wiki page. If synthesising across
multiple pages, show the reasoning chain explicitly.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  WIKI QUERY: [question]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ANSWER:
  [Plain English answer]

  EVIDENCE CHAIN:
  Claim: [specific claim]
  Confidence: [level]
  Wiki page: [page name]
  Raw source behind it: [raw/ file]

  [Repeat for each claim]

  WHAT THE WIKI DOES NOT YET KNOW:
  [Parts the wiki cannot fully answer]

  To fill this gap add these source types to raw/:
  [Specific suggestions]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
QUERY PHASE 3 - FILE BACK INTO WIKI
===========================================

**CRITICAL — do not skip this step.**

From the Karpathy LLM Wiki gist: good answers can be filed back into
the wiki as new pages. A comparison you asked for, an analysis, a
connection you discovered — these are valuable and should not
disappear into chat history. Explorations compound in the knowledge
base just like ingested sources do.

If the answer synthesised across multiple wiki pages and produced a
non-obvious connection or conclusion, ask:

  This answer synthesised across [count] wiki pages.

  Worth filing as a Synthesis page?
  Proposed title: Synthesis-[topic].md

  Type yes / no / rename [title]

If yes:
- Create `Synthesis-[topic].md` with: conclusion, evidence chain,
  confidence level, contradicting evidence, "Created from query: [Q]",
  date
- Update `wiki/index.md`
- Append to `wiki/log.md`:
  `## [YYYY-MM-DD] synthesis | [topic] (from query: [question])`
