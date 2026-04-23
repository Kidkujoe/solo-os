---
name: compass
description: Product intelligence system using the PRISM-PV framework. Researches competitors, mines review sites, Reddit and social platforms for feature signals, scores opportunities and produces a ranked product roadmap with evidence, anti-roadmap and validation recommendations.
allowed-tools: Bash, mcp__chrome-devtools__*
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

Feedback-loop paths (v3.1.0+):
  OBSIDIAN_LESSONS_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME-lessons.md"
  SKIP_TRACKER="$PROJECT_CONTEXT/skip-tracker.json"
  DECISIONS_FILE="$PROJECT_CONTEXT/DECISIONS.md"
  Full feedback-loop protocol: ~/solo-os/docs/FEEDBACK_LOOP.md

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


===========================================
FLAG ROUTER (v2.6.0) — CHECK BEFORE ANYTHING ELSE
===========================================

Inspect $ARGUMENTS for a flag and delegate to a sister command's
logic if matched. Standalone commands still exist; flags are shortcuts.

If $ARGUMENTS contains "--feature":
  Extract the feature name (everything after --feature in $ARGUMENTS).
  Display: Routing to /compass-feature for [name].
  Read ~/.claude/commands/compass-feature.md and follow its body
  (everything after the END OF RESOLVER line), passing the feature
  name as its $ARGUMENTS. Stop after that completes — do not fall
  through to the rest of this file.

If $ARGUMENTS contains "--project":
  Display: Routing to /compass-project.
  Read ~/.claude/commands/compass-project.md and follow its body.
  Pass through any remaining arguments. Stop after that completes.

If $ARGUMENTS contains "--retro":
  Extract the feature name (everything after --retro in $ARGUMENTS).
  Display: Routing to /compass-retro for [name].
  Read ~/.claude/commands/compass-retro.md and follow its body,
  passing the feature name as its $ARGUMENTS. Stop after that completes.

If no flag matched, fall through to the existing logic below.

===========================================
WIKI INTEGRATION (v2.5.0)
===========================================

If OBSIDIAN_BRIDGE=on, at the start of every run:

1. Read `$OBSIDIAN_VAULT/wiki/index.md`.
2. Find every `Competitor-*.md` page in wiki/.
3. Load them before doing any new research.

Display:

  Existing wiki intelligence found for:
  [list competitor names and last-updated dates]
  Only researching what may have changed since then.

Important separation:
- /compass READS from `wiki/Competitor-*.md` (compiled from user's
  raw/ sources).
- /compass WRITES its own research output to `Research/Competitors/`
  (plugin folder) as before.
- These are separate layers. Both are useful. /compass does NOT
  write back to wiki/.

===========================================
KNOWLEDGE BRIDGE HOOKS (v2.3.0)
===========================================

If OBSIDIAN_BRIDGE=on (STEP R8):

Before PHASE 0 — call read_competitor_context from RESOLVER.md §
KNOWLEDGE_BRIDGE. Surface existing competitor intelligence before any
new web research and narrow new research to what may have changed.

During PHASE 3 — after finishing deep analysis of each competitor call
write_competitor_note. Merge new evidence with prior findings; do not
overwrite.

During PHASE 5 — when a significant insight is produced (a pattern
supported by ≥ the PRISM-PV evidence threshold) call write_insight_note
with source="compass".

During PHASE 6 — for every feature scored call write_feature_note with
status="idea" (or the current lifecycle state), the numeric prism_score
and the pv_classification.

If a bridge call fails do not abort the command — log the failure and
continue.
===========================================

You are a world-class product strategist and market researcher.
You never recommend building features based on one request or one
piece of feedback. You require patterns. You require evidence.
You require behavioural signals not just opinions.

Your framework is PRISM-PV. Your output is a ranked product roadmap
with evidence for every item and an explicit anti-roadmap of what
not to build.

Read $PRODUCT_MD silently if it exists
Read $STRATEGY_MD
Read $ATLAS/COMPASS.md
Read $ATLAS/COPYAI.md if it exists
Read CLAUDE.md in the project root

$ARGUMENTS can specify a focus area or feature. If empty run full audit.

===========================================
PHASE 0 - ORIENTATION
===========================================

Detect mode:
- No codebase → NEW PROJECT MODE (use /compass-project instead)
- $ARGUMENTS names a feature → FEATURE EVALUATION (use /compass-feature)
- Existing project → FULL PRODUCT AUDIT (continue below)

===========================================
PHASE 1 - STRATEGY FOUNDATION
===========================================

If STRATEGY.md has confirmed content, load it silently and display:
  Strategy loaded. North Star: [metric]. Building for: [user].

If STRATEGY.md is empty, ask these five questions one at a time:

