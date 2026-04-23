---
name: empathy
description: Human-centred UX audit using the JOURNEY framework. Maps six user groups through your product, tests mental models, emotional arc, trust progression, interruption recovery, expertise journey, failure states and accessibility. Produces Ghost User narratives and a prioritised friction map.
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
KNOWLEDGE BRIDGE HOOKS (v2.3.0)
===========================================

If OBSIDIAN_BRIDGE=on (STEP R8):

At the start — call read_customer_context from RESOLVER.md §
KNOWLEDGE_BRIDGE. Surface which of the six groups already have
insights and which are gaps. Avoid re-researching what is already
documented; focus this run on the gaps.

After each ghost-user test — for every significant friction point
call write_user_insight_note with user_group set to the specific group
(First-time user, Returning user, Power user, etc) and exact quotes in
what_users_said.

After emotional arc mapped — call write_insight_note with
source="empathy" summarising the dominant emotional trajectory and
its implication for the product.

If a bridge call fails do not abort the command — log and continue.
===========================================

You are not a QA engineer testing whether things work.
You are six different people trying to accomplish six different goals
with this product for the first time and the hundredth time.

You experience the product as they would. You feel what they feel.
You get confused where they get confused. You abandon where they would.
Then you report back with honesty, specificity and empathy.

Read silently:
$PRODUCT_MD
$STRATEGY_MD
$DESIGN_MD
$VOICE_MD
$ATLAS/COMPASS.md
$ATLAS/EMPATHY.md
CLAUDE.md in the project root

$ARGUMENTS can specify a user group, journey or feature. If empty, full audit.

===========================================
PHASE 0 - JOURNEY MAP
===========================================

Read the entire codebase focusing on every user-facing flow, screen,
navigation pattern, empty state, error message, onboarding sequence,
success state, loading state, form, modal, notification.

Map every journey, decision point, friction risk.

Display JOURNEY MAP. Confirm completeness with user.

===========================================
PHASE 1 - SIX USER GROUPS
===========================================

Derive six specific user groups from STRATEGY.md (not generic personas).

For each: name (specific to this product), situation, immediate goal,
underlying goal, life goal, mental model (3 products shaping expectations),
emotional state, biggest anxiety, what makes them stay/leave (first 10s),
trust rung.

GROUP 1 - FIRST-TIME VISITOR: Rung 1, no trust given yet
GROUP 2 - NEW USER: Rung 3, gave effort trust, needs confirmation
GROUP 3 - RETURNING USER: Rung 4, building habit trust
GROUP 4 - STRUGGLING USER: Rung 3-4, declining, dangerous zone
GROUP 5 - POWER USER: Rung 4-5, high trust + high demands
GROUP 6 - EVALUATOR: Rung 1-2, deciding whether to commit

Display all six. Confirm with user. Save to EMPATHY.md.

===========================================
PHASE 2 - MENTAL MODEL MAPPING
===========================================

STEP A - Product model: how the product actually works.
STEP B - User model: how each group expects it to work based on prior apps.
STEP C - Gap analysis: every point where models diverge.

For each gap: user group affected, expectation, reality, severity
(CRITICAL/HIGH/MEDIUM/LOW), example from similar product, resolution
(change product / change signposting / onboard to different model).

===========================================
PHASE 3 - GHOST USER TESTS
===========================================

For each group, connect to Chrome and open the product as that user
for the first time. Apply constraints absolutely:
- Only use what's visible
- Don't use codebase knowledge or dev tools
- When confused, document it, don't solve with technical knowledge
- Document search process when things aren't where expected

For each journey step record:
- What the user sees (screenshot + description)
- What they think (first-person internal monologue in their voice)
- What they do (action + why)
- Friction level: INVISIBLE / MICRO / PAUSE / BACKTRACK / ABANDON RISK / ABANDON POINT
- Cognitive load: LOW / MEDIUM / HIGH / OVERLOAD
- Emotional state: specific emotion (Hopeful / Uncertain / Frustrated etc.)
- Anticipation check: did the product anticipate their need? YES / PARTIAL / NO

After each journey, write the full GHOST USER NARRATIVE in first-person
continuous prose (not bullet points). Story format, like describing the
experience to a friend. Honest, specific, vivid. Opening should reference
how they arrived and their mental model. End with "By the end I felt X
and I would/would not come back because Y."

