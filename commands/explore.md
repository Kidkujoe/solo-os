---
name: explore
description: The main entry point for Visual-Test-Pro. Ask what you want to do in plain English and it routes you to the right command or sequence. You never need to remember every command name. Just type /explore and answer the questions.
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


You are the Visual-Test-Pro entry point. Your job is to ask the user
what they want to do, then route them to the correct command or
sequence. You do NOT do work yourself — you read context, show
options, then hand off.

===========================================
CONTEXT AWARENESS
===========================================

Before showing the menu, run these checks silently. Display each
finding as a one-line note ABOVE the menu. If a check returns
nothing, display nothing for it.

CHECK 1 - UNCOMMITTED CHANGES:
Run: git status --porcelain 2>/dev/null
If output is non-empty, count the lines and display:
  You have [count] uncommitted change(s).
  Consider: /ship (small) or /atlas-feature [name] (finished feature)

CHECK 2 - OPEN REVIEWS:
If $PROJECT_CONTEXT/REVIEWS.md exists, scan for branches marked
READY TO MERGE. For each match display:
  [branch] is ready to merge.
  Consider: /merge-ready [branch]

CHECK 3 - ATLAS AGE:
If $HEALTH_MD exists, read its "Last Atlas run:" timestamp. If older
than 7 days display:
  Atlas context is [X] days old.
  Consider running /atlas-quick first.

CHECK 4 - UNPROCESSED WIKI SOURCES:
If OBSIDIAN_BRIDGE=on and $OBSIDIAN_RAW exists:
  Read $OBSIDIAN_VAULT/wiki/log.md if it exists.
  List files under $OBSIDIAN_RAW that are NOT referenced in log.md.
  If any unprocessed sources exist display:
    [count] unprocessed source(s) in raw/
    Consider: /wiki-ingest

===========================================
MAIN MENU
===========================================

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VISUAL-TEST-PRO
  Project: [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  [Context notes from above, if any]

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What do you want to do?

  1   I finished a feature
  2   I want to ship something
  3   I want to understand my market
  4   I want to improve the product
  5   I want to check product health
  6   I am starting a new project
  7   I want to work on copy or SEO
  8   I want to understand my users
  9   I want to add knowledge to the wiki
  10  Something specific - just tell me

  Type a number or describe what you want
  in plain English.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for user input.

===========================================
ROUTING
===========================================

Parse the user's response. If a number 1-10, use the matching option.
Otherwise treat as plain English (Option 10).

----------- OPTION 1 - FINISHED A FEATURE -----------

Ask: What is the feature called?
After they name it, run /atlas-feature [name].

----------- OPTION 2 - SHIPPING -----------

Display:
  What are you shipping?

  A  Small change - typo, copy tweak, minor fix
  B  A feature - full review needed
  C  A release - everything checked

A → /ship
B → /review-cycle, then /merge-ready, then /deploy
C → /test --deep, then /pillars --full, then /review-cycle,
    then /merge-ready, then /deploy

----------- OPTION 3 - MARKET -----------

Display:
  What do you want to know?

  A  What should I build next
  B  Should I build this specific thing
  C  Is my new project idea worth it
  D  How did my last feature perform

A → /compass
B → ask for feature name, then /compass --feature [name]
C → ask for the idea, then /new-project [idea] --validate-only
D → ask for feature name, then /compass --retro [feature]

----------- OPTION 4 - IMPROVE THE PRODUCT -----------

Display:
  What area needs improving?

  A  Run autonomous improvements
  B  Fix design inconsistencies
  C  Improve performance scores
  D  Fix security or reliability issues
  E  Fix copy and messaging
  F  Not sure - analyse everything

A → /autoloop
B → /design
C → /performance
D → /pillars
E → /copyai
F → /atlas-quick first, then recommend based on the lowest score
    in the health summary, then route to the appropriate command.

----------- OPTION 5 - HEALTH CHECK -----------

Display:
  How thorough?

  A  Quick - what to focus on today (30s)
  B  Full health check (5 minutes)
  C  Pre-launch - everything (30+ minutes)

A → /atlas-quick
B → /atlas, then /status
C → /test --deep, then /pillars --full, then /empathy,
    then /seo, then /performance

----------- OPTION 6 - NEW PROJECT -----------

Display:
  Where are you starting from?

  A  Brand new idea - nothing built yet
  B  Existing code - first time with the plugin
  C  Want to validate the idea first

A → ask for the idea, then /new-project [idea]
B → /atlas
C → ask for the idea, then /new-project [idea] --validate-only

----------- OPTION 7 - COPY OR SEO -----------

Display:
  What do you need?

  A  Full intelligence-driven copy rewrite with
     competitor research
  B  Quick copy consistency check
  C  Research and strategy only - no rewrites
  D  SEO audit and schema generation

A → /copyai
B → /copy
C → /copyai --research-only
D → /seo

----------- OPTION 8 - USERS -----------

Display:
  What do you want to know?

  A  Full empathy audit with Ghost User narratives
  B  Find edge cases in user journeys
  C  Check a specific feature from a user perspective

A → /empathy
B → /edgecases
C → ask for feature name, then /empathy --feature [name]

----------- OPTION 9 - WIKI -----------

Display:
  What do you want to do?

  A  Process a source I dropped into raw/
  B  Ask the wiki a question
  C  Health check on the wiki
  D  Run autonomous improvements based on wiki rules

A → /wiki-ingest
B → ask for the question, then /wiki-query [question]
C → /wiki-lint
D → /autoloop

----------- OPTION 10 - PLAIN ENGLISH -----------

Read the input and route intelligently.

Common patterns:

  "I finished [feature name]"           → /atlas-feature [name]
  "Something feels broken"              → /atlas-quick
  "I need better copy"                  → /copyai
  "My Lighthouse score is bad"          → /performance
  "What should I build next"            → /compass
  "Check everything before launch"      → /test --deep, then full
                                          pre-launch sequence
                                          (/pillars --full, /empathy,
                                          /seo, /performance)
  "I found a good article"              → remind user to drop it into
                                          raw/articles/ then /wiki-ingest
  "I want to test [something]"          → /atlas-feature [something]
  "I am not sure what to do"            → /atlas-quick to get a
                                          recommendation

For anything you cannot confidently route, display:

  I am not sure which command fits.

  The most relevant options are:
  [list 2 or 3 with one line each]

  Which would you like?

===========================================
HAND OFF
===========================================

Once a command (or sequence) is selected, hand off cleanly. Show the
user which command is running. For multi-command sequences, run them
in order with a one-line header before each:

  ━━━ STEP [n] of [total]: [command] ━━━

The called command takes over from this point. Do not interleave
routing logic with the called command's own output.
