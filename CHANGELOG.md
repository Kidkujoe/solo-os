# Changelog

## v3.2.0 - Edge case protection

Five edge cases identified and fixed. These were the highest-priority issues from a systematic audit of data integrity, conflict handling, scale, human behaviour and external dependency failure modes.

**FIX 1 — LIGHTHOUSE VARIANCE**
EVOLVE and /performance now run Lighthouse three times and use the median score. Prevents keep/discard decisions based on measurement noise, which can vary 3–8 points on identical code. Affects `commands/bodies/autoloop.md`, `performance.md`, and `workflow-evolve.md` (the metric-measurement reference).

**FIX 2 — PROJECT RENAME ORPHAN**
RESOLVER.md STEP R2 now detects when a new context is being created for a project that matches an existing orphaned context by product name. Offers migration of all history — Atlas memory, reviews, skip resolutions, experiment logs, and lessons. Nothing is silently lost when a project is renamed or moved. `/projects` now flags folders inactive over 90 days with archive/delete options.

**FIX 3 — STALE RAW SOURCE DETECTION**
RESEARCH now records file modification timestamps in `wiki/log.md` at ingest time using the v3.2.0 extended log format. `/wiki-lint` detects when source files have been modified since last ingest and flags affected wiki pages. BRIEF surfaces stale sources above `FOCUS TODAY` so they are not missed. The wiki no longer silently drifts from its sources.

**FIX 4 — MARKET VS DEVELOPER PROFILE**
MARKET and `/compass` now cross-check every roadmap recommendation against `DEVELOPER_PROFILE.md` — the Never Again tier and hard constraints — before displaying the final roadmap. Conflicts are surfaced with three options: keep with alternative implementation, remove from roadmap, or flag for discussion. Never silently omits a feature.

**FIX 5 — SKIP RESOLUTION REVIEW**
New `/decisions` command. Lists every recorded decision for the current project across four groups: NOT APPLICABLE rules, intentional design choices, deferred items, and disputed rules with their confidence levels. Any decision can be reviewed and changed (A–E answer set). Bulk review mode available. All changes propagate to `skip-tracker.json`, wiki confidence levels, `DECISIONS.md`, and the lessons file. Accessible from `/explore` via plain English ("review my decisions", "undo a skip", "check my rules"). BRIEF surfaces decisions older than 180 days.

No new paths added to RESOLVER.md — all fixes use existing approved paths.

## v3.1.1 - Build system fix

Fixed: `build-commands.sh` was skipping meta commands (`vtpaudit`, `projects`) because they have no body file in `commands/bodies/`.

These commands were previously only synced by hand. Any edit to them in the repo would not propagate to `~/.claude/commands/` on the next build run. This caused the v3.0.0 rename to leave the installed `vtpaudit` pointing at `~/visual-test-pro/` even though the repo was correct.

Fix: extended the build script to copy meta commands as-is after the main build loop. Both are now synced on every build run automatically.

## v3.1.0 - Feedback loop and learning system

The gap this closes: the wiki accumulated knowledge, but the plugin had no way of knowing whether that knowledge was useful or accurate for your specific product. Rules applied generically. False positives accumulated. No memory of what worked and what did not.

What is added:

**SKIP DETECTION**
Every finding is tracked silently. After 3 skips of the same finding, one question is asked. Five possible answers, each producing a different behaviour next session. No answer is wrong. Every answer makes the system more accurate for your product.

**PROJECT-SPECIFIC CONFIDENCE**
Wiki page confidence is now per-project, not global. A Krug rule can be HIGH confidence for HeroDocs and MEDIUM for RSVPie. Each product calibrates rules independently from real usage via the `confidence_for_projects` frontmatter field.

**OUTCOME FOLLOW-UPS IN BRIEF**
14 days after EVOLVE keeps an experiment: BRIEF asks if it actually worked. 8 weeks after MARKET recommends a priority-1 feature: BRIEF asks what happened when built. One question. One keystroke. Answer flows back to wiki confidence, lessons file, and program file.

**LESSONS LEARNED FILE**
One file per project at `~/Documents/SecondBrain/program/[PROJECT]-lessons.md`. Every skip resolution recorded. Every outcome follow-up recorded. Every confidence change recorded. BRIEF surfaces relevant lessons daily. RESEARCH reads lessons before ingesting similar source types. EVOLVE reads lessons before looping and excludes DISPUTED / LOW rules from autonomous improvement.

**HOW IT LEARNS**
Not by retraining. Not by magic. By remembering your judgements and applying them consistently. One keystroke at the right moment; the system compounds those keystrokes across every future session.

**Paths added in RESOLVER.md**
- `$OBSIDIAN_LESSONS_FILE` → `$OBSIDIAN_PROGRAM/$PROJECT_NAME-lessons.md`
- `$SKIP_TRACKER` → `$PROJECT_CONTEXT/skip-tracker.json`
- `$DECISIONS_FILE` → `$PROJECT_CONTEXT/DECISIONS.md`

**Canonical protocol**
`docs/FEEDBACK_LOOP.md` — single source of truth for skip question, five resolutions, confidence enforcement levels, and outcome follow-up triggers.

**Files created on install / first run**
- `~/Documents/SecondBrain/program/[PROJECT]-lessons.md` per product
- `~/Documents/SecondBrain/schema/HOW_THE_SYSTEM_LEARNS.md`
- `$PROJECT_CONTEXT/skip-tracker.json` auto-created by workflows

