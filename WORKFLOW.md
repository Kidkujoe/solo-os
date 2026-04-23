# Solo OS
The operating system for solo builders.

## Start here
/explore

## Seven workflows
SHIP      audit and ship a feature
BRIEF     start of day focus
MARKET    understand what to build
BUILD     new project from scratch
EMPATHY   see it as your users do
RESEARCH  add knowledge
EVOLVE    improve autonomously

## The mental model

`/explore` opens the door.

- **SHIP** keeps your product healthy feature by feature.
- **BRIEF** keeps you focused every day.
- **MARKET** keeps you building the right things.
- **BUILD** gets new ideas off the ground with validation and a
  running codebase.
- **EMPATHY** keeps you honest about what users actually experience.
- **RESEARCH** makes the system smarter every time you add a source.
- **EVOLVE** improves the product autonomously while you work on
  other things.

## Token costs at a glance

| Workflow | Estimated cost |
|---|---|
| BRIEF | ~500 - 1,000 |
| SHIP feature (Mode 1) | ~3,000 - 5,000 |
| SHIP drift (Mode 2) | ~1,000 - 2,000 |
| EVOLVE per loop | ~3,000 |
| RESEARCH per source | ~2,000 - 4,000 |
| EMPATHY | ~8,000 - 12,000 |
| MARKET | ~10,000 - 15,000 |
| BUILD | ~12,000 - 18,000 |
| SHIP full product audit (Mode 3) | ~30,000 - 50,000 |

These are estimates. Claude Code does not expose exact token
counts via API. The plugin shows cost upfront and tracks a running
session estimate.

## Underlying commands still work

All 22 core commands work directly. Workflows call them in sequence.

Type `/explore` for guided workflows. Type commands directly if
you know exactly what you want.

## Retired as aliases (v3.0.0)

These commands now redirect to a workflow. They still exist so
muscle memory works, but the new way is `/explore`.

| Retired | Now part of |
|---|---|
| `/atlas-map` | SHIP (Full product audit) |
| `/atlas-check` | SHIP (Gate check) |
| `/test-quick` | SHIP (Drift mode) |
| `/test-deep` | SHIP (Full audit, FULL depth) |
| `/compass-feature` | MARKET |
| `/compass-project` | BUILD (Step 1) |
| `/compass-retro` | MARKET |
| `/copyai-research` | RESEARCH (or `/copyai --research-only`) |
| `/reviews` | SHIP (entry context) |
| `/status` | BRIEF |
| `/screenshots` | `/report --screenshots` |
| `/autoloop-setup` | EVOLVE (inline auto-setup) |

## Daily rhythm

| When | Run |
|---|---|
| Morning | `/explore` → BRIEF |
| After a feature | `/explore` → SHIP |
| Weekly | `/explore` → MARKET |
| New knowledge | `/explore` → RESEARCH |
| Autonomous overnight | `/explore` → EVOLVE |
| Review past decisions | `/decisions` |

## Edge case protections (v3.2.0)

**LIGHTHOUSE VARIANCE** — EVOLVE and /performance run three
Lighthouse measurements and use the median score. Prevents
keep/discard decisions based on measurement noise.

**PROJECT RENAME PROTECTION** — moving or renaming a project
folder triggers orphan detection in RESOLVER STEP R2. Existing
memory is offered for migration. Nothing is silently lost.

**STALE SOURCE DETECTION** — /wiki-lint and BRIEF check whether
raw/ source files have been modified since last ingest. The wiki
never silently drifts from its sources.

**MARKET PROFILE ALIGNMENT** — MARKET and /compass cross-check
every roadmap recommendation against the developer profile's
Never Again tier and hard constraints. Never recommends building
something that requires technology you refuse to use.

**DECISION REVIEW** — /decisions lists every recorded skip
resolution, intentional choice, deferred item and disputed rule.
Any decision can be reviewed and changed. No decision is ever
permanently wrong.
