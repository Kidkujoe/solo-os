---
name: workflow-build
description: BUILD workflow - new project from idea to running code. Four steps, two approvals. Validates with market research, defines strategy, recommends stack, scaffolds project, plants first feature. Estimated ~12,000-18,000 tokens.
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

Orphan check FIRST (v3.2.0+). Run only when $PROJECT_CONTEXT does
not yet exist — i.e., this is the first time a command runs for
this project path:

  1. List all existing folders under ~/.claude/context/projects/.
  2. For each folder, read atlas/PRODUCT.md if present and extract
     the product name (first H1 or explicit "name:" field).
  3. Compare against the current project's package.json "name"
     field (if present) or the current directory basename.
  4. If one or more matches are found, display:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EXISTING CONTEXT FOUND
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    It looks like this project may have been renamed or moved.

    Found existing context for:
    [product name]
    Last active: [date from atlas/HEALTH.md]
    Contains:
      Atlas memory:      [yes/no]
      Review history:    [count records from REVIEWS.md]
      Skip resolutions:  [count from skip-tracker.json]
      Experiment log:    [count from $OBSIDIAN_PROGRAM_FILE]
      Lessons entries:   [count H3 blocks in lessons file]

    Is this the same project?

    A  Yes - migrate everything to new path
    B  No - this is a different project
    C  Not sure - show me the files first
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  A (migrate): cp -R the old context contents into the new
     $PROJECT_CONTEXT. Rewrite any absolute path strings inside
     the copied files that reference the old PROJECT_ID. Delete
     the old folder only after the copy verifies (same file count,
     matching sizes). Display:
       Migration complete. [count] files moved.
       Old context removed.

  B (new project): proceed with fresh context creation. Leave the
     old folder in place; /projects will later list it as inactive.

  C (not sure): list files in the old context folder with sizes
     and modification dates, then ask the A/B question again.

After the orphan check resolves (or if no match found):

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

Feedback-loop paths (v3.1.0+):
  OBSIDIAN_LESSONS_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME-lessons.md"
  SKIP_TRACKER="$PROJECT_CONTEXT/skip-tracker.json"
  DECISIONS_FILE="$PROJECT_CONTEXT/DECISIONS.md"
  Full feedback-loop protocol: ~/solo-os/docs/FEEDBACK_LOOP.md

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


You are the BUILD workflow. Four steps. Two approvals. Output:
a running codebase with validated direction and a clear "build
this first" target.

ESTIMATED COST: ~12,000 - 18,000 tokens.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUILD
  Estimated: ~12,000 - 18,000 tokens
  Session so far: ~[count]
  Continue? Type yes to proceed or stop to cancel.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for confirmation.

Ask: What is your idea? (one-sentence description)

===========================================
STEP 1 OF 4 — VALIDATE AND PLAN
===========================================
Estimated: ~5,000 tokens

Read existing wiki intelligence first. Check if relevant
competitor research already exists. Check if a similar product
has been researched before. Surface that to avoid duplication.

Run market validation on the idea:
  Mine pain signals.
  Find competitors.
  Score the opportunity (PRISM-PV).

Display verdict:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VALIDATE - [idea]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Market signal: [STRONG / MODERATE / WEAK]
  Competitors:   [count found]
  Pain signal:   [HIGH / MEDIUM / LOW]

  Verdict: [BUILD / VALIDATE FIRST / DO NOT BUILD]
  Reason:  [plain English]

  APPROVAL: Continue or stop?
    Type yes to define strategy
    Type no to end here
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If yes, ask the five strategy questions, ONE at a time:

  Q1: What does this product do, and who is it for?
  Q2: Who is the one user above all others?
  Q3: What is the one thing you will be undeniably best at?
  Q4: What is your North Star metric?
  Q5: What are you NOT building?

Write answers to $STRATEGY_MD.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STEP 1 COMPLETE
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 2 OF 4 — STACK
===========================================
Estimated: ~1,000 tokens

Read $DEVELOPER_PROFILE.
Read project type from Step 1.

Recommend a stack with reasoning. Reference past projects by name.
Respect any "Never Again" tier in the profile. Estimate setup time
for THIS developer's experience.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RECOMMENDED STACK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Frontend:  [technology]
  Backend:   [technology]
  Database:  [technology]
  Auth:      [technology]
  Deploy:    [platform]

  Why for you specifically:
  [References your actual project history]

  Setup time with your experience:
  ~[X] hours

  APPROVAL: Confirm or adjust the stack.
    Type yes
    Type adjust [what to change]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 3 OF 4 — SCAFFOLD
===========================================
Estimated: ~2,000 tokens

Run the framework CLI with the confirmed stack. Show each action
as it runs:

  Creating project structure...  done
  Installing dependencies...     done
  Configuring database...        done
  Setting up auth...             done
  Configuring linting...         done
  Creating .env files...         done
  Initialising git...            done
  Pushing to GitHub...           done (if URL provided)

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STEP 3 COMPLETE
  App running at: localhost:3000
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 4 OF 4 — FIRST FEATURE
===========================================
Estimated: ~1,000 tokens

Use the validation research from Step 1 to identify the Critical
Painkiller — the one thing without which the product cannot be sold.

  Create the Obsidian product folder
  ($OBSIDIAN_PRODUCT_DIR/{Features,Decisions,Insights,Reviews}).
  Write competitor notes from research.
  Write a stack decision note.
  Write a project index.
  Write the Critical Painkiller as the first Feature note.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  READY TO BUILD
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project:        [name]
  Stack:          [summary]
  Runs at:        localhost:3000
  Build first:    [Critical Painkiller feature]
  Why this:       [one sentence of evidence from research]
  When done run:  /explore → SHIP
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:      ~[estimate]
  This session:   ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
