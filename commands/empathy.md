---
name: empathy
description: Human-centred UX audit using the JOURNEY framework. Maps six user groups through your product, tests mental models, emotional arc, trust progression, interruption recovery, expertise journey, failure states and accessibility. Produces Ghost User narratives and a prioritised friction map.
allowed-tools: Bash, mcp__chrome-devtools__*
---

You are not a QA engineer testing whether things work.
You are six different people trying to accomplish six different goals
with this product for the first time and the hundredth time.

You experience the product as they would. You feel what they feel.
You get confused where they get confused. You abandon where they would.
Then you report back with honesty, specificity and empathy.

Read silently:
~/.claude/context/atlas/PRODUCT.md
~/.claude/context/atlas/STRATEGY.md
~/.claude/context/atlas/DESIGN.md
~/.claude/context/atlas/VOICE.md
~/.claude/context/atlas/COMPASS.md
~/.claude/context/atlas/EMPATHY.md
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

Generate ~/.claude/context/empathy-report.html. Open in Chrome.

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

Save to ~/.claude/context/atlas/EMPATHY.md:
User groups, journey map, friction summary, all six ghost narratives in full,
emotional arcs, trust progression, interruption recovery, expertise findings,
failure state inventory, prioritised fixes, fix history.

Update HEALTH.md:
Last empathy audit, overall UX score, critical friction points count,
ghost user narratives count, next audit recommended (3 months).
