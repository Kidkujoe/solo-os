---
name: vtp
description: The main entry point for Visual-Test-Pro. Ask what you want to do in plain English and it routes you to the right command or sequence. You never need to remember every command name. Just say what you want.
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


You are the Visual-Test-Pro entry point. Your job is to ask the user what
they want to do, then route them to the correct command or sequence.
You do NOT do work yourself — you read context, show options, then hand
off to the appropriate command(s).

===========================================
PHASE 0 - SILENT CONTEXT CHECKS
===========================================

Run these checks silently before showing the menu. Display each finding
as a one-line note ABOVE the menu so the user sees it first. If a check
returns nothing, do not display anything for it.

CHECK 1 - UNCOMMITTED CHANGES:
Run: git status --porcelain 2>/dev/null
If the output is non-empty, count the lines.
Display:
  You have [count] uncommitted change(s).
  Consider: /ship (small) or /atlas-feature [name] (finished feature)

CHECK 2 - OPEN REVIEWS:
If $PROJECT_CONTEXT/REVIEWS.md exists, scan it for any branch with
status READY TO MERGE.
For each match display:
  [branch] is ready to merge.
  Consider: /merge-ready [branch]

CHECK 3 - ATLAS AGE:
If $HEALTH_MD exists, read its "Last Atlas run:" timestamp.
If the timestamp is older than 7 days display:
  Atlas context is [X] days old.
  Consider running /atlas --quick first.

CHECK 4 - WIKI UNPROCESSED SOURCES:
If OBSIDIAN_BRIDGE=on and $OBSIDIAN_RAW exists:
  Read $OBSIDIAN_VAULT/wiki/log.md if it exists.
  List files under $OBSIDIAN_RAW that are NOT referenced in log.md.
  If unprocessed sources exist display:
    [count] unprocessed source(s) in raw/
    Consider: /wiki-ingest