## v3.0.0 - Renamed to Solo OS

Plugin renamed from Visual-Test-Pro to Solo OS.

Reason: the plugin outgrew its original purpose. It started as a visual testing tool. It is now a complete product development operating system for solo builders covering strategy, research, shipping, user research, knowledge management and autonomous improvement.

The name Visual-Test-Pro no longer described what the plugin does. Solo OS does.

Repository: github.com/Kidkujoe/solo-os

## v3.0.0 - Workflow-first architecture

The fundamental shift: from a toolbox of 48 commands to seven
named end-to-end workflows launched from one entry point.

The problem this solves: a toolbox of commands creates cognitive
overhead. You have to know which tool to pick for which situation,
remember the right sequence, and orchestrate the steps yourself.

The solution: seven named end-to-end workflows that run the right
sequence automatically based on what you want to achieve. One
entry point. Plain English input. Token costs shown before and
after every step.

### Entry point: `/explore`

Context-aware. Reads project state before showing options:
uncommitted changes, unaudited features, branches ready to merge,
unprocessed wiki sources, last EVOLVE run. Shows only what needs
attention. Plain-English routing for any input.

### Seven workflows

**SHIP** — context-aware audit and ship. Reads project state to
present options ranked by urgency. Three modes:
- Mode 1: feature unaudited (3 steps, ~3,000-5,000 tokens)
- Mode 2: feature drift only (2 steps, ~1,000-2,000 tokens)
- Mode 3: full product audit (3 steps, ~30,000-50,000 tokens,
  with QUICK or FULL depth)
Smart security only runs when sensitive files were changed.
One approval to merge and deploy.

**BRIEF** — start-of-day focus. One step, zero approvals. Reads
health, reviews, wiki state, experiment log, uncommitted changes.
Surfaces one clear recommendation.

**MARKET** — what to build next. Three steps, two approvals. Reads
existing wiki intelligence first. Mines Reddit, G2, Capterra,
forums. PRISM-PV scoring on every opportunity. Ranked roadmap with
evidence and an anti-roadmap.

**BUILD** — new project from scratch. Four steps, two approvals.
Validates the idea with market research. Five strategy questions
inline. Stack recommendation from developer profile. Full scaffold
with framework CLI. Plants the Critical Painkiller as the first
feature with Obsidian product folder.

**EMPATHY** — see it as your users do. Two steps, zero approvals.
Six user groups (First-time Visitor, New User, Returning User,
Struggling User, Power User, Evaluator) with Ghost User narratives.
All findings linked to Krug rules from the wiki. Customer language
extracted for `/copyai`.

**RESEARCH** — add knowledge to the wiki. Two steps, two approvals.
Discussion step mandatory before writing (JSON rules files get
special handling and skip discussion). Every claim cited to its
raw source. Knowledge gaps surfaced after every ingest. New
knowledge flows to relevant commands. Loops for multiple sources.

**EVOLVE** — improve autonomously. Two steps, one approval.
Auto-setup runs inline if the program file is empty (4 questions:
metric, allowed scope, protected files, simplicity definition).
Simplicity criterion applied to every proposed change. Keep or
discard with git commit/revert. Hypothesis logging for changes
that need real usage data.

### Token transparency throughout

- Estimated cost shown before each workflow.
- Actual cost shown after each step.
- Session running total visible throughout.
- Approximations disclosed honestly: Claude Code does not expose
  exact token counts via API.

### Retired as aliases (logic absorbed into workflows)

These 12 commands now redirect to a workflow. They still exist
so muscle memory works:

- `/atlas-map` → SHIP (Full product audit)
- `/atlas-check` → SHIP (Gate check)
- `/test-quick` → SHIP (Drift mode)
- `/test-deep` → SHIP (Full audit, FULL depth)
- `/compass-feature` → MARKET
- `/compass-project` → BUILD (Step 1)
- `/compass-retro` → MARKET
- `/copyai-research` → RESEARCH (or `/copyai --research-only`)
- `/reviews` → SHIP (entry context)
- `/status` → BRIEF
- `/screenshots` → `/report --screenshots`
- `/autoloop-setup` → EVOLVE (inline auto-setup)

### What is unchanged

All 22 core commands still work directly. Workflows call them in
sequence. Power users can type any command directly at any time.
Nothing is removed. Everything is reachable.

The v2.6.0 flag routers (`/atlas --rebuild|--check`,
`/test --quick|--deep`, `/compass --feature|--project|--retro`,
`/copyai --research-only`, `/new-project --validate-only`) remain
in place. Flags pointing at retired commands now degrade
gracefully — they read the alias body and the user gets a redirect
to the appropriate workflow.

## v2.6.0 - /explore entry point

The cognitive load problem: 48 commands is too many to remember. The
solution is not fewer commands. It is one memorable entry point that
routes to the right command.

Added:
- `/explore` — single entry point command. Asks what you want to do in
  plain English and routes to the right command or sequence.
  Context-aware: silently checks for uncommitted changes, branches
  ready to merge, stale Atlas context (>7 days) and unprocessed wiki
  sources before showing the menu. Plain English input supported —
  type what you want, not a command name. Name chosen because the
  whole system is about exploration: exploring your market, your
  users, your product health and your knowledge.
- `/stack` — thin router for all stack intelligence commands via
  flags: `--profile`, `--recommend`, `--audit`, `--compare`, `--update`.
- `WORKFLOW.md` — plain English reference card showing the mental
  model and daily workflow without listing every command.
