---
name: migrate
description: Safe database migration management. Detects migration tool, reviews pending migrations for safety risks, warns about destructive operations.
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