Screenshots at: initial state, first decision, first friction, first
success/failure, end state.

===========================================
PHASE 4 - JOURNEY FRAMEWORK AUDIT
===========================================

Apply seven JOURNEY dimensions to each ghost user test:

J - JOB TO BE DONE CLARITY: Is primary action obvious in 3 seconds?
    Rate each screen: CLEAR / AMBIGUOUS / CONFUSING

O - ORIENTATION: Does user know where they are, how they got here,
    how to go back, progress in multi-step flows?
    Rate: ORIENTED / PARTIAL / LOST

U - UNCERTAINTY MOMENTS: Every moment user has to guess. Duration,
    available information, why it's not visible.
    Rate: MINOR / SIGNIFICANT / BLOCKING

R - RECOVERY FROM MISTAKES: Deliberately test invalid form submits,
    wrong nav, permission errors, accidental modal close, abandoned flows.
    Rate: EXCELLENT / ADEQUATE / POOR / BROKEN

N - NAVIGATION LOGIC: Find 10 things (3 easy, 4 moderate, 3 hidden).
    Clicks per find, wrong paths, items not findable.

E - EXPECTATION MATCHING: Every interactive element — does outcome
    match the expectation its label/appearance/position created?
    Rate: MATCHES / PARTIAL / MISMATCH

Y - YOUR NEXT STEP CLARITY: After every action, is there ONE obvious
    thing to do next? Empty = danger. Too many = paralysis.
    Rate: CLEAR / AMBIGUOUS / MISSING

===========================================
PHASE 5 - EMOTIONAL ARC
===========================================

For each group plot emotional arc through primary journey:
- Arrival emotion
- First friction (when it dips, what caused it)
- First recovery (what restored it)
- First success (specific moment, timing — is it soon enough?)
- Doubt moment (when they question continuing)
- Commitment moment (when they decide this is for them — if it never
  occurs that is the most important finding)

Display as text-based arc with labelled moments.

===========================================
PHASE 6 - TRUST PROGRESSION AUDIT
===========================================

Test whether each rung is solid enough to climb to the next:
- Rung 1 ATTENTION (Group 1, 6): product understood in 10s?
- Rung 2 INFORMATION (Group 1, 6): signup decision supported, social proof?
- Rung 3 EFFORT (Group 2): onboarding worth the effort? Value before more effort?
- Rung 4 HABIT (Group 3): reason to return tomorrow? Part of routine?
- Rung 5 PAYMENT (Group 3, 5): value clear? Honest pricing? Easy cancellation?
- Rung 6 ADVOCACY (Group 5): would they show this to someone they respect?

For each: SOLID / SHAKY / BROKEN, what's working, what undermines trust,
risk if not fixed, specific fix recommendation.

===========================================
PHASE 7 - INTERRUPTION RECOVERY
===========================================

Five scenarios:
1. Mid-onboarding interruption (close browser, return — does it resume?)
2. Mid-task interruption (navigate away with unsaved work — preserved?)
3. Session timeout (where redirects? Work preserved?)
4. Device context switch (mobile → desktop — continuous feel?)
5. Re-engagement after absence (clear cookies, log in — remembers them?)

Rate each: SEAMLESS / MANAGEABLE / FRUSTRATING / BROKEN / WORK LOST

===========================================
PHASE 8 - EXPERTISE JOURNEY
===========================================

BEGINNER: every element discoverable without instruction? Language jargon-free?
Guidance where stuck? Core task without external help?

INTERMEDIATE: keyboard shortcuts? Skip repeated steps? Customise defaults?
Persistent preferences?

POWER USER: bulk actions? API/export? Integrations? Advanced config?

Rate each level: served well / partially / no. What works, what fails,
what risk does unmet need create, specific recommendation.

===========================================
PHASE 9 - SOCIAL CONTEXT
===========================================

- Sharing moment: first impression to non-user, professional, comprehensible?
- Collaboration: easy to share with someone new, clear shared state?
- Reporting: export look professional, comfortable to send to client?
- Recommendation: can you demo core value in 2 minutes to a sceptical friend?

===========================================
PHASE 10 - FAILURE STATE AUDIT
===========================================

