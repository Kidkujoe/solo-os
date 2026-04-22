---
name: env-diff
description: Compares environment variables across local and production environments. Flags missing variables, dev-only flags in production, required variables not defined anywhere. Never exposes values - names only.
allowed-tools: Bash
---



===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run `pwd` to get the absolute project path.
Derive PROJECT_ID = [basename]-[6char hash of full path] using md5sum
(fall back to shasum if unavailable).
Set PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is NOT a project directory (is home, is ~/.claude,
no code files present), display PROJECT NOT DETECTED warning and stop.
Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS if missing:
mkdir -p $PROJECT_CONTEXT/atlas $PROJECT_CONTEXT/screenshots $PROJECT_CONTEXT/reports

STEP R3 - ALL PATHS (use these variables, never hardcode):
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
TEST_REPORT       = $PROJECT_CONTEXT/reports/test-report.html
COPY_REPORT       = $PROJECT_CONTEXT/reports/copy-report.html
COMPASS_REPORT    = $PROJECT_CONTEXT/reports/compass-report.html
EMPATHY_REPORT    = $PROJECT_CONTEXT/reports/empathy-report.html
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

Approved global resources (shared across all projects):
REPORT_TEMPLATE   = $REPORT_TEMPLATE
GLOBAL_ACCOUNTS   = ~/.claude/context/test-accounts-global.md

STEP R4 - VERIFY ISOLATION:
Every path used must start with $PROJECT_CONTEXT or be one of the two
approved globals. Any other ~/.claude/context/ path is a violation.

STEP R5 - DISPLAY CONFIRMATION (one line):
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CONTAMINATION CHECK:
If $SESSION_FILE exists, check its first line for `# Project: [id]`.
If stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning with options: archive + start fresh / show contents / stop.
Wait for user response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

TEST-ACCOUNTS USAGE:
When reading accounts, read $GLOBAL_ACCOUNTS and filter to the section
matching PROJECT_ID. Never read another project's section.
When writing accounts, update the $PROJECT_ID section only.

END OF RESOLVER — command-specific logic follows
===========================================

CRITICAL RULE: Display variable NAMES only. Never display, log or output
any variable VALUES. If a value is accidentally visible in output
immediately warn the user and redact.

PHASE 1 - READ ENV FILES:
Find all env files in project root:
.env, .env.local, .env.development, .env.production, .env.staging,
.env.example, .env.template.

Extract variable NAMES only from each. Never read or display values.

.env.example and .env.template define REQUIRED variables.

PHASE 2 - READ CODE REFERENCES:
Scan codebase for env var references:
- process.env.[NAME]        (JavaScript/TypeScript)
- os.environ[[NAME]]        (Python)
- ENV[[NAME]]               (Ruby)
- getenv([NAME])            (PHP/C)
- os.Getenv([NAME])         (Go)

Build complete list of every env var the code expects.

PHASE 3 - DETECT PRODUCTION ENV:
If deployment platform is configured try to fetch production vars
(names only, never values):
- Vercel: `vercel env ls`
- Netlify: `netlify env:list --plain`
- Fly.io: `flyctl secrets list`
- Others: note that production env cannot be read automatically; ask
  user to paste list of production variable names.

PHASE 4 - COMPARISON AND DISPLAY:

  ENVIRONMENT VARIABLE AUDIT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Variables in code: [count]
  Defined locally: [count]
  Defined in production: [count or UNKNOWN]

  MISSING IN PRODUCTION ([count]):
  [VAR_NAME] - required by [file]
  This will cause [feature] to fail in production.

  MISSING LOCALLY ([count]):
  [VAR_NAME] - defined in production
  May cause issues in development.

  IN CODE BUT NOT DEFINED ANYWHERE ([count]):
  [VAR_NAME] - referenced in [file]
  Neither local nor production has this.
  Will cause runtime error.

  DEV-ONLY VARIABLES IN PRODUCTION ([count]):
  [VAR_NAME] - name suggests dev usage
  Patterns flagged: DEBUG_, DEV_, LOCAL_, TEST_
  Verify these should be in production.

  ALL PRESENT AND CORRECT: [count] variables.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For each missing-in-production variable also show:
- Which code file(s) reference it
- What feature will break without it

Never show values. Only names.