- Solo OS section appended to the Obsidian `Dashboard.md`
  for at-a-glance reference inside the Second Brain vault.

Flag support added (the standalone commands still exist; flags are
additive shortcuts):
- `/atlas --rebuild` (was `/atlas-map`)
- `/atlas --check` (was `/atlas-check`)
- `/atlas --quick` (was `/atlas-quick`)
- `/atlas --feature [name]` (was `/atlas-feature [name]`)
- `/test --quick` (was `/test-quick`)
- `/test --deep` (was `/test-deep`)
- `/compass --feature [name]` (was `/compass-feature [name]`)
- `/compass --project` (was `/compass-project`)
- `/compass --retro [name]` (was `/compass-retro [name]`)
- `/copyai --research-only` (was `/copyai-research`)
- `/new-project [idea] --validate-only` (runs Phase 1 only, stops
  at the BUILD verdict — no strategy, stack or scaffolding)

Removed:
- `/wiki-schema` — was a thin wrapper around editing
  `WIKI_SCHEMA.md`. Users open the file directly in Obsidian.
  (No body or installed file existed; nothing to delete on disk.)

Unchanged:
- All previous commands still exist and work exactly as before.
  Flags are additive. Nothing was broken or reduced. Cognitive load
  was reduced by giving users one entry point and a clear mental
  model. Power users who know the commands can still use them
  directly.

## v2.5.1 - Path isolation fixes

- `~/.claude/context/DEVELOPER_PROFILE.md` added to the approved
  globals list in RESOLVER.md. File is intentionally cross-project
  alongside `test-accounts-global.md`. This was a v2.4.0 oversight
  where the file was introduced without updating the approved paths
  list, flagged by `/vtpaudit` in six commands (`compass-project`,
  `new-project`, `stack-audit`, `stack-compare`, `stack-recommend`,
  `stack-update`).
- `~/Documents/SecondBrain/` added to the approved globals. Obsidian
  vault paths defined in `RESOLVER.md` STEP R8 with explicit variables
  for the wiki layer: `OBSIDIAN_RAW`, `OBSIDIAN_WIKI`, `OBSIDIAN_SCHEMA`,
  `OBSIDIAN_PROGRAM`, `OBSIDIAN_PROGRAM_FILE`.
- STEP R4 verification rewritten to document all approved globals
  (inside `~/.claude/` and inside the Obsidian vault) instead of the
  stale "two approved global resources" wording.
- `testVis` command removed — legacy, pre-v2.x artifact referencing a
  non-existent `mcp__claude-in-chrome__*` MCP and a `/chrome` command
  that does not exist. Not registered in `plugin.yaml`, no body file,
  no resolver. Fully superseded by `/test`.
- Six v2.4.0 Stack Intelligence commands (`new-project`, `stack-audit`,
  `stack-compare`, `stack-profile`, `stack-recommend`, `stack-update`)
  back-filled into `commands/bodies/`. They had been installed without
  body files in v2.4.0, so `build-commands.sh` skipped them on every
  run, pinning them on the old resolver. The build system is now the
  single source of truth for all 46 buildable commands.
- `/vtpaudit` passes clean after rebuild. 46 / 48 installed commands
  on the current resolver; the two without a resolver (`projects`,
  `vtpaudit`) are intentionally resolver-less plugin-level commands
  that do not operate on any project context.

## v2.5.0 - Karpathy LLM Wiki and autoresearch patterns

Adds a compounding knowledge base (LLM Wiki) and an autonomous
improvement loop (autoresearch), drawn from two Karpathy sources:

- LLM Wiki Gist: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f (April 4 2026)
- autoresearch: https://github.com/karpathy/autoresearch (March 2026)

The wiki gives the loop knowledge to act on. The loop writes its
results back to the wiki.

### From the LLM Wiki gist

- `raw/` folder with `articles/`, `rules/`, `calls/`, `transcripts/`,
  `papers/`, `sources/`, `assets/` subfolders. `raw/` is the immutable
  source of truth — LLM reads, never modifies.
- `wiki/` folder maintained by the LLM with entity, concept, rules
  and synthesis pages.
- `schema/WIKI_SCHEMA.md` governs every wiki operation. Co-evolves
  with the vault over time.
- `/wiki-ingest` with mandatory discussion step before writing, JSON
  rules files compile each rule to a dedicated wiki page, knowledge
  gap report after every ingest.
- `/wiki-query` with full evidence chains. Good answers are filed
  back as Synthesis pages so explorations compound.
- `/wiki-lint` with active gap identification — the system reports
  what it does not know and suggests what to find.
- `wiki/index.md` as master catalog. `wiki/log.md` as append-only
  record of every operation.
- Three-layer architecture: `raw/` (input), `wiki/` (compiled
  knowledge), `Products/`+`Research/`+`Patterns/` (plugin operational
  notes). Clearly separated, no duplication.

### From autoresearch

- `program/[ProductName].md` per project defining the metric, scope,
  and simplicity criterion.
- `/autoloop`: reads program file, measures baseline, proposes
  improvement, measures before and after, keep-or-discard verdict,
  git commit on every kept experiment.
- Experiment log per project (equivalent to autoresearch `results.tsv`).
- Simplicity criterion: removal achieving equal result is always
  preferred over addition.
- Hypothesis logging for improvements requiring real user data.
- `/autoloop-setup`: creates program file interactively. User iterates
  over time.
- Autoloop results filed back to the wiki as Synthesis pages.

### Existing commands now read from the wiki