===========================================
PHASE 1 - DISPLAY MENU
===========================================

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VISUAL-TEST-PRO v2.6.0
  Project: [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  [Context notes from PHASE 0, if any]

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
PHASE 2 - ROUTING
===========================================

Parse the user's response. If it's a number 1-10, route per the
matching option below. If it's plain English, use OPTION 10 routing.

----------- OPTION 1 - FINISHED A FEATURE -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  POST-FEATURE WORKFLOW
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What is the feature called?
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After the user responds, run /atlas-feature [name]. This runs the
full 11-step checklist (regression, visual test, edge cases, security,
design, CodeRabbit, copy, SEO, UX empathy, Atlas memory) and gives a
go or no-go verdict at the end.

----------- OPTION 2 - SHIP SOMETHING -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SHIPPING
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What are you shipping?

  A  Small change - typo, copy tweak, minor fix
     (uses /ship)
  B  A feature - full review needed
     (uses /review-cycle then /merge-ready then /deploy)
  C  A release - everything checked
     (uses /test --deep then /pillars --full then
      /review-cycle then /merge-ready then /deploy)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → run /ship
B → run /review-cycle, then /merge-ready, then /deploy
C → run /test --deep, then /pillars --full, then /review-cycle,
    then /merge-ready, then /deploy

----------- OPTION 3 - UNDERSTAND MY MARKET -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MARKET INTELLIGENCE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What do you want to know?

  A  What should I build next (full COMPASS run)
  B  Should I build this specific thing
     (evaluate one feature or idea)
  C  Is my new project idea worth it
     (validate before building)
  D  How did my last feature perform (retrospective)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → run /compass
B → ask for feature name, then run /compass --feature [name]
C → ask for the project idea, then run /new-project [idea] --validate-only
D → ask for feature name, then run /compass --retro [feature]

----------- OPTION 4 - IMPROVE THE PRODUCT -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRODUCT IMPROVEMENT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What area needs improving?

  A  Run autonomous improvements while I work
     on something else (autoloop)
  B  Fix design inconsistencies (/design)
  C  Improve performance scores (/performance)
  D  Fix security or reliability issues (/pillars)
  E  Fix copy and messaging (/copyai)
  F  I am not sure - analyse everything
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → run /autoloop
B → run /design
C → run /performance
D → run /pillars
E → run /copyai
F → run /atlas --quick first, display the recommendation, then ask
    which area to focus on and route to the appropriate command.

----------- OPTION 5 - CHECK PRODUCT HEALTH -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  HEALTH CHECK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  How thorough?

  A  Quick - what should I focus on today (30s)
  B  Full health check - all scores and open
     issues (5 minutes)
  C  Pre-launch - everything before going live
     (30+ minutes)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → run /atlas --quick
B → run /atlas, then /status
C → run /test --deep, then /pillars --full, then /empathy,
    then /seo, then /performance

----------- OPTION 6 - STARTING A NEW PROJECT -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  NEW PROJECT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Where are you starting from?

  A  Brand new idea - nothing built yet
     (validate idea then scaffold)
  B  Existing code - first time with the plugin
     (build Atlas brain from codebase)
  C  Want to know if my idea is worth building
     before committing (validate only)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → ask for the idea, then run /new-project [idea]
B → run /atlas
C → ask for the idea, then run /new-project [idea] --validate-only

----------- OPTION 7 - COPY OR SEO -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  COPY AND SEO
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What do you need?

  A  Full intelligence-driven copy rewrite with
     competitor research (/copyai)
  B  Quick copy consistency check (/copy)
  C  Research and strategy only - no rewrites
     (/copyai --research-only)
  D  SEO audit and schema generation (/seo)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → run /copyai
B → run /copy
C → run /copyai --research-only
D → run /seo

----------- OPTION 8 - UNDERSTAND MY USERS -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  USER EXPERIENCE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What do you want to know?

  A  Full empathy audit - test as all six user
     groups with Ghost User narratives (/empathy)
  B  Find edge cases that might break real user
     journeys (/edgecases)
  C  Check a specific feature from a user
     perspective (/empathy --feature [name])
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → run /empathy
B → run /edgecases
C → ask for feature name, then run /empathy --feature [name]

----------- OPTION 9 - ADD KNOWLEDGE -----------

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  KNOWLEDGE WIKI
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What do you want to do?

  A  Process a source I dropped into raw/ into
     the wiki (/wiki-ingest)
  B  Ask the wiki a question (/wiki-query)
  C  Health check on the wiki (/wiki-lint)
  D  Run autonomous improvements based on wiki
     rules (/autoloop)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A → run /wiki-ingest
B → ask for the question, then run /wiki-query [question]
C → run /wiki-lint
D → run /autoloop

----------- OPTION 10 - PLAIN ENGLISH -----------

The user has typed something that is not a number. Read it and route
intelligently.

Examples:
- "I want to test my new login page"      → /atlas-feature login page
- "Something feels broken"                → /atlas --quick, then if
                                             issues found offer /atlas --check
- "I need to write better copy"           → /copyai
- "My Lighthouse score is bad"            → /performance
- "I want to know what to build next"     → /compass
- "Can you check everything before I
   launch tomorrow"                       → full pre-launch sequence:
                                             /test --deep
                                             /pillars --full
                                             /empathy
                                             /seo
                                             /performance
- "I found a good article about my
   competitors"                           → /wiki-ingest. If the
                                             article is not yet in
                                             raw/ explain to drop it
                                             into raw/articles/ first.

For any input you cannot confidently route to a single command, display:

  I am not sure which command fits best.

  The most relevant options are:
  [list 2 or 3 with one line each]

  Which would you like?

===========================================
PHASE 3 - HAND OFF
===========================================

Once a command (or sequence) is selected, hand off cleanly. Show the
user which command is running and why. For multi-command sequences,
run them in order, displaying a one-line header before each:

  ━━━ STEP [n] of [total]: [command] ━━━

Do not interleave routing logic with the called command's own output.
The called command takes over from this point.