1. In one sentence what does this product do and who is it for?
2. Who is the ONE user type you are building for above all others?
   (Their situation, frustration, what success looks like)
3. What is the ONE thing you want to be undeniably the best at?
4. What is your North Star metric right now?
   1=Activation 2=Retention 3=Revenue 4=Acquisition
5. What are you deliberately NOT building even if customers ask?
   (Type "unknown" to revisit after research)

Save answers to STRATEGY.md. Display: Strategy saved.

===========================================
PHASE 2 - PRODUCT INTELLIGENCE
===========================================

Read entire codebase. Build complete product inventory.

For every feature: name, what it does, user segment, current state,
usage signals from code (how central), related features.

Identify gaps: partially built, referenced but incomplete, implied
by existing features but missing.

Display inventory for confirmation. Wait for yes/correct.

===========================================
PHASE 3 - COMPETITOR RESEARCH
===========================================

STEP A - IDENTIFY: Web search for direct, indirect, emerging competitors.
Search: "[category] alternatives", "best [category] tools", "[category] vs",
Product Hunt, G2/Capterra categories, Reddit recommendations.
Display and confirm which to research.

STEP B - DEEP ANALYSIS per confirmed competitor:

Read their product: homepage, pricing, features, changelog.
Extract: features, value prop, pricing, target user, recent ships, public roadmap.

Mine reviews with collection targets:
- G2: min 20 reviews (focus 1-3 star)
- Capterra: min 15 reviews
- Product Hunt: min 10 comments
- Reddit: min 15 posts ("[competitor] problems/alternative/switching/cancelled")
- Twitter/X: min 10 posts
- Trustpilot, HN, Indie Hackers, YouTube comments, LinkedIn: min 5 each

Tag every data point: source, date, type (complaint/praise/migration/workaround),
sentiment, behaviour (cancelled/switching/seeking alternative/workaround/staying),
topic, key phrase, confidence (HIGH if behaviour/MEDIUM if sentiment/LOW if opinion).

STEP C - FEATURE GAP EXTRACTION:
GAP TYPE 1: Features customers want that NO competitor has (gold)
GAP TYPE 2: Features customers love in competitors you lack (table stakes risk)
GAP TYPE 3: Features causing customers to LEAVE competitors (acquisition opportunity)

===========================================
PHASE 4 - SIGNAL PROCESSING
===========================================

Apply Pattern and Signal Threshold System.

Minimum 3 instances for any signal (lower than COPYAI for feature requests).
Cross-platform preferred. 8+ single platform acceptable with behaviour signals.

Cluster tagged data into feature clusters. Calculate per cluster:
total instances, platforms, GAP TYPE breakdown, behaviour signals, date range, trend.

Discard below threshold. Save as emerging signals.

===========================================
PHASE 5 - PRISM-PV SCORING
===========================================

Score every cluster above threshold.

P - PAIN SIGNAL STRENGTH (0-6):
6=Very Strong (16+ instances, 3+ platforms, cancellation/migration)
5=Strong (11-15, 2+ platforms, behaviour signal)
4=Moderate-Strong (8-10, 2+ platforms)
3=Moderate (5-7, 2+ platforms OR 8+ single)
2=Weak-Moderate (3-4, cross-platform)
1=Weak (minimum threshold only)

R - REVENUE/RETENTION IMPACT (0-4):
4=Direct churn/conversion impact cited
3=Competitors retain users because of this
2=Absence weakens position, no documented churn
1=Nice to have, no churn language
0=No revenue signal

I - IMPLEMENTATION DIFFICULTY (0-2, inverted):
2=Low effort (days, or third-party integration)
1=Medium effort (weeks)
0=High effort (months, architectural changes)

S - STRATEGIC FIT (0-3):
3=Perfect (primary user, moves North Star, reinforces core, no conflicts)
2=Good (primary user, adjacent to North Star)
1=Partial (secondary user or unclear North Star link)
0=Conflict with STRATEGY.md — flag prominently

M - MARKET DEMAND (0-3):
3=High (own search category, tutorials exist, regular questions)
2=Moderate (comparison searches, some content)
1=Low (niche or emerging)
0=No search signal

PV - PAINKILLER VS VITAMIN (0-2):
Must be earned from behavioural evidence, not assumed.

CRITICAL PAINKILLER (2): Multiple behaviour consequences. MUST BUILD.
STRONG PAINKILLER (2): At least one behaviour consequence. HIGH PRIORITY.
HYBRID (1): Painkiller for some segments. TARGETED BUILD.
STRONG VITAMIN (1): No behaviour consequences but strong appreciation. RETENTION BUILDER.
PURE VITAMIN (0): Nice to have. NICE TO HAVE.

MODIFIERS:
+3 Addresses documented friction (feature resolves a friction point
   in EMPATHY.md — validated UX pain)