- `/design` — loads `Rules-*.md` as the authority, not generic best practice.
- `/copy` and `/copyai` — load `Rules-BrandVoice.md` + `Concept-*`
  customer language pages.
- `/compass` — reads `Competitor-*.md` before new research (still
  writes its own output to `Research/Competitors/`).
- `/atlas-quick` — surfaces new wiki knowledge in the daily
  recommendation.

### Naming conflicts resolved

- No `raw/competitors/` folder — competitor articles go in
  `raw/articles/` with clear filenames.
- No `raw/notes/` folder — quick notes use existing `Inbox/`,
  longer thinking uses `raw/sources/`.
- `wiki/` and `Products/`+`Research/`+`Patterns/` are separate layers
  that reference but do not duplicate each other.

## v2.4.1 - Knowledge Bridge fix

- Fixed auto-write hooks not firing in /atlas for Features and Insights
- Phase 3.5 added to atlas command body: automatically writes a Feature
  note for every feature detected and an Insight note for every
  significant finding without requiring user prompting
- Fixed compass-project.md body missing Developer Profile integration
  block
- Build system is now the single source of truth for all 35 commands

## v2.4.0 — Stack Intelligence and New Project System

Introduces a permanent developer profile that lives outside any single
project and personalises every future technical recommendation.

Six new commands:
- `/stack-profile` — Builds your permanent DEVELOPER_PROFILE.md by
  inferring from existing project contexts and asking 8 targeted
  questions. One-time setup (~10 minutes). Saves globally.
- `/stack-recommend` — Personalised tech stack for any project.
  References your actual project history explicitly. Never recommends
  Never Again tier technologies. Estimates setup time by your
  familiarity.
- `/stack-audit` — Health check on current stack. Community health,
  version currency, technical debt score (0-100). `--deep` adds
  architecture assessment and migration planning.
- `/stack-compare` — Compare two technologies personalised to your
  skill level and project context. Not generic pros/cons.
- `/stack-update` — Update your profile after finishing a project,
  having an incident, learning something new or changing goals.
- `/new-project` — Complete kickstart from idea to running code in
  one session. Seven phases covering validation, strategy, stack,
  scaffolding, first roadmap and Obsidian setup. Target under 40 min.

Global developer profile:
- DEVELOPER_PROFILE.md at ~/.claude/context/ (not per-project)
- Stores shipped product history with honest assessments
- Technology comfort ratings with production and incident tracking
- Personal Tech Radar: Adopt, Trial, Assess, Hold, Never Again
- Hard constraints, working preferences, goal priority order
- Every command that recommends technology reads this first

Obsidian Developer folder (if vault exists):
- `Developer/Profile.md` — summary mirror of DEVELOPER_PROFILE.md
- `Developer/TechRadar.md` — live tech radar across all projects
- `Developer/TechDecisions/` — per-project stack decision notes
- `Developer/LessonsLearned/` — incident and learning notes

Integration updates:
- /compass-project personalises I (Implementation) score in PRISM-PV
  based on developer familiarity with the required stack
- /atlas reads DEVELOPER_PROFILE.md and never recommends Never Again
  technologies; explicitly mentions when recommendations align with
  Adopt tier

This closes the final gap in the plugin: recommendations that
understood the product but not the person building it. Every future
technical decision now knows who you are.

## v2.3.1 - Fix pre-existing path isolation violations

Moves five hardcoded `~/.claude/context/` paths in `pillars`, `test-deep`
and `test` under `$PROJECT_CONTEXT/` so project data never leaks across
projects. These violations predated v2.3.0 and were surfaced by the
/vtpaudit run after the Knowledge Bridge build.

- `pillars-audit.json` is now written to `$PROJECT_CONTEXT/pillars-audit.json`
  in /pillars, /test-deep and /test
- `agent-state-archive/` is now at `$PROJECT_CONTEXT/agent-state-archive/`
  in /test
- /vtpaudit now reports zero violations

## v2.3.0 - Obsidian Second Brain Integration

- Obsidian Knowledge Bridge added to RESOLVER.md
- Six write functions create atomic notes in Obsidian for decisions,
  patterns, insights, competitors, features, user insights and reviews
- Four read functions load existing Obsidian knowledge before running
  commands so the plugin learns from accumulated context
- Inbox processing: notes written in Obsidian Inbox are read and
  incorporated on next command run
- Competitor notes updated not overwritten: new research merges with
  existing intelligence
- Pattern detection writes to Obsidian when threshold of 3 recurrences
  met
- /compass, /copyai, /empathy, /atlas, /atlas-feature, /review-cycle
  and /design all updated to use the bridge
- Vault path stored in STRATEGY.md per project
- Product folder auto-created on first run if missing
- Dashboard.md uses Dataview to show all features, patterns, insights
  and decisions

## v2.2.0 — Completion and Robustness

Closes all 10 gaps identified in the v2.1.0 gap analysis and fixes 3
fragility risks. Solo OS is now feature-complete end-to-end.

Six new commands:
- `/performance` — Real Lighthouse audits (desktop + mobile), Core Web
  Vitals (LCP, CLS, INP, FCP, TTFB), bundle size analysis, previous-run
  comparison, specific recommendations per failing metric. Saves scores
  to HEALTH.md so /seo and /pillars reference real measured numbers.
- `/deploy` — Platform detection for Vercel, Netlify, Render, Fly.io,
  DigitalOcean, Railway and custom/VPS. Pre-deploy checks (build,
  migrations, env vars), deploy monitoring with streaming output,
  post-deploy smoke test in browser, automatic rollback offer on failure.
