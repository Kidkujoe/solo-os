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