+3 Window Opening (regulation, competitor removed feature, new API, strong trend)
+2 Window Closing (competitors converging, add urgency flag)
+2 Strong Moat (defensible, unique data, deep integration)
+2 North Star Mover (directly moves stated metric)
+2 Build vs Buy Shortcut (third-party delivers in days)
+2 Word of Mouth Potential (shareable, demo-worthy)
-2 High Maintenance Cost (ongoing burden based on competitor experience)
-3 Weak Moat + Low Signal (easily copied AND score below 10)
-5 Strategic Conflict (contradicts STRATEGY.md — show prominently)

SCORE CLASSIFICATION:
20-25: BUILD IMMEDIATELY
15-19: BUILD NEXT SPRINT
10-14: BUILD NEXT QUARTER
6-9: VALIDATE BEFORE BUILDING
Below 6: WATCH LIST

PAINKILLER URGENCY:
ACUTE (daily pain, large user portion) → ACT NOW
GROWING (increasing over time) → SCHEDULE URGENTLY
LATENT (acceptable workarounds exist) → Standard scheduling
TRIGGERED (specific user stages) → STAGE GATE BUILD

===========================================
PHASE 6 - CONFLICT CHECKS
===========================================

For every feature above threshold:
- Duplication: already exists? → IMPROVE EXISTING
- Cannibalisation: makes paid feature redundant? → flag prominently
- Roadmap conflict: related feature planned? → COMBINE WITH [name]
- Strategic conflict: contradicts STRATEGY.md? → -5 and ask user
- Build vs buy: third-party option? → note with integration time estimate

===========================================
PHASE 7 - VALIDATION RECOMMENDATIONS
===========================================

For features scoring 6-9, recommend specific validation:
A. Fake door test (button → coming soon, measure clicks)
B. Survey (one targeted question, 40%+ "must answer" = build)
C. Manual delivery (offer to 5-10 users before automating)
D. Wait for more signal (set threshold, revisit in 30 days)

===========================================
PHASE 8 - THE ROADMAP (four views)
===========================================

VIEW 1 - RANKED BY SCORE: Each feature with full PRISM-PV breakdown,
PV status, urgency, gap type, evidence count, trend, key quote,
build vs buy, moat, North Star link, conflicts.

VIEW 2 - EFFORT VS IMPACT MATRIX:
High Impact/Low Effort (quick wins) | High Impact/High Effort (strategic bets)
Low Impact/Low Effort (fill in later) | Low Impact/High Effort (avoid)

VIEW 3 - TIME HORIZON: Now (2 weeks) / Next (1-3 months) / Later (3-6 months) / Validate

VIEW 4 - PAINKILLER VS VITAMIN: Critical → Strong → Hybrid → Strong Vitamin → Pure Vitamin

===========================================
PHASE 9 - THE ANTI-ROADMAP
===========================================

NOT NOW: Below threshold, note signal and revisit condition.
NEVER BUILD: Strategic conflict, note demand and decline reason.
WINDOW CLOSED: Table stakes, build for hygiene not differentiation.
WATCH LIST: Emerging signal, note elevation criteria.

===========================================
PHASE 10 - EXISTING FEATURE AUDIT
===========================================

Score every current feature on usage value and strategic value.
Classify: Double Down / Maintain / Question / Remove.

===========================================
PHASE 11 - HTML REPORT
===========================================

Generate $COMPASS_REPORT. Open in Chrome.

Sections:
1. Executive summary (half page, top 3 opportunities, top risk)
2. Market opportunity map
3. Feature opportunity cards (PRISM-PV scores, PV badges, evidence, trend)
4. Ranked roadmap (all four views)
5. Competitive intelligence (per competitor with quotes)
6. Existing feature audit
7. Anti-roadmap
8. Evidence wall (all quotes by theme)
9. Sources and methodology
10. What to do this week (3 specific actions)

===========================================
PHASE 12 - SAVE TO MEMORY
===========================================

Save to $ATLAS/COMPASS.md:
Strategy summary, research summary, ranked roadmap, full feature database
with PRISM-PV breakdowns, anti-roadmap, existing feature audit, pattern
evidence, sources, changelog of COMPASS runs.

Update HEALTH.md: last COMPASS run, features identified, top opportunity, critical painkillers found.

===========================================
PHASE 13 - ATLAS INTEGRATION
===========================================

Empathy check: if EMPATHY.md shows the journey this feature sits in has
multiple friction points already, flag that fixing existing friction may
be more valuable than adding the new feature.

Atlas: include top roadmap item (score 15+) in recommendations.
Atlas-feature: update COMPASS.md when roadmap feature is completed.
Test-deep: flag features in "question" or "remove" category.
Design: flag design for features not yet validated.
COPYAI: highest pain patterns inform primary copy message.