- `/ship` — Lightweight daily driver for small commits. Secrets scan,
  30-second build check, 10-second visual spot check, conventional
  commit message generator with 3 suggestions, push confirmation. For
  typos, copy tweaks, minor fixes that don't need the full review cycle.
- `/deps` — Proactive dependency health audit. Classifies updates as
  patch (safe), minor (usually safe) or major (breaking). Fetches
  changelog for major upgrades. Flags abandoned packages (>2y no update,
  <1000 weekly downloads). Full security scan. `/deps fix` applies safe
  updates. `/deps upgrade [pkg]` guided major upgrade with backup branch.
- `/env-diff` — Environment parity check across .env files, code
  references, and production secrets. Finds missing-in-production,
  missing-locally, in-code-but-undefined-anywhere, dev-only vars in
  production. Displays NAMES only, never values (critical rule).
- `/migrate` — Safe database migration management. Detects Drizzle,
  Prisma, Sequelize, TypeORM, Alembic, Rails, Flyway, custom SQL.
  Classifies operations as SAFE / REVIEW / DANGEROUS. Requires
  explicit "backed-up" confirmation for destructive operations.
  Dry-run mode available.

Three fragility fixes:
- /test-deep now detects large projects (>50 files) and offers FULL /
  CORE / AUDIT / CUSTOM modes. Graceful degradation skips lowest-priority
  steps when context runs low rather than silently truncating. Priority
  order documented: Visual, Security, CodeRabbit, Reliability always kept.
- Multi-agent system now validates capability before spawning. Falls
  back to sequential mode when context is low or files >20. File
  locking via $AGENT_COORD with 30-second deadlock detection prevents
  concurrent write conflicts. Agent state persistence enables /resume
  from any point mid-fix.
- CodeRabbit async completion now honestly documented. Detection
  happens when /status or /reviews runs (not silent background polling).
  When a previously-pending PR review has completed, /status surfaces it.

Resolver architecture:
- New `scripts/build-commands.sh` regenerates all command files from
  RESOLVER.md + `commands/bodies/*.md`. Single source of truth. No more
  32-file manual updates when the resolver changes.
- /vtpaudit now checks resolver version against RESOLVER.md and flags
  out-of-date commands. Suggests running build-commands.sh.

Integration updates:
- /atlas-feature prompts to /deploy after successful merge
- /atlas daily recommendation includes:
  - Security vulnerability alerts from /deps
  - Performance audit age (run if >30 days)
  - Pending database migrations
  - Missing /env-diff before last deploy
- /review-cycle flags dangerous migrations before commit (Stage 2B)
- /status expanded with deployment status, dependency health,
  environment parity and performance sections

37 total commands now installed (25 original + 4 review + 2 safeguard +
6 new this release).

## v2.1.0 — CodeRabbit Automation System

New commands:
- `/review-cycle` — Full 11-stage pipeline: detection → pre-review gates → commit → push → CodeRabbit → visual test → quality check → fix approval → docs → history → merge readiness
- `/reviews` — Branch and review status board with cross-branch conflict detection
- `/merge-ready` — Merge readiness scorecard with stale review detection and explicit approval flow
- `/rollback` — Safe rollback of merged features with pre-merge snapshot

CodeRabbit detection:
- Auto-detects CLI, GitHub App, VS Code extension, and .coderabbit.yaml config
- Version and path displayed for each installation found
- Recommends best tool based on development stage (CLI for local, GitHub App for PR)
- Detection cached per project in cr-detection.json
- Offers to create default .coderabbit.yaml with balanced profile and path_instructions for auth/payment files

Pre-review gate (6 mandatory gates):
- Secrets scan (STOPS pipeline if found — no skip option)
- Dependency audit with CVE check and suspicious package flagging (<500 weekly downloads, >2y stale)
- Build check with streaming output and 60s timeout
- Test suite with failure details and 120s timeout
- Lint with auto-fix offer
- Change impact assessment classifying files as high/medium/low risk (auth, payment, database files marked HIGH)

Visual progress system:
- Streaming output for CLI reviews
- 30-second polling for GitHub App reviews
- Live finding count updates as results arrive
- Elapsed time always visible
- Desktop notification on completion if review took >60s

Review quality scoring (out of 100):
- Coverage: -20 if any changed files not reviewed
- Confidence: -10 if predominantly uncertain language
- Distribution: -15 if any high-risk file has zero findings
- Completeness: -25 if review did not finish
- Speed: -10 if review took <30s
- Below 60: blocks merge approval

Git platform system:
- Auto-detects GitHub, GitLab, Bitbucket from remote URL
- Cached in git-config.json per project
- CONFIRM PUSH panel required before any push
- PUSH CONFIRMED panel after success showing commit hash and URL
- Push failure diagnosis

Merge flow:
- Pre-merge snapshot saved for rollback
- Conflict check with `git merge --no-commit --no-ff` before merge
- Stale review detection (48 hour expiry)
- Explicit approval required every time
- Post-merge smoke test in browser
- Auto PR creation via `gh pr create`
- Branch cleanup after merge

Review history (REVIEWS.md):
- Complete sign-off record per feature with all gate results, CodeRabbit details, fixes
- Recurring finding pattern detection (3+ occurrences triggers suggestion)
- Review velocity tracking
- False positive tracking

