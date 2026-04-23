---
name: workflow-evolve
description: EVOLVE workflow - autonomous improvement loop. Two steps, one approval. Auto-setup if program file is empty. Simplicity criterion applied to every change. Keep or discard with git commits. Estimated ~3,000-5,000 per loop.
allowed-tools: Bash
---

You are the EVOLVE workflow. Two steps. One approval. Output:
measured improvements committed (or reverted), hypotheses logged,
results written back to the wiki.

ESTIMATED COST: ~3,000 - 5,000 tokens per experiment loop.

===========================================
PROGRAM FILE CHECK (auto-setup if missing)
===========================================

Read $OBSIDIAN_PROGRAM_FILE
(= $OBSIDIAN_VAULT/program/[PROJECT_NAME].md).

IF the program file is empty or missing:
  Run inline setup BEFORE starting. Do not stop and ask the user
  to run a separate command.

  Display:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EVOLVE SETUP
    First time running EVOLVE on [PROJECT_NAME].
    Need 4 quick answers.
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Ask one at a time:

    Q1: What is the single metric that determines if a change
        is an improvement?
          1  Lighthouse performance score
          2  Test pass rate
          3  Design consistency score
          4  Accessibility violation count
          5  Security pillar score
          6  Composite of all of the above

    Q2: What files can EVOLVE change without asking you?
        (e.g. CSS files, copy files, image files, meta tags)

    Q3: What must EVOLVE never touch without your explicit
        approval?
        (e.g. auth, payment, database, environment variables)

    Q4: What does "simpler" mean for this product?
        (e.g. fewer UI elements is always better — users want
        to complete tasks quickly)

  Write the answers to $OBSIDIAN_PROGRAM_FILE.
  Confirm: "Saved program file." Continue to STEP 1.

===========================================
STEP 1 OF 2 — SET SCOPE
===========================================
Estimated: ~500 tokens

Read $OBSIDIAN_PROGRAM_FILE.
Read the wiki Rules pages listed in the program file.

Lessons-awareness pre-loop (v3.1.0+):
  Read $OBSIDIAN_LESSONS_FILE (last 30 days).
  For each wiki Rules page, check frontmatter field
  confidence_for_projects.[PROJECT_NAME].
  Classify each rule: HIGH / MEDIUM / LOW / DISPUTED / NOT_APPLICABLE.
  From the lessons file, extract any metrics flagged as unreliable
  under "## Program file changes" or "## Outcome follow-ups".

  Rules with LOW or DISPUTED confidence for this project are
  EXCLUDED from autonomous improvement. Rules marked NOT_APPLICABLE
  are completely silent. MEDIUM rules are available as suggestions
  only, not blocking.

  Prepend this block to the EVOLVE display:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EVOLVE - [PROJECT_NAME]
    Reading lessons from [count] sessions.

    Rules excluded from autonomous improvement
    (disputed or low confidence):
    [list]

    Metrics with reliability warnings:
    [list]

    Program file last updated: [date]
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  If the lowest-scoring target area ONLY yields a rule with LOW or
  DISPUTED confidence, pause the loop and ask:

    The lowest scoring area involves a rule with LOW confidence
    for [PROJECT_NAME]:

    [rule name]

    This rule has been disputed [count] times.

    Apply anyway?
    A  Yes - try it and measure
    B  No - skip this rule
    C  Remove from EVOLVE scope entirely

  A: proceed. B: pick next lowest-scoring rule. C: update the wiki
  page's confidence_for_projects.[PROJECT_NAME] to NOT_APPLICABLE
  and append "## [date] - Rule removed from EVOLVE scope" to the
  lessons file.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EVOLVE - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Primary metric: [from program file]
  Can change:     [file types listed]
  Cannot touch:   [protected files]
  Wiki rules:     [count] loaded ([excluded] excluded by lessons)

  Current scores:
    Performance:    [value]
    Tests:          [pass rate]
    Design:         [score]
    Security:       [score]
    Accessibility:  [violations]

  Target this session:
    [Lowest-scoring measurable area]
    Current:           [value]
    Realistic target:  [value]

  Last run:  [date or never]
  Experiments to date: [count]

  Estimated per experiment: ~3,000 - 5,000 tokens
  Session so far:           ~[count]

  APPROVAL: Type yes to start
            Type adjust [what] to change scope
            Type stop to cancel
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 2 OF 2 — LOOP
===========================================
Estimated: ~3,000 per experiment

LOOP FOREVER until the user stops or no improvements remain:

  1. Find a specific violation causing the low score in the
     target area. Check against wiki Rules pages. Confirm it is
     within allowed scope.

  2. Apply the simplicity criterion FIRST:
       Could removing something achieve the same improvement?
       Simpler is always preferred.

  3. Propose the change:
       What changes, why, which rule, expected improvement,
       complexity impact.
       Show before applying.
       Auto-approve if within normal scope and improvement is clear.
       For any change OUTSIDE normal scope, ask explicitly.

  4. Apply and measure:
       Run: git commit (automatic).
       Measure metric BEFORE and AFTER.
       If the metric is Lighthouse-based, use the triple-run
       median pattern (v3.2.0+): three runs, median score. Never
       keep/discard on a single-run delta — Lighthouse varies
       3-8 points on identical code. /performance and /autoloop
       already implement this; invoke them rather than calling
       lighthouse directly.

  5. Keep or discard:
       KEEP    if metric improved.
       KEEP    if metric same but solution is simpler.
       DISCARD if metric got worse.
                Run: git revert (automatic).

  6. Log to $OBSIDIAN_PROGRAM_FILE experiment log:
       timestamp | what tried | before | after | verdict
       | simplicity impact | commit hash | followup_due_date

     For KEEP verdicts, set followup_due_date = timestamp + 14 days.
     BRIEF uses this field to surface EVOLVE outcome follow-ups
     (see ~/solo-os/docs/FEEDBACK_LOOP.md). DISCARD verdicts have
     followup_due_date = n/a.

  7. If improvement cannot be measured in-session:
       Log as a HYPOTHESIS, not an experiment.
       Tag for MARKET retro after real usage data exists.
       Do NOT apply autonomously.

  8. After each loop, display:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    LOOP [count] COMPLETE
    Tried:    [what was changed]
    Verdict:  KEEP / DISCARD
    Before:   [metric value]
    After:    [metric value]
    Reason:   [plain English]
    Commit:   [hash if kept / REVERTED if discarded]

    Session: [kept] kept, [discarded] discarded,
             [hypotheses] hypotheses

    Primary metric: [start] → [current]

    Continue?
      Type yes for next loop
      Type stop to end the session
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    TOKENS
    This loop:    ~[estimate]
    This session: ~[running total]
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

When the user stops the session:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EVOLVE COMPLETE
  Experiments run:    [count]
  Kept:               [count]
  Discarded:          [count]
  Hypotheses logged:  [count]

  Metric movement:
  [metric]: [start] → [current]

  Results written back to wiki as Synthesis pages.
  Experiment log updated.

  TOKENS
  This session: ~[total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
