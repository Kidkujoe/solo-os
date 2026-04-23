---
name: workflow-evolve
description: EVOLVE workflow - autonomous improvement loop. Two steps, one approval. Auto-setup if program file is empty. Simplicity criterion applied to every change. Keep or discard with git commits. Estimated ~3,000-5,000 per loop.
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


You are the EVOLVE workflow. Two steps. One approval. Output:
measured improvements committed (or reverted), hypotheses logged,
results written back to the wiki.

ESTIMATED COST: ~3,000 - 5,000 tokens per experiment loop.

===========================================
PROGRAM FILE CHECK (auto-setup if missing)
===========================================

Read $OBSIDIAN_PROGRAM_FILE
(= $OBSIDIAN_VAULT/program/[PROJECT_NAME].md).

IF the program file is empty or missing:
  Run inline setup BEFORE starting. Do not stop and ask the user
  to run a separate command.

  Display:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EVOLVE SETUP
    First time running EVOLVE on [PROJECT_NAME].
    Need 4 quick answers.
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Ask one at a time:

    Q1: What is the single metric that determines if a change
        is an improvement?
          1  Lighthouse performance score
          2  Test pass rate
          3  Design consistency score
          4  Accessibility violation count
          5  Security pillar score
          6  Composite of all of the above

    Q2: What files can EVOLVE change without asking you?
        (e.g. CSS files, copy files, image files, meta tags)

    Q3: What must EVOLVE never touch without your explicit
        approval?
        (e.g. auth, payment, database, environment variables)

    Q4: What does "simpler" mean for this product?
        (e.g. fewer UI elements is always better — users want
        to complete tasks quickly)

  Write the answers to $OBSIDIAN_PROGRAM_FILE.
  Confirm: "Saved program file." Continue to STEP 1.

===========================================
STEP 1 OF 2 — SET SCOPE
===========================================
Estimated: ~500 tokens

Read $OBSIDIAN_PROGRAM_FILE.
Read the wiki Rules pages listed in the program file.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EVOLVE - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Primary metric: [from program file]
  Can change:     [file types listed]
  Cannot touch:   [protected files]
  Wiki rules:     [count] loaded

  Current scores:
    Performance:    [value]
    Tests:          [pass rate]
    Design:         [score]
    Security:       [score]
    Accessibility:  [violations]

  Target this session:
    [Lowest-scoring measurable area]
    Current:           [value]
    Realistic target:  [value]

  Last run:  [date or never]
  Experiments to date: [count]

  Estimated per experiment: ~3,000 - 5,000 tokens
  Session so far:           ~[count]

  APPROVAL: Type yes to start
            Type adjust [what] to change scope
            Type stop to cancel
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 2 OF 2 — LOOP
===========================================
Estimated: ~3,000 per experiment

LOOP FOREVER until the user stops or no improvements remain:

  1. Find a specific violation causing the low score in the
     target area. Check against wiki Rules pages. Confirm it is
     within allowed scope.

  2. Apply the simplicity criterion FIRST:
       Could removing something achieve the same improvement?
       Simpler is always preferred.

  3. Propose the change:
       What changes, why, which rule, expected improvement,
       complexity impact.
       Show before applying.
       Auto-approve if within normal scope and improvement is clear.
       For any change OUTSIDE normal scope, ask explicitly.

  4. Apply and measure:
       Run: git commit (automatic).
       Measure metric BEFORE and AFTER.

  5. Keep or discard:
       KEEP    if metric improved.
       KEEP    if metric same but solution is simpler.
       DISCARD if metric got worse.
                Run: git revert (automatic).

  6. Log to $OBSIDIAN_PROGRAM_FILE experiment log:
       timestamp | what tried | before | after | verdict
       | simplicity impact | commit hash

  7. If improvement cannot be measured in-session:
       Log as a HYPOTHESIS, not an experiment.
       Tag for MARKET retro after real usage data exists.
       Do NOT apply autonomously.

  8. After each loop, display:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    LOOP [count] COMPLETE
    Tried:    [what was changed]
    Verdict:  KEEP / DISCARD
    Before:   [metric value]
    After:    [metric value]
    Reason:   [plain English]
    Commit:   [hash if kept / REVERTED if discarded]

    Session: [kept] kept, [discarded] discarded,
             [hypotheses] hypotheses

    Primary metric: [start] → [current]

    Continue?
      Type yes for next loop
      Type stop to end the session
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    TOKENS
    This loop:    ~[estimate]
    This session: ~[running total]
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

When the user stops the session:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EVOLVE COMPLETE
  Experiments run:    [count]
  Kept:               [count]
  Discarded:          [count]
  Hypotheses logged:  [count]

  Metric movement:
  [metric]: [start] → [current]

  Results written back to wiki as Synthesis pages.
  Experiment log updated.

  TOKENS
  This session: ~[total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
