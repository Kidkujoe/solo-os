---
name: migrate
description: Safe database migration management. Detects migration tool, reviews pending migrations for safety risks, warns about destructive operations.
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

PHASE 1 - DETECT MIGRATION TOOL:
- DRIZZLE: drizzle.config.ts or .js, drizzle-orm in package.json
  Command: `npx drizzle-kit generate` and `npx drizzle-kit migrate`
- PRISMA: prisma/schema.prisma, @prisma/client in package.json
  Command: `npx prisma migrate dev`
- SEQUELIZE: migrations/ with sequelize pattern
  Command: `npx sequelize-cli db:migrate`
- TYPEORM: src/migrations/, typeorm in package.json
  Command: `npx typeorm migration:run`
- ALEMBIC (Python): alembic.ini
  Command: `alembic upgrade head`
- RAILS: db/migrate/
  Command: `rails db:migrate`
- FLYWAY: flyway.conf
  Command: `flyway migrate`
- CUSTOM SQL: *.sql files in migrations/

If none found check for any folder named migrations/ and infer from contents.

Display tool detected, config path, migration folder path.

PHASE 2 - PENDING MIGRATIONS:
Get list using detected tool. For each pending migration read the file
and classify each operation:

SAFE OPERATIONS:
- CREATE TABLE
- ADD COLUMN with default value
- CREATE INDEX
- ADD CONSTRAINT with default

REVIEW REQUIRED:
- DROP COLUMN (data loss)
- DROP TABLE (data loss)
- ALTER COLUMN type (potential data loss)
- RENAME COLUMN (application code must update)
- RENAME TABLE (application code must update)
- ADD COLUMN NOT NULL without default (may fail if rows exist)
- REMOVE INDEX (performance impact)
- REMOVE CONSTRAINT (integrity impact)

DANGEROUS OPERATIONS:
- DELETE FROM (data deletion)
- TRUNCATE (data deletion)
- DROP DATABASE (catastrophic)
- Anything modifying auth/users tables

For each migration display:
  MIGRATION: [filename]
  Operations: [count]  Risk level: SAFE / REVIEW / DANGEROUS
  Operations found: [list with classification]
  WARNINGS: [data loss or breaking risks]
  Application code to update: [if rename: list files referencing old name]

PHASE 3 - MIGRATION APPROVAL:
If any DANGEROUS operations:
  DANGEROUS MIGRATION DETECTED
  This migration may cause data loss.
  [List dangerous operations]
  Have you backed up the database?
  Type "backed-up" to confirm and continue.
  Type "no" to stop.

If safe or reviewed:
  MIGRATION SUMMARY
  Pending: [count]  Risk: [SAFE / REVIEW / DANGEROUS-confirmed]
  Run migrations now? yes / dry-run / no

If dry-run: show what would happen without changes.

After running display result:
  MIGRATIONS COMPLETE
  Ran: [count]  Status: SUCCESS / FAILED
  If failed: error, rolled back status.