Documentation review stage:
- README currency check (feature mentioned? outdated sections?)
- CHANGELOG.md update verification
- Code comment quality (complex sections, comment lies)
- API documentation accuracy for new endpoints

Atlas-feature integration:
- Review cycle triggers automatically after post-feature checklist passes
- Async review completion surfaced in next /status run
- Steps 8-10 added for terminology, SEO basics, empathy check

27 existing commands + 4 new review commands = 31 total commands installed.

## v2.0.1 — Project Isolation Architecture

**CRITICAL BUG FIX.** All previous versions wrote project-specific
context data to shared global paths. When multiple projects used the
plugin they contaminated each other's data. This release fixes the
architecture permanently.

Changes:
- Per-project context folders: every project gets its own isolated folder at `~/.claude/context/projects/[id]/`
- Project identifier derived from absolute project path plus 6-character hash (handles duplicate folder names)
- Resolver system: single canonical resolver in RESOLVER.md copied verbatim into every command
- All 25 existing command files updated to use resolver and per-project paths
- Project stamps (`# Project: [id]`) on all context files enable contamination detection
- Contamination detection in resolver catches and reports any mismatches on every command run
- test-accounts-global.md uses keyed structure — one file, credentials isolated per project via PROJECT_ID section
- `/vtpaudit` command added for ongoing isolation verification
- `/projects` command added to list and manage all projects with context data
- install.sh updated to create global-only resources at install time (per-project files created by resolver on first command run in each project)
- install.sh displays migration warning if old global data detected
- RESOLVER.md added as single source of truth for path logic
- 27 total commands (25 updated + /vtpaudit + /projects)

This fix is backwards compatible. Existing data at old global paths is
detected by install.sh and flagged for in-app migration. The resolver
detects and reports any future violations before they cause contamination.

## v2.0.0 — Empathy System complete

This version marks Solo OS reaching its complete vision.
Every dimension of product quality is now covered: technical, visual,
content, market and human.

- Added /empathy command with JOURNEY framework (J-O-U-R-N-E-Y: Job clarity, Orientation, Uncertainty, Recovery, Navigation, Expectation matching, Your next step)
- Six user group system derived from STRATEGY.md: First-time Visitor, New User, Returning User, Struggling User, Power User, Evaluator
- Ghost User Test protocol producing first-person narratives for each group
- Mental model mapping and gap analysis
- Emotional arc analysis with first success timing assessment
- Three-level goal hierarchy testing (immediate, underlying, life goal)
- Trust progression audit across six rungs: Attention, Information, Effort, Habit, Payment, Advocacy
- Interruption recovery testing across five scenarios (onboarding, task, session, device, absence)
- Expertise journey testing for Beginner, Intermediate, Power User
- Social context evaluation: sharing, collaboration, reporting, recommendation
- Failure state audit: user error, system error, empty states, blocked states, loading states
- Progress and momentum system testing
- Accessibility as UX: keyboard, screen reader, cognitive load, motor, colour
- Complete friction map: abandon points, abandon risks, backtrack, pause, micro
- Prioritised fix list with effort estimates and expected impact
- Ghost User Story HTML report with narrative format, emotional arc visualisation, friction map grid, trust ladder
- EMPATHY.md persistent memory in atlas context
- Atlas updated to surface abandon points in daily recommendations before suggesting new features
- Atlas-feature post-feature checklist adds Step 10 UX empathy check
- Test-deep includes lightweight empathy check
- Compass scoring adds +3 modifier when feature addresses documented friction
- Compass flags when fixing existing friction may be more valuable than new feature

## v1.9.1

- HTML report now includes "Your Next Command" section that translates findings into specific commands to run
- Smart routing: security issues → /pillars, design drift → /design, copy issues → /copy or /copyai, SEO gaps → /seo, planning → /compass, regressions → /atlas-check
- Compact command reference card added at end of every report, grouped by purpose: Testing and Fixes, Product Intelligence, Quality and Audits, Utilities
- Each command shown with one-line purpose and "when to run it" hint
- Helps users discover the full plugin capability from any test report

## v1.9.0

- Added /compass command with PRISM-PV framework for full product intelligence
- Added /compass-feature for single feature evaluation using PRISM-PV
- Added /compass-project for new project market validation before writing code
- Added /compass-retro for retrospective calibration of scoring accuracy
- PRISM-PV framework: Pain signal (0-6), Revenue impact (0-4), Implementation difficulty (0-2), Strategic fit (0-3), Market demand (0-3), Painkiller vs Vitamin (0-2) — max 25 with modifiers
- Five Painkiller classifications earned from behavioural evidence: Critical, Strong, Hybrid, Strong Vitamin, Pure Vitamin
- Painkiller urgency: Acute (ACT NOW), Growing (SCHEDULE URGENTLY), Latent, Triggered (STAGE GATE)
- Score modifiers: Window Opening/Closing (+3/+2), Strong Moat (+2), North Star Mover (+2), Build vs Buy Shortcut (+2), Word of Mouth (+2), High Maintenance (-2), Weak Moat + Low Signal (-3), Strategic Conflict (-5)
- Three feature gap types: unmet demand (gold), table stakes risk, acquisition opportunity
- Build vs buy vs integrate check on every high-score feature
- Cannibalisation and conflict checks before finalising roadmap
- Validation recommendations for moderate-signal features (fake door, survey, manual delivery, wait)
- Four roadmap views: ranked, effort vs impact matrix, time horizon, Painkiller vs Vitamin
- Anti-roadmap: Not Now, Never Build, Window Closed, Watch List with specific reasons
- Existing feature audit: Double Down, Maintain, Question, Remove
- STRATEGY.md created via five focused questions on first run
- COMPASS.md persistent memory with full feature database and evidence
- COMPASS HTML report with opportunity cards, competitive intelligence, evidence wall
- Atlas, test-deep, design, copyai all reference COMPASS for alignment
- Retrospective command calibrates scoring accuracy over time

