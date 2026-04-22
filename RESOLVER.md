# RESOLVER — Canonical Path Resolution for Visual-Test-Pro

Every command in this plugin MUST include the resolver block below
at the very start, before any other logic runs. This ensures all
project-specific data is isolated per project and never leaks
between projects.

## THE RESOLVER BLOCK

Copy this block verbatim into the top of every command file,
immediately after the frontmatter, before any other instructions.

```
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
```

## APPROVED GLOBAL PATHS

Only these paths outside $PROJECT_CONTEXT are permitted:

- `~/.claude/context/report-template.html` — shared template
- `~/.claude/context/test-accounts-global.md` — keyed multi-project credentials
- `~/.claude/context/projects/` — the parent of all project folders
- `~/.claude/commands/` — the commands themselves

Any other `~/.claude/context/*` path is a violation.

## TEST-ACCOUNTS-GLOBAL.MD STRUCTURE

```markdown
# Global Test Accounts
# Each project section is keyed by project identifier

## [project-id-1]
Project: [name]
Path: [full path]
Email: [email]
Auth type: [type]
Password: [password or none]
Magic link catcher: [url or none]
Magic link bypass: [variable or none]
Role: [role]
Date added: [date]
Notes: [notes]

## [project-id-2]
[same structure]
```

Commands reading/writing accounts MUST filter by PROJECT_ID.
Never read or modify another project's section.

## ENFORCEMENT

Run `/vtpaudit` to verify all commands pass isolation checks AND the
resolver block matches this file.
Run `/projects` to see all projects with context data.

## BUILD SYSTEM (v2.2.0+)

As of v2.2.0, command files can be regenerated from a single source of
truth via `scripts/build-commands.sh`. This script:
1. Reads the resolver block from this file (the fenced code block above)
2. Reads each command body from `commands/bodies/[name].md`
3. Combines them into `commands/[name].md` and also copies to
   `~/.claude/commands/[name].md`

To update the resolver across all commands:
1. Edit the resolver block above in RESOLVER.md
2. Run `bash scripts/build-commands.sh`
3. All 32+ commands regenerate with the new resolver
4. Commit and push

If `commands/bodies/` doesn't exist yet, commands still work the old way
(resolver embedded manually). The build system is an optional upgrade.

`/vtpaudit` checks whether installed commands have the current resolver
and flags any that are out of date.

## KNOWLEDGE_BRIDGE (v2.3.0+)

The Knowledge Bridge connects Visual-Test-Pro commands to an Obsidian
Second Brain vault so findings accumulate over time and past knowledge
informs new runs.

Every command runs STEP R8 (above) to initialize bridge variables. If
the vault is missing the bridge is disabled for that run and the command
continues normally. If the vault exists commands may call the read and
write functions defined here at the hooks specified in their own files.

### Vault paths

Default vault location: `~/Documents/SecondBrain/`. Commands read the
active path from `STRATEGY.md`:

```
Obsidian vault: ~/Documents/SecondBrain/
```

Override by editing the STRATEGY.md line for a project.

Inside the vault:
- `Products/[PROJECT_NAME]/` — per-product notes, auto-created on first run
  - `Features/` — feature notes
  - `Decisions/` — decision notes
  - `Insights/` — insights and user insights (time-stamped)
  - `Reviews/` — review-cycle summaries
- `Research/Competitors/` — competitor intelligence (merged across runs)
- `Research/Customers/` — customer insights
- `Patterns/` — recurring findings promoted from ≥3 instances
- `Inbox/` — user-written thoughts read on next run, then moved
- `Templates/` — note templates used when creating new notes

### Write functions

#### write_decision_note
Called when: user confirms an architectural or product decision during a
command run.

Arguments: title, context, decision, reasoning, consequences.

Action: check `$OBSIDIAN_PRODUCT_DIR/Decisions/[title].md`. If it exists
update with new information, keeping prior content. Otherwise create
from `Templates/Decision.md` filled with the arguments.

After writing display:
```
  Note saved to Obsidian:
  Products/[product]/Decisions/[title].md
```

#### write_pattern_note
Called when: the same type of finding has appeared 3 or more times across
review cycles.

Arguments: title, instances (list with dates), root_cause, prevention.

Action: check `$OBSIDIAN_PATTERNS/[title].md`. If it exists increment
`times_seen` and append the new instance to the Evidence section. If not
create from `Templates/Pattern.md` with `times_seen: 3` (threshold met).

After writing display:
```
  Pattern note saved to Obsidian:
  Patterns/[title].md
  This pattern has now appeared [count] times.
```

#### write_competitor_note
Called when: /compass or /copyai researches a competitor.

Arguments: name, positioning, weaknesses (with evidence counts),
migration_triggers, strengths, opportunity.

Action: check `$OBSIDIAN_RESEARCH/Competitors/[name].md`. If it exists
update `last_updated` and merge new findings with existing content.
Never overwrite prior evidence — append new evidence alongside old.
Update `signal_strength` if changed. If the file does not exist create
from `Templates/Competitor.md`.

#### write_insight_note
Called when: a significant insight is produced by /compass, /copyai,
/empathy or /design.

Arguments: title, source (command name), confidence, evidence,
implication, action.

Action: always create a new note at
`$OBSIDIAN_PRODUCT_DIR/Insights/[YYYY-MM-DD]-[title].md` from
`Templates/Insight.md`. Insights are time-stamped events not updated
records.

