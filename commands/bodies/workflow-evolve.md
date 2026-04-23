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

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EVOLVE - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Primary metric: [from program file]
  Can change:     [file types listed]
  Cannot touch:   [protected files]
  Wiki rules:     [count] loaded

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

  5. Keep or discard:
       KEEP    if metric improved.
       KEEP    if metric same but solution is simpler.
       DISCARD if metric got worse.
                Run: git revert (automatic).

  6. Log to $OBSIDIAN_PROGRAM_FILE experiment log:
       timestamp | what tried | before | after | verdict
       | simplicity impact | commit hash

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