## v1.8.1

- Added Pattern and Signal Threshold System to Copy Intelligence skill
- Insights now require minimum 5 instances to be considered evidence (5 LOW, 10 MEDIUM, 20+ HIGH)
- Confidence scoring: 0-5 weak (no action), 6-10 moderate (note with caution), 11-15 strong (actionable), 16+ very strong (core opportunity)
- Cross-platform consistency required for high confidence — single-platform patterns penalised
- Behavioural consequence tracking: cancellation, migration, workaround signals weighted +5 points
- Recency weighting: last 12 months full weight, 12-24 half weight, older context only
- Collection targets: minimum 15 Reddit, 20 reviews, 10 Product Hunt, 10 Twitter per topic
- Tagging phase: every data point tagged with source, date, type, sentiment, behaviour, topic, key phrase
- Clustering phase: groups tagged data into confirmed patterns (3+ similar across any platforms)
- Filtering phase: discards weak signal below threshold, saves emerging signals to watch
- Explicit "What the data does not show" section in synthesis
- Every copy rewrite shows specific pattern evidence: instance count, platform count, behaviour signals, trend direction
- Expected impact rated by confidence level (HIGH/MODERATE) for each change
- HTML report updated with pattern strength bars, evidence count badges, trend arrows, and Evidence Wall section
- COPYAI.md pattern database saves all collected quotes not just display samples
- Emerging signals tracked for future research runs

## v1.8.0

- Added /copyai command for full intelligence-driven copy strategy and rewrites
- Added /copyai-research command for research and strategy only (no rewrites)
- Phase 1: Product intelligence brief derived from codebase and confirmed with user
- Phase 2: Competitor identification via web search with user confirmation
- Phase 3: Competitive intelligence including weakness mining from Reddit, G2, Capterra, Product Hunt, Trustpilot, Twitter/X, LinkedIn, YouTube comments, Hacker News and Indie Hackers
- Migration trigger analysis: what specifically causes customers to leave competitors
- Phase 4: Voice of customer research sourcing real customer language from the same platforms
- Phase 5: Copy Intelligence synthesis with full strategy — positioning, primary message, emotional hook, transformation narrative, words to use and avoid, tone recommendation
- Every strategy recommendation backed by specific evidence with sources
- Phase 6: Full copy rewrites across all surfaces — landing page, onboarding, features, pricing, errors, empty states, emails and navigation
- Every rewrite shows current copy, why it needs changing with evidence, and why the new version works
- Phase 7: Changes applied to files, VOICE.md updated with new positioning, COPYAI.md created as permanent research memory
- Phase 8: Copy Intelligence HTML report with executive summary, customer quotes, competitor intelligence cards, evidence cards, before/after comparison cards and full source list
- 6 month refresh schedule with Atlas reminder when overdue
- /copy now references COPYAI.md when available for stronger suggestions

## v1.7.0

- Added /design command for full design integrity audit
- DESIGN.md now captures comprehensive design inventory: full colour system with semantic meanings, complete typography scale, spacing system, component inventory with visual signatures and interactive states, border/shape system, animation/transition system, icon system, layout system with z-index scale, and overall aesthetic assessment
- Design Integrity Check runs in six phases: identify changes, extract visual signature, compare against design system, categorise findings, display report, browser visual comparison
- Findings categorised as Critical (clashing), High (noticeable), Medium (minor), or Intentional Variation
- Every finding includes the specific correct value from the design system and exact code change needed
- Browser visual comparison catches issues only visible in rendered context
- Intentional variations logged in DECISIONS.md and never flagged again in future audits
- Design score tracked over time in HEALTH.md
- Integrated into Atlas post-feature checklist (step 5 now runs full 6-phase check)
- Integrated into /test-deep automatically (new step 12)
- /atlas-check includes lightweight design check
- HTML report gains Design Integrity section with colour swatches, typography samples, findings grouped by category, and design health trend

## v1.6.0

- Added /copy command for full brand voice and copy consistency audit
- Added /seo command for full SEO audit with page inventory, on-page basics, semantic HTML, technical SEO, structured data opportunities, and keyword consistency
- Atlas now reads VOICE.md and SEO.md as part of startup context
- VOICE.md drafted automatically from codebase on first /copy run — user confirms before it is used
- Terminology map tracks what words are used for each feature across the product
- Error message quality audit flags poor messages with suggested rewrites
- Empty state quality audit checks all zero-state UI
- Marketing vs product alignment check catches promise vs reality mismatches
- SEO page inventory classifies every page as should-index or should-not-index
- Structured data opportunities identified with JSON-LD generation offered
- Atlas post-feature checklist now includes terminology and basic SEO checks (steps 8 and 9)
- /test-deep now includes lightweight copy and SEO check automatically
- Atlas health score now includes copy consistency and SEO health
- HTML report includes WHAT YOUR APP IS SAYING section with copy and SEO findings

## v1.5.0

