---
name: stack-audit
description: Health check on current project tech stack. Community health, known issues, version currency, technical debt score. --deep adds architecture assessment and migration planning.
allowed-tools: Bash
---
Read ~/.claude/context/DEVELOPER_PROFILE.md and $PRODUCT_MD.
Detect stack from package.json or equivalent.

PHASE 1 - STACK INVENTORY:
List every dependency with current version. Classify as CORE (product
won't run without it), IMPORTANT (significant feature depends on it),
UTILITY (helper), DEV (dev only).

Display framework, database, auth, deployment, core deps count, total
deps count.

PHASE 2 - COMMUNITY HEALTH per CORE and IMPORTANT dependency:
Check npm registry: current vs latest version, weekly downloads, last
published date, repository.
web_search "[pkg] deprecated", "[pkg] abandoned", "[pkg] alternative".

Classify as:
HEALTHY: actively maintained, growing/stable downloads, no deprecation
WATCH: maintained but slowing, downloads declining, infrequent releases
AT RISK: not updated 1+ year, declining downloads, unresolved issues,
  community discussing alternatives
DEPRECATED/ABANDONED: official deprecation, or no updates 2+ years
  with no maintainer response

PHASE 3 - VERSION CURRENCY:
SAFE TO UPDATE (patch/minor): low risk, provide update command
REVIEW BEFORE UPDATING (minor with potential breaks): check changelog
MAJOR UPDATE - PLAN REQUIRED: breaking changes, migration guide,
  effort estimate

PHASE 4 - TECHNICAL DEBT SCORE:
Start at 100.
-10 per AT RISK dependency
-20 per DEPRECATED dependency
-5 per dep more than 2 major versions behind
-15 per dep with known CVEs
-25 per abandoned dep with no alternative

Score: 80-100 HEALTHY / 60-79 MANAGEABLE / 40-59 ACCUMULATING /
Below 40 CRITICAL.

PHASE 5 - DISPLAY:
Overall health score, status, HEALTHY/WATCH/AT RISK/DEPRECATED lists,
safe to update commands, major updates requiring planning, recommended
actions (this week / this month / this quarter).

IF --deep FLAG:
ARCHITECTURE ASSESSMENT: is current architecture appropriate for
current scale? First scaling bottlenecks? What changes at 10x usage?

MIGRATION PLANNING: for each AT RISK or DEPRECATED dep provide
specific migration plan: what to migrate to, why this alternative,
effort in hours/days, migration risk, recommended timing.

Update DEVELOPER_PROFILE.md with lessons from this audit.
Write to Obsidian LessonsLearned if vault exists.
