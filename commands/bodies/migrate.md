---
name: migrate
description: Safe database migration management. Detects migration tool, reviews pending migrations for safety risks, warns about destructive operations.
allowed-tools: Bash
---
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
