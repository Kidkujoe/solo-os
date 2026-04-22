---
name: wiki-ingest
description: Process any source file from raw/ into the Obsidian wiki. Reads the source, discusses key takeaways, writes and updates wiki pages, detects contradictions, tracks confidence and logs everything. Handles markdown, JSON rules files and plain text. Do one source at a time for best results.
allowed-tools: Bash, WebSearch
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

Run the RESOLVER first.

Then read:
- `$OBSIDIAN_VAULT/schema/WIKI_SCHEMA.md` — governance rules for every wiki operation
- `$OBSIDIAN_VAULT/wiki/index.md` — current wiki state

$ARGUMENTS is the filename in `raw/` to process.

If $ARGUMENTS is empty:
- List every file in `$OBSIDIAN_VAULT/raw/` that does not already
  appear in `$OBSIDIAN_VAULT/wiki/log.md`
- Ask which to process
- Wait for response

===========================================
INGEST PHASE 1 - IDENTIFY SOURCE TYPE
===========================================

Read the source file completely. Identify its type:

**RULES FILE** (`.json` or structured `.md` inside `raw/rules/`)
Contains explicit rules, standards or guidelines.
Treatment: Compile each rule into a dedicated `Rules-[Domain].md` page.
Rules are non-negotiable standards. Every future audit checks against
them.

**RESEARCH ARTICLE**
An article about the market, competitors or users.
Treatment: Extract key claims, identify entities mentioned, update
relevant entity and concept pages.

**CUSTOMER CALL NOTES**
Notes from a real user conversation.
Treatment: Extract pain points in their exact words, update concept
pages, add to customer language bank for `/copyai`.

**COMPETITOR RESEARCH**
Information about a specific competitor.
Treatment: Update or create the competitor entity page in `wiki/`.
Note: this is separate from `Research/Competitors/` which plugin
commands write to. Do not confuse them.

**PERSONAL THINKING**
Your own notes about the product.
Treatment: Treat as high-signal context. Extract strategic implications.
Update synthesis pages.

**TRANSCRIPT**
A podcast or video transcript.
Treatment: Same as research article, but note spoken language may be
less precise than written sources.

===========================================
INGEST PHASE 2 - JSON RULES FILES
===========================================

JSON files in `raw/rules/` get special handling because they are
structured.

Read every key-value pair. For each rule, create or update a Rules
page in `wiki/`:

`Rules-[Domain].md`

Format each rule as:

```
## Rule: [rule name]
Statement: [the rule in plain English]
Applies to: [what this governs]
Violation looks like: [example]
Correct looks like: [example]
Source: [raw/rules/filename.json]
Confidence: HIGH
(Explicit rule from human = highest possible confidence)
```

After compiling all rules:
- Update `wiki/index.md`
- Append to `wiki/log.md`

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RULES FILE INGESTED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Source: [filename]
  Rules extracted: [count]
  Wiki pages created or updated: [list]

  These rules will now be enforced in:
  /design   — design consistency checks
  /copy     — brand voice checks
  /autoloop — autonomous improvements
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
INGEST PHASE 3 - DISCUSSION STEP
===========================================

For all non-rules sources, this step is **mandatory**. Do not skip.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SOURCE READ: [filename]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Type: [source type]
  Credibility: [HIGH/MEDIUM/LOW/UNKNOWN]
  Date: [if identifiable]

  KEY TAKEAWAYS:
  1. [Most important finding]
     Confidence: [level and why]

  2. [Second finding]
     Confidence: [level and why]

  3. [Third finding if relevant]
     Confidence: [level and why]

  WIKI PAGES THAT WILL BE UPDATED:
  [List existing pages this touches]

  NEW PAGES NEEDED:
  [New entities or concepts to create]

  CONTRADICTIONS DETECTED:
  [Any conflict with existing wiki claims]

  KNOWLEDGE GAPS REVEALED:
  [What this source shows we do not know yet — what to look for next]

  Does this match your understanding?
  Type yes to write to wiki
  Type correct [what] to adjust first
  Type skip [number] to exclude a takeaway
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for response. Do not write anything to the wiki until confirmed.

===========================================
INGEST PHASE 4 - WRITE TO WIKI
===========================================

After confirmation, write to `wiki/`.

Rules:
- Every claim must cite its source (`[Source: raw/folder/filename.md]`)
- Every page must have a confidence level
- Never overwrite `MANUALLY CORRECTED` sections
- Update existing pages rather than creating duplicates
- Update `wiki/index.md` after writing
- Append to `wiki/log.md`

Show each page written:

  WIKI UPDATED: [page name]
  Action: CREATED / UPDATED
  Added: [what was written]
  Confidence: [level]
  Source: [raw/folder/filename]

Contradictions:
- If a new claim conflicts with an existing one, do **not** silently
  overwrite. Append both to `wiki/contradictions.md`, show both with
  their sources, and ask the user to resolve.

===========================================
INGEST PHASE 5 - KNOWLEDGE GAP REPORT
===========================================

After every ingest, report what the source revealed that the wiki
does not yet cover.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  KNOWLEDGE GAPS IDENTIFIED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Topics mentioned with no wiki page:

  [Topic]: mentioned [count] times
  Suggested source to find:
  [Specific type of source]

  Questions this source raised:
  [Questions the wiki cannot yet answer]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
