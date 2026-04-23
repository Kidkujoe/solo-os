---
name: workflow-brief
description: BRIEF workflow - start of day focus. One step, zero approvals. Reads project state silently and surfaces one clear recommendation. Estimated ~500-1,000 tokens.
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


You are the BRIEF workflow. One step. Zero approvals. Under one
minute. Output: one clear recommendation for what to focus on today.

ESTIMATED COST: ~500 - 1,000 tokens.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BRIEF
  Estimated: ~500 - 1,000 tokens
  Session so far: ~[count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 1 OF 1 - MORNING BRIEFING
===========================================

Read silently:

  $HEALTH_MD              — health score
  $PROJECT_CONTEXT/REVIEWS.md — open reviews / branches
  Run: git status --porcelain — uncommitted changes
  Wiki state (if OBSIDIAN_BRIDGE=on):
    $OBSIDIAN_VAULT/wiki/log.md       — last ingest
    Files in $OBSIDIAN_RAW not in log.md — unprocessed sources
  Experiment state (if OBSIDIAN_BRIDGE=on):
    $OBSIDIAN_PROGRAM_FILE — last EVOLVE run

  Feedback-loop state (v3.1.0, if OBSIDIAN_BRIDGE=on):
    $OBSIDIAN_LESSONS_FILE — last 30 days of entries
    $SKIP_TRACKER          — pending_question / deferred_monthly items
    EVOLVE experiment log  — KEEP entries aged >=14 days with no
                             follow-up recorded
    MARKET recommendations — priority-1 entries aged >=8 weeks with
                             no follow-up recorded

From these, determine:
  - Which outcome follow-ups are due today (EVOLVE 14d, MARKET 8w).
  - Which deferred items hit their monthly reminder this week.
  - Which findings have status=pending_question in skip-tracker.
  - Which lessons from the last 7 days are most relevant to today's
    focus.

Full protocol: ~/solo-os/docs/FEEDBACK_LOOP.md

Synthesise into one focused output. Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BRIEF - [day] [date]
  Project: [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Health:          [score]/10
  Open reviews:    [count]
  Uncommitted:     [count] change(s)
  Wiki sources:    [count] unprocessed
  Last EVOLVE:     [X] days ago

  NEEDS ATTENTION:
  [Only show items that need action. If nothing needs attention,
   write: Everything is clean.]

  [If any branch is READY TO MERGE]
  [branch] is ready to merge.

  [If any feature changed since its last audit]
  [feature] needs an audit.

  [If unprocessed wiki sources exist]
  [count] source(s) waiting in raw/

  [If a hypothesis is logged for retro]
  [count] hypothesis(es) ready for MARKET retro.

  [If any EVOLVE KEEP entries aged >=14d have no follow-up OR any
   MARKET priority-1 entries aged >=8w have no follow-up]
  FOLLOW-UPS NEEDED:
  [count] experiments need outcome feedback. Takes 30 seconds.
  Type f to answer now or skip.

  [If skip-tracker has deferred_monthly items due this week]
  DEFERRED ITEMS DUE:
  [rule] - deferred [X] days ago
  Type d to review or skip.

  [If skip-tracker has status=pending_question entries]
  SKIP PATTERNS DETECTED:
  [count] findings skipped 3+ times
  Type s to resolve or skip.

  [If relevant lessons exist from the last 7 days]
  RECENT LESSONS:
  [most relevant lesson in one line]
  [link: $OBSIDIAN_LESSONS_FILE]

  FOCUS TODAY:
  [Single clear recommendation based on everything read above.
  ONE thing. Not a list.]

  Type /explore to start working on it.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The session ends here. The user runs /explore again to act on the
recommendation.

===========================================
INTERACTIVE FOLLOW-UP HANDLERS (v3.1.0+)
===========================================

If the user types f / d / s in response to the briefing, drive the
corresponding protocol defined in ~/solo-os/docs/FEEDBACK_LOOP.md:

  f - Outcome follow-ups
      For each due EVOLVE KEEP: show the 4-option EVOLVE FOLLOW-UP
      block. For each due MARKET priority-1: show the 6-option
      MARKET FOLLOW-UP block. Wait for one keystroke per question.
      Write results to $OBSIDIAN_LESSONS_FILE under
      "## Outcome follow-ups" and apply confidence updates to the
      relevant wiki page frontmatter per the protocol.

  d - Deferred items
      For each deferred_monthly item due this week, ask:
      "Still want to fix this? yes / no". On yes: add to today's
      focus and set skip-tracker status=pending. On no: roll the
      defer date forward by 30 days.

  s - Skip patterns
      For each pending_question skip, show the 5-option skip
      question from the protocol. Apply the answer's resolution
      action: wiki frontmatter update, DECISIONS_FILE append,
      lessons file append, or skip_count reset per the protocol.

After any interactive block, write a one-line summary to the
lessons file and return the user to the BRIEF display.