#### write_feature_note
Called when: /compass scores a feature, or /atlas-feature completes a
feature build.

Arguments: name, status (idea/planned/building/built/deprecated),
prism_score, pv_classification, what_it_does, why_built, user_groups.

Action: check `$OBSIDIAN_PRODUCT_DIR/Features/[name].md`. If it exists
update `status` and append build notes. If not create from
`Templates/Feature.md`.

#### write_user_insight_note
Called when: /empathy ghost-user test produces a significant finding, or
/copyai finds a strong customer-language pattern.

Arguments: title, source (platform + date), user_group, what_users_said
(exact quotes), meaning, action.

Action: always create a new note at
`$OBSIDIAN_PRODUCT_DIR/Insights/UserInsight-[YYYY-MM-DD]-[title].md`
from `Templates/UserInsight.md`.

#### write_review_note
Called when: /review-cycle completes.

Arguments: feature, branch, date, quality_score, findings (by severity),
merge_commit.

Action: create `$OBSIDIAN_PRODUCT_DIR/Reviews/[YYYY-MM-DD]-[feature].md`
with:

```
# Review: [feature]
Date: [date]
Branch: [branch]
Quality: [score]/100
Findings: Critical [n] High [n] Medium [n]
Merged: [yes - commit hash / no]
Notes: [any significant findings]
```

### Read functions

#### read_product_context
Called at the start of: /atlas, /atlas-quick, /atlas-feature.

Action: list files in `$OBSIDIAN_PRODUCT_DIR/` modified in the past 30
days. For each file extract the file name, the note type (from frontmatter
`tags:`), the first meaningful paragraph, and any `[[wiki-links]]`.

Build a summary of recent Obsidian activity for this product. If any
files exist display:

```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  OBSIDIAN CONTEXT LOADED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Notes found: [count]
  Recent decisions: [count]
  Recent insights: [count]
  Active patterns: [count]

  Your recent notes will inform this run.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If any notes are present in `$OBSIDIAN_INBOX/`:

```
  INBOX NOTES FOUND
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  You have [count] unprocessed notes in your Obsidian Inbox.

  Reading them now to inform this run:
  [list note titles]

  These will be moved to the correct folder after this run.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Read the inbox notes, incorporate their content into command output,
and after the command finishes move each inbox note to the appropriate
product folder based on its frontmatter `tags:` (decision → Decisions/,
insight → Insights/, feature → Features/, user-insight → Insights/,
pattern → top-level Patterns/).

#### read_competitor_context
Called at the start of: /compass, /copyai, /copyai-research.

Action: read all files in `$OBSIDIAN_RESEARCH/Competitors/`. Extract
name, weaknesses, opportunities from each. Before researching a specific
competitor check if a note already exists. If yes display:

```
  EXISTING COMPETITOR INTELLIGENCE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [Competitor name]
  Last researched: [date from note]

  Known weaknesses:
  [list from note]

  Known opportunities:
  [list from note]

  Updating with new research.
  Only researching what may have changed since [date].
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### read_customer_context
Called at the start of: /copyai, /empathy.

Action: read all UserInsight notes in
`$OBSIDIAN_PRODUCT_DIR/Insights/`. Extract patterns in customer
language. Record which of the six user groups have insights and which
have none (gaps to fill). Incorporate existing insights into command
output before doing new research.

Display:

```
  EXISTING CUSTOMER INSIGHTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  User insights in Obsidian: [count]

  Groups with insights:
  [list groups]

  Groups with no insights yet:
  [list gaps]

  These insights will inform the audit without re-researching
  what we already know.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### read_pattern_context
Called at the start of: /review-cycle, /test-deep, /atlas-feature.

Action: read all files in `$OBSIDIAN_PATTERNS/`. For each extract name,
`times_seen`, prevention. Before running checks display:

```
  KNOWN PATTERNS TO WATCH FOR
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [count] recurring patterns documented.

  Actively watching for:
  [List pattern names]

  If found these will be flagged as recurring not just new findings.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Command hooks

Each affected command file contains a "KNOWLEDGE BRIDGE HOOKS" block
immediately after its END OF RESOLVER line listing the exact functions
to call and at which points. Summary:

- `/compass` — read_competitor_context (start); write_competitor_note
  (per competitor); write_insight_note (per insight); write_feature_note
  (per feature scored).
- `/copyai` and `/copyai-research` — read_competitor_context and
  read_customer_context (start); write_insight_note (per strong
  pattern); write_decision_note (copy direction, /copyai only).
- `/empathy` — read_customer_context (start); write_user_insight_note
  (per significant ghost-user friction); write_insight_note (emotional
  arc).
- `/atlas`, `/atlas-quick` — read_product_context (start);
  write_feature_note automatically after the codebase scan for every
  detected feature (status: detected); write_insight_note
  automatically after the health assessment for every significant
  finding (≤5/10, ≥8/10, Things-to-investigate, Known issues,
  operational signals); write_decision_note if user confirms a
  strategic decision during "What to do next".
- `/atlas-feature` — read_pattern_context (start); write_feature_note
  (status: built) after review; write_pattern_note if a new recurring
  pattern detected.
- `/review-cycle` — read_pattern_context (start); write_review_note
  (on completion); write_pattern_note if recurring finding detected.
- `/design` — write_decision_note for any design decisions confirmed
  during the audit.

Commands not listed still benefit from STEP R8 (vault detection) but do
not call bridge functions by default.