- Added /atlas command as master orchestrator and product brain
- Atlas maps your entire codebase on first run and keeps the map updated
- Living context files in ~/.claude/context/atlas/ store product knowledge permanently: PRODUCT.md, DESIGN.md, DECISIONS.md, DEPENDENCIES.md, REGRESSIONS.md, HEALTH.md
- Regression Agent (Agent 7) added to multi-agent system with veto power over all other agents
- Dependency snapshot taken before every fix session, broken dependencies detected immediately
- Intentional removal declarations prevent false regression alerts
- Smoke test runs on all features sharing code with changed files
- Design consistency guardian with three-tier system: auto-fix pure visual issues, flag side-effect risks, never touch intentional differences
- Post-feature checklist gives go or no-go verdict after every feature
- Context always updated to match code — code is source of truth
- Stale context cleaned up automatically
- All existing commands now read Atlas context for full product awareness
- Atlas health score tracked over time in HEALTH.md
- Regression history tracked in REGRESSIONS.md
- Added /atlas-quick (refresh + recommendation), /atlas-map (full rescan), /atlas-check (regression + consistency), /atlas-feature (post-feature checklist)
- Atlas dashboard added to HTML reports with health score and trend

## v1.4.2

- Screenshots now organised by project and session in dated folders with subfolders for before-fixes, after-fixes, edge-cases, and pillars
- Before and after fix pairs saved and shown as side by side comparisons in the HTML report
- Cleanup prompt after every completed session with five options (keep, keep important, archive, delete, ask later)
- Auto detection of old sessions older than 7 days with cleanup offer at session start
- Screenshot deduplication prevents saving near identical images of same page at same breakpoint
- Screenshots over 2MB compressed to under 500KB automatically
- HTML report references screenshots by file path not embedded base64, making report files much smaller
- Placeholder shown in report if screenshot was deleted after session
- New /screenshots command to manage all session screenshots in one place
- Applied to both /test and /test-deep commands

## v1.4.1

- Removed duplicate Pillar 5 (Design) and Pillar 6 (Performance) — these are already covered by the visual testing, responsive checks, and accessibility steps
- Folded unique performance checks (bundle size, image optimisation, time to interactive) into Pillar 3 Scalability
- Four clean pillars with zero overlap: Reliability, Security, Scalability, Observability
- Added explicit note in command files explaining what is covered where

## v1.4.0

- Added Four Pillars of Production Readiness audit
- Pillar 1 Reliability: Error Boundaries, loading states, try/catch, transactions, timeout/retry
- Pillar 2 Security: hardcoded secrets scan, session leakage, middleware audit, input validation, auth security
- Pillar 3 Scalability: state storage, heavy query detection, connection pooling, caching, file handling
- Pillar 4 Observability: logging audit, error monitoring, health checks, alerting, audit trail
- Pillar 5 Design: visual consistency, mobile responsiveness, visual glitch detection (browser-based)
- Pillar 6 Performance: image audit, bundle size, server response times (browser-based)
- New /pillars command for standalone production readiness audit
- Pillars run automatically in /test-deep mode
- Available as option 4 (Standard + Pillars) in /test mode
- Production readiness score and verdict in HTML report
- All findings written in plain English with specific file references and urgency levels

## v1.3.1

- Added full agent state persistence to ~/.claude/context/agent-state.json
- Session automatically saves after every agent action: spawns, claims, fixes, messages, verifications, conflicts
- Interrupted sessions detected on startup with clear resume options (resume exactly, restart interrupted, start fresh, discard)
- Agents restore to exact state when resumed including unread messages and claimed files
- Partial file edits detected and handled safely on resume
- /resume now shows full agent team status, blocked fixes, unread messages, and pending conflicts
- /status now shows live agent team status, claimed files, and blocked fixes
- Session archive keeps last 5 completed sessions for reference
- HTML report includes session continuity note (fresh vs resumed)

## v1.3.0

- Added multi-agent fix system
- Specialist agents now work in parallel on Security, Logic, UI, Data and Performance fixes simultaneously
- Agents coordinate with each other before touching shared files
- Test Agent verifies every fix and sends failed fixes back for retry
- Live agent dashboard shows progress in real time
- Conflict detection when agents need the same file
- Plain English agent communication log in HTML report
- Escalation to user after three failed attempts per fix
- Time saved vs sequential fixing shown in summary
- Available in /test and /test-deep modes

## v1.2.0

- Added intelligent edge case discovery
- Claude now analyses the codebase and independently generates edge cases specific to each app
- Edge cases categorised by risk level: high, medium, interesting
- New /edgecases command for analysis without running a full test
- Edge cases saved to memory for future sessions
- HTML report now includes edge case findings in plain English
- Edge case discovery runs in /test and /test-deep before the options menu
- Users choose how to handle edge cases: test all, high risk only, skip, or save for later

## v1.1.0

- Added real time visible cursor during visual testing
- Purple cursor with click animations and plain English action labels
- Status bar overlay showing current test action in plain English
- Smooth natural mouse movement between elements
- Cursor cleans up before screenshots so reports stay clean
- Cursor re-injects automatically after every page navigation
- Hover state changes cursor colour and size
- Click animation shrinks dot and expands ring
- Applied to both /test and /test-quick commands

## v1.0.0

- Initial release
- 7 commands: /test, /test-quick, /test-deep, /report, /resume, /status, /addaccount
- Visual browser testing with Chrome MCP
- Code review with security and quality checks
- Authentication handling including magic links
- Smart fix decision flow with side effect warnings
- Token awareness with options and recommendations
- Plain English HTML reports
- Session memory and resume support
- Test account management
