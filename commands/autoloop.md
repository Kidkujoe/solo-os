---
name: autoloop
description: Autonomous improvement loop from Karpathy autoresearch pattern. Reads the product program file, identifies the lowest scoring measurable area, proposes an improvement, measures before and after, keeps or discards based on the metric, logs the experiment and repeats. Only acts on measurable metrics. Changes requiring real user data are logged as hypotheses not acted on autonomously.
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

Run the RESOLVER first.

Read the product program file:
`$OBSIDIAN_VAULT/program/$PROJECT_NAME.md`

If program file does not exist:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRODUCT PROGRAM FILE MISSING
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Run /autoloop-setup first.
  Takes about 5 minutes.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Then stop.

Read wiki pages listed in the program file as relevant sources. These
are compiled rules and knowledge the loop acts on.

===========================================
AUTOLOOP PHASE 1 - ESTABLISH BASELINE
===========================================

On first run, establish a baseline for every measurable metric.

Run these measurements:

**PERFORMANCE**
`lighthouse [app-url] --output=json`
Extract: performance score, LCP, CLS, INP.

**TEST SUITE**
Run the test command from `package.json`.
Extract: pass rate percentage.

**DESIGN CONSISTENCY**
`/design --score-only`
Extract: design score out of 10.

**SECURITY**
`/pillars --security --score-only`
Extract: security score.

**ACCESSIBILITY**
Lighthouse accessibility audit.
Extract: violation count.

Save baseline to `$OBSIDIAN_VAULT/program/$PROJECT_NAME-experiments.md`:

```
# Experiment Log — [project name]
Baseline established: [timestamp]

## Baseline
Performance: [score]
Tests: [pass rate]
Design: [score]
Security: [score]
Accessibility: [violations]
Primary metric: [value]
```

===========================================
AUTOLOOP PHASE 2 - IDENTIFY TARGET
===========================================

Compare all metrics against baseline and previous experiments.

Find the metric with:
- The lowest absolute score, AND
- The most realistic improvement potential based on wiki Rules pages

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AUTOLOOP — [project name]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Program file: [name]
  Wiki rules loaded: [count]

  CURRENT SCORES:
  Performance:   [score]
  Tests:         [pass rate]
  Design:        [score]
  Security:      [score]
  Accessibility: [violations]

  TARGET THIS LOOP:
  [Lowest scoring area]
  Current: [value]
  Realistic target: [value]
  Why this first: [reason]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
AUTOLOOP PHASE 3 - PROPOSE IMPROVEMENT
===========================================

Read the relevant wiki Rules pages for the target area.

Find the specific violation or gap causing the low score.

Check the program file:
- Is this file in the CAN change list?
- Is this within the allowed scope?

If not, find a different approach.

Apply the simplicity criterion from Karpathy autoresearch:
- Could **removing** something achieve the same improvement?
- Is there a simpler fix?
- A deletion that improves the metric is always preferred over an addition.

Propose:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PROPOSED IMPROVEMENT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Target metric: [metric]
  Current: [value]
  Expected after: [predicted value]

  What will change:
  [File and what changes]

  Why this improves the metric:
  [Specific reasoning]

  Wiki rule applied:
  [Rules page citation]

  Simplicity check:
  Adding complexity: [yes/no]
  Could removal achieve this: [yes/no]
  Verdict: PROCEED / SIMPLIFY FIRST

  Within allowed scope: [yes/no]

  Apply this change?
  Type yes / no / adjust
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for approval before changing any file.

===========================================
AUTOLOOP PHASE 4 - APPLY AND MEASURE
===========================================

After approval, apply the change. Commit to git:

```
git add [changed files]
git commit -m "autoloop: [description]"
```

Re-run the measurement immediately.

Display:

  MEASUREMENT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Before: [value]
  After:  [value]
  Change: [+/- value]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
AUTOLOOP PHASE 5 - KEEP OR DISCARD
===========================================

From Karpathy autoresearch pattern:

- **KEEP** if metric improved.
- **KEEP** if metric stayed the same but complexity was reduced.
  (A simplification win is always a keep.)
- **DISCARD** if metric got worse. Revert: `git revert HEAD`.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VERDICT: KEEP / DISCARD
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Reason: [plain English]
  Commit: [hash if kept]
  Reverted: [yes if discarded]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
AUTOLOOP PHASE 6 - LOG THE EXPERIMENT
===========================================

Append to experiment log at
`$OBSIDIAN_VAULT/program/$PROJECT_NAME-experiments.md`.

Every experiment is logged regardless of keep or discard. This is the
`results.tsv` equivalent from Karpathy autoresearch.

Format:

```
## [timestamp] | [description]
Target metric: [metric]
What was tried: [description]
Before: [value]
After: [value]
Verdict: KEEP / DISCARD
Reason: [plain English]
Commit: [hash or REVERTED]
Simplicity impact: ADDED / REMOVED / NEUTRAL / SIMPLIFICATION WIN
Wiki rule applied: [page name]
```

If the finding is worth preserving, write it back to the wiki as a
Synthesis page. This is the loop compounding in the knowledge base.

===========================================
AUTOLOOP PHASE 7 - HYPOTHESIS LOGGING
===========================================

If an improvement is found that cannot be measured in this session,
do not discard it. Log it as a hypothesis:

```
## [timestamp] | HYPOTHESIS: [description]
What this might improve: [metric]
Why it might work: [reasoning]
Cannot verify because: requires real user data over time
Verify with: /compass-retro after [timeframe] of real usage
Evidence from wiki: [relevant pages]
```

===========================================
AUTOLOOP PHASE 8 - LOOP OR STOP
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  LOOP COMPLETE
  Experiments this session: [count]
  Kept: [count]
  Discarded: [count]
  Hypotheses logged: [count]

  Metric movement:
  Primary metric: [start] -> [current]

  Continue to next improvement?
  Type yes / stop
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
