---
name: decisions
description: Review and correct all recorded decisions for this project. Covers skip resolutions, intentional design choices, deferred items and disputed rules. Change any decision that was recorded incorrectly or that is no longer valid.
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


You are the /decisions command. It lets the developer review and
correct every decision recorded by the v3.1.0 feedback loop so no
recorded decision is ever permanently wrong.

Run the RESOLVER first to set $PROJECT_CONTEXT, $SKIP_TRACKER,
$DECISIONS_FILE, $OBSIDIAN_LESSONS_FILE, $OBSIDIAN_WIKI.

Read:
  $SKIP_TRACKER                — skips with resolution/status
  $DECISIONS_FILE              — intentional design choices
  $OBSIDIAN_LESSONS_FILE       — deferred, not-applicable, disputed
  $OBSIDIAN_WIKI/Rules-*.md    — confidence_for_projects frontmatter

Full protocol reference: ~/solo-os/docs/FEEDBACK_LOOP.md

===========================================
PHASE 1 — BUILD REVIEW LIST
===========================================

Compile every recorded decision into four groups:

  NOT APPLICABLE: skip-tracker entries with resolution =
    "not_applicable", plus wiki pages where
    confidence_for_projects.[PROJECT_NAME] = NOT_APPLICABLE.

  INTENTIONAL CHOICES: every H2 entry in $DECISIONS_FILE.

  DEFERRED: skip-tracker entries with status = "deferred_monthly".

  DISPUTED: wiki pages where
    confidence_for_projects.[PROJECT_NAME] ∈ {MEDIUM, LOW, DISPUTED}
    with a non-zero disputes count.

For each decision record: rule_name or decision_description, source
(wiki page or file), date recorded, current status, and where it
lives so it can be updated.

===========================================
PHASE 2 — DISPLAY
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  DECISIONS - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [count] recorded decisions

  NOT APPLICABLE ([count])
  Rules marked as not relevant:

  [n]  [rule name]
       Marked: [date]
       Source: [wiki page]

  INTENTIONAL CHOICES ([count])
  Design decisions never to flag again:

  [n]  [decision description]
       Recorded: [date]

  DEFERRED ([count])
  Items on monthly reminder:

  [n]  [rule name]
       Deferred: [date]
       Last surfaced: [date]

  DISPUTED ([count])
  Rules with reduced confidence:

  [n]  [rule name]
       Current confidence: [level]
       Disputed: [count] times

  Type a number to review that decision.
  Type all to walk every decision in sequence.
  Type done to exit.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
PHASE 3 — REVIEW ONE DECISION
===========================================

When the user types a number, show the full context:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  REVIEWING DECISION [n]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Rule / decision: [name]
  Source: [wiki page or DECISIONS.md anchor]
  Current status: [NOT APPLICABLE | INTENTIONAL | DEFERRED | DISPUTED]
  Recorded: [date]

  The rule says:
  [full rule statement from wiki page — truncate to ~5 lines]

  Why it was marked this way:
  [reason recorded, if any]

  What would you like to do?

  A  Keep as [current status]
     Correct decision. Leave it.

  B  Change to MEDIUM confidence
     Maybe it applies sometimes.
     Show as suggestion not violation.

  C  Restore to HIGH confidence
     Wrong decision originally. Enforce this rule again.

  D  Change to INTENTIONAL CHOICE
     It applies but we deliberately do it differently. Never flag.

  E  Change to DEFERRED
     Want to address eventually. Monthly reminder only.

  Type A B C D or E.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Apply the answer to ALL relevant stores so nothing drifts:

  A (keep): no change. Move on.

  B (MEDIUM): update the wiki page
     confidence_for_projects.[PROJECT_NAME] = MEDIUM. Remove any
     not_applicable_for entry. Set skip-tracker resolution to
     "dispute" with disputes = max(1, current). Append to lessons
     under "## Confidence updates applied".

  C (HIGH): update the wiki page
     confidence_for_projects.[PROJECT_NAME] = HIGH. Remove any
     not_applicable_for entry. Clear disputes count. Remove the
     skip-tracker entry (or reset skip_count to 0 with
     status=active). Append to lessons.

  D (INTENTIONAL): append to $DECISIONS_FILE with today's date and
     a one-line rationale. Remove the skip-tracker entry. Set wiki
     confidence_for_projects.[PROJECT_NAME] = NOT_APPLICABLE with
     reason "intentional design choice confirmed via /decisions on
     [date]". Append to lessons.

  E (DEFERRED): set skip-tracker status = deferred_monthly, last
     surfaced = today. Leave wiki confidence untouched. Append to
     lessons.

After every change, write a one-line note to
$OBSIDIAN_LESSONS_FILE under "## Confidence updates applied":

  ### [YYYY-MM-DD] - Decision reviewed via /decisions
  Rule: [name]
  Changed from [old status] to [new status].

===========================================
PHASE 4 — BULK REVIEW
===========================================

If the user types `all`, walk every decision in sequence.
Show each with Phase 3's full context. Show progress:

  Decision 3 of 12.
  [rule name]
  [options A-E]

Tally throughout. At the end:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  REVIEW COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Reviewed:            [count]
  Unchanged:           [count]
  Updated:             [count]
  Restored to HIGH:    [count]

  All changes saved to:
    $SKIP_TRACKER
    $DECISIONS_FILE
    Wiki confidence frontmatter
    $OBSIDIAN_LESSONS_FILE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
NOTES
===========================================

- Never prompt for every decision on a fresh run; only show the
  A-E question after the user selects a number or types `all`.
- If a store is missing (no lessons file, no skip-tracker), skip
  that group silently. Do not error.
- For the wiki frontmatter edits, preserve any other fields
  present (last_reviewed, not_applicable_for for other projects,
  etc.). Only touch this project's entries.
