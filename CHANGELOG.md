# Changelog

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
fragility risks. Visual-Test-Pro is now feature-complete end-to-end.

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

This version marks Visual-Test-Pro reaching its complete vision.
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