USER ERROR STATES: near cause, plain English, fix instructions,
input preserved, appropriate tone, no blame.

SYSTEM ERROR STATES: takes responsibility, tells next step, reporting path,
retry without work loss.

EMPTY STATES: explains why empty, what appears here, one clear action,
inviting tone, feels like opportunity.

BLOCKED STATES: why blocked, how to unblock, communicated BEFORE effort invested.

LOADING STATES: shows it's working, realistic time, let user do other things,
communication if taking longer.

Rate each: BROKEN / POOR / ADEQUATE / GOOD

===========================================
PHASE 11 - PROGRESS AND MOMENTUM
===========================================

PROGRESS SIGNALS: completion indication, saving feels satisfying, visible
history, small wins acknowledged, streaks/scores/counts.

MOMENTUM BUILDERS: after task A, natural path to task B? Logical next step
suggested? Finishing feels like beginning not ending?

SUNK COST ACKNOWLEDGEMENT: after significant use, can user see what they've
created? Value of history visible? Clear sense of what leaving behind?

===========================================
PHASE 12 - ACCESSIBILITY AS UX
===========================================

KEYBOARD: close mouse. Tab order logical? Focus visible? Every action
completable? No keyboard traps?

SCREEN READER SIMULATION: content makes sense in document order? All
interactive elements labelled? Images described? State changes announced?
Page title descriptive?

COGNITIVE LOAD: test under stress (distracted, high-stakes, hurry).
Simple enough? Chunked clearly? Visual hierarchy strong? Important elements
visually dominant?

MOTOR: at 375px, every interactive element 44px+ tall? Spaced to prevent
accidental taps?

COLOUR: contrast ratios, anything relying on colour alone, works in
high contrast mode?

===========================================
PHASE 13 - FRICTION MAP
===========================================

Compile all findings. Organise by:
- User group (every friction point per group)
- Friction level (Abandon Points → Abandon Risks → Backtrack → Pause → Micro)
- Journey stage (early friction most damaging)
- JOURNEY dimension (which of J/O/U/R/N/E/Y scores worst)

Display complete friction map with counts per severity, most affected group,
most friction-heavy stage, most problematic dimension.

===========================================
PHASE 14 - PRIORITISED FIXES
===========================================

Priority determined by: friction severity, groups affected, journey stage
(earlier = higher), trust progression impact.

CRITICAL (THIS WEEK): Abandon points, Rung 1-2 issues
HIGH (THIS SPRINT): Abandon risks, Rung 3-4 issues
MEDIUM (THIS QUARTER): Backtrack points
LOW (WHEN CAPACITY ALLOWS): Pause and micro friction

Each fix: what (plain English), where (exact location), who it helps
(user groups), effort (hours estimate), expected impact.

===========================================
PHASE 15 - HTML REPORT
===========================================

Generate $EMPATHY_REPORT. Open in Chrome.

The goal: make UX problems viscerally real. A founder or investor reading
should feel the user experience problems not just understand them.

Sections:
1. Dashboard (card per user group: journey score, friction counts,
   trust rung reached, emotional arc summary, narrative excerpt)
2. GHOST USER STORIES — most important section. Full narratives in
   readable prose. Not lists. Screenshots embedded at key moments.
   Large pull quotes for most powerful moments.
3. Emotional arc visualisation per group with colour coding
4. Friction map — journey stages × user groups grid, colour coded severity
5. Trust progression ladder with rung states
6. Failure state gallery with screenshots
7. Expertise spectrum (radar or progress bars)
8. Interruption recovery scorecard
9. Prioritised fixes list for development team
10. What to fix this week (max 5 actions, plain English)

Style: clean reading-focused, large typography for narratives, generous
white space, screenshots at relevant points. Red=abandon/broken, orange=
high friction, amber=medium, green=working well. Feels like high-quality
UX research document, not a developer tool output.

===========================================
PHASE 16 - SAVE TO MEMORY
===========================================

Save to $ATLAS/EMPATHY.md:
User groups, journey map, friction summary, all six ghost narratives in full,
emotional arcs, trust progression, interruption recovery, expertise findings,
failure state inventory, prioritised fixes, fix history.

Update HEALTH.md:
Last empathy audit, overall UX score, critical friction points count,
ghost user narratives count, next audit recommended (3 months).
