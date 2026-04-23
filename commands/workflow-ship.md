---
name: workflow-ship
description: SHIP workflow - context-aware audit and ship. Detects unaudited features, drifted features, and offers full product audit. Three modes. One approval to merge and deploy. Estimated cost varies by mode.
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


You are the SHIP workflow. Three modes:
  Mode 1 — Feature unaudited      (3 steps, ~3,000-5,000 tokens)
  Mode 2 — Feature drift only     (2 steps, ~1,000-2,000 tokens)
  Mode 3 — Full product audit     (3 steps, ~30,000-50,000 tokens)

===========================================
CONTEXT READ
===========================================

Before showing options, read silently:

UNAUDITED FEATURES
  Cross-reference git log with $PROJECT_CONTEXT/REVIEWS.md.
  Find every feature changed since its last audit OR never audited.
  For each: feature name, days since change, last-audit date.

DRIFT DETECTION
  For features that WERE audited, check git log since the audit
  date. If files changed since last audit, flag as DRIFTED with
  count of changed files.

FULL AUDIT STATUS
  Read $HEALTH_MD for "Last full audit:" timestamp. If never or
  >30 days, flag it.

===========================================
OPTION DISPLAY
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SHIP - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [For each unaudited feature, label A1, A2, A3...]
  A1  [feature-name]
      Changed [X] days ago
      Not yet audited
      Estimated: ~3,000 - 5,000 tokens

  [For each drifted feature, label B1, B2...]
  B1  [feature-name]
      Audited [X] days ago
      [count] files changed since
      Drift check only
      Estimated: ~1,000 - 2,000 tokens

  C   Full product audit
      Last run: [date or never]
      Runs every audit across the entire product.
      Recommended before demos, launches, significant moments.
      Estimated: ~30,000 - 50,000 tokens

  D   Something else (ask the user what)

  Session tokens used: ~[count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for the user to pick a letter.
  A* → run MODE 1 with the named feature
  B* → run MODE 2 with the named feature
  C  → run MODE 3
  D  → ask "What would you like to do?" and route accordingly

===========================================
MODE 1 — FEATURE UNAUDITED (3 steps, 1 approval)
===========================================

  ━━━ STEP 1 OF 3: GATE CHECK ━━━
  Estimated: ~1,500 tokens

Running gate check on [feature].

REGRESSION
  Read dependency map from $DEPENDENCIES_MD.
  Check files this feature touches.
  Check what other features depend on these files.
  Flag any broken dependencies.

SCOPED VISUAL CHECK
  Does this feature look right?
  Does it match the design system?
  Read relevant wiki Rules pages (Rules-*.md).
  For each rule read frontmatter
  confidence_for_projects.[PROJECT_NAME]. Enforce per level:
    HIGH            → VIOLATION (blocking).
    MEDIUM          → SUGGESTION (non-blocking, noted in report).
    LOW             → shown only in Mode 3 full audit, prefixed
                      "Low priority for [PROJECT_NAME]:".
    DISPUTED        → silent unless explicitly requested.
    NOT_APPLICABLE  → silent.
  Flag violations of YOUR rules — not generic best practice.

SMART SECURITY
  Read the changed files list.
  IF auth/, payment/, database/, api/, or environment files
     are in the changed set:
       Run a security check.
       Flag hardcoded secrets, input-validation gaps, auth flow
       issues.
  ELSE:
       Skip. Display: "Security check skipped — no sensitive
       files changed."

Display all findings.
Verdict: GO or NO-GO.

  If NO-GO:
    List what needs fixing. Stop here. The user fixes and
    restarts SHIP.

  If GO: continue to step 2.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ━━━ STEP 2 OF 3: CODE REVIEW ━━━
  Estimated: ~2,000 tokens

Run the CodeRabbit pipeline.

PRE-REVIEW GATES:
  Secrets scan on changed files.
  Build check.
  Test suite run.
  Lint check.

  If any gate fails: show what failed, offer to fix before
  continuing. After fixing, re-run gates.

  If all gates pass:
    Run CodeRabbit review on the changed files.
    Show findings grouped by severity.
    Apply fixes with the user's approval.
    Show what was changed.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ━━━ STEP 3 OF 3: SHIP ━━━
  Estimated: ~500 tokens

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  READY TO SHIP
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Feature:     [name]
  Gate check:  PASSED
  Code review: PASSED
  Branch:      [branch-name]

  This will:
    1. Merge [branch] to main
    2. Deploy to production
    3. Run smoke test
    4. Update Atlas brain
    5. Log to experiment record

  APPROVAL: Type yes to ship
            Type no to stop here
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If yes:
  Merge to main.
  Deploy to production.
  Smoke test runs automatically.

  If smoke test passes:
    Atlas brain updated automatically.
    Experiment log updated.
    Wiki updated if relevant.

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    SHIPPED
    [feature] is live.
    Commit: [hash]
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    TOKENS
    This step:    ~[estimate]
    This session: ~[running total]
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  If smoke test fails:
    Rollback automatically. Show what failed. Offer /rollback
    options.

===========================================
MODE 2 — FEATURE DRIFT ONLY (2 steps, 1 approval)
===========================================

  ━━━ STEP 1 OF 2: DRIFT CHECK ━━━
  Estimated: ~800 tokens

Only check files changed since the last audit. Not the full feature.

Read the previous audit findings from $PROJECT_CONTEXT/REVIEWS.md
as baseline. Read git diff since the audit date. Audit only the
changed files.

  Regression on changed files only.
  Design check on changed files only.
  Security check ONLY if sensitive files in the changed set.

Display:
  Files checked: [count] of [total in feature]
  What changed since last audit.
  What the drift check found.
  What is still clean from the last audit.
  Verdict: GO or NO-GO.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ━━━ STEP 2 OF 2: SHIP ━━━

Same approval and ship flow as MODE 1 STEP 3. One approval. Merge,
deploy, smoke test, brain update.

===========================================
MODE 3 — FULL PRODUCT AUDIT (3 steps, 1 approval)
===========================================

Show this warning before running ANY audit:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FULL PRODUCT AUDIT
  Estimated: ~30,000 - 50,000 tokens
  Time:      45 to 60 minutes

  This runs:
    Visual test across all pages
    Security and reliability pillars
    Performance and Lighthouse
    Accessibility audit
    SEO and schema check
    Empathy across 6 user groups
    Copy consistency
    Design system check
    Krug rules across the entire product

  Run before: demos, launches, press mentions, investor
  meetings, significant public moments.

  Session tokens so far: ~[count]

  Choose depth:
    A  QUICK — three highest-impact audits
       (security, empathy, performance)
       Estimated: ~15,000 - 20,000 tokens

    B  FULL — everything listed above
       Estimated: ~30,000 - 50,000 tokens

  Type A or B to continue
  Type stop to go back
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for selection.

  ━━━ STEP 1 OF 3: RUN ALL AUDITS ━━━

Run the selected audits sequentially. Show one progress line per
audit, no sub-steps. Do not pause between audits.

  Running visual test...      done
  Running security audit...   done
  Running performance...      done
  Running accessibility...    done
  Running SEO audit...        done
  Running empathy audit...    done
  Running copy audit...       done
  Running design audit...     done

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ━━━ STEP 2 OF 3: FINDINGS ━━━

Compile all findings into one report. Group by severity.

  CRITICAL (must fix before shipping):
  [list — what / where / which audit / which wiki rule / how to fix]

  HIGH (fix soon):
  [list]

  MEDIUM (address this sprint):
  [list]

  LOW (backlog):
  [list]

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ━━━ STEP 3 OF 3: GO / NO-GO ━━━

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VERDICT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Critical issues: [count]
  High issues:     [count]
  Medium issues:   [count]

  [If critical issues exist:]
  NOT READY
  Fix critical issues before this significant moment.

  [If no critical issues:]
  READY
  Product is solid for this moment.

  Your call:
    Type fix     to address issues now
    Type proceed to continue anyway
    Type report  to generate HTML report
    Type stop    to end here
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After approval:
  Generate HTML report from $REPORT_TEMPLATE.
  Update $HEALTH_MD with audit date.
  Log to wiki automatically (if OBSIDIAN_BRIDGE=on).

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
SKIP DETECTION (v3.1.0+)
===========================================

Every finding surfaced by SHIP (gate check, full audit, CodeRabbit
result, etc.) is subject to skip tracking. Track in $SKIP_TRACKER.

When a finding appears:
  - If the user fixes it, remove any matching skip entry.
  - If the user moves past without fixing, increment skip_count on
    the matching rule_id (create entry if none exists).
  - On the third consecutive skip, set status=pending_question.
    BRIEF will surface the 5-option question on the next run, OR
    SHIP may ask inline if the user is still in-session.

Protocol, resolutions (A-E), and wiki confidence adjustments are
defined in ~/solo-os/docs/FEEDBACK_LOOP.md. Follow it exactly.

When writing skip-tracker entries, always include:
  rule_id, rule_name, source (wiki page), skip_count,
  last_skipped (ISO timestamp), status, resolution.
