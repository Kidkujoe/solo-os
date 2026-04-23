---
name: workflow-brief
description: BRIEF workflow - start of day focus. One step, zero approvals. Reads project state silently and surfaces one clear recommendation. Estimated ~500-1,000 tokens.
allowed-tools: Bash
---

You are the BRIEF workflow. One step. Zero approvals. Under one
minute. Output: one clear recommendation for what to focus on today.

ESTIMATED COST: ~500 - 1,000 tokens.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BRIEF
  Estimated: ~500 - 1,000 tokens
  Session so far: ~[count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 1 OF 1 - MORNING BRIEFING
===========================================

Read silently:

  $HEALTH_MD              — health score
  $PROJECT_CONTEXT/REVIEWS.md — open reviews / branches
  Run: git status --porcelain — uncommitted changes
  Wiki state (if OBSIDIAN_BRIDGE=on):
    $OBSIDIAN_VAULT/wiki/log.md       — last ingest
    Files in $OBSIDIAN_RAW not in log.md — unprocessed sources
  Experiment state (if OBSIDIAN_BRIDGE=on):
    $OBSIDIAN_PROGRAM_FILE — last EVOLVE run

  Feedback-loop state (v3.1.0, if OBSIDIAN_BRIDGE=on):
    $OBSIDIAN_LESSONS_FILE — last 30 days of entries
    $SKIP_TRACKER          — pending_question / deferred_monthly items
    EVOLVE experiment log  — KEEP entries aged >=14 days with no
                             follow-up recorded
    MARKET recommendations — priority-1 entries aged >=8 weeks with
                             no follow-up recorded

From these, determine:
  - Which outcome follow-ups are due today (EVOLVE 14d, MARKET 8w).
  - Which deferred items hit their monthly reminder this week.
  - Which findings have status=pending_question in skip-tracker.
  - Which lessons from the last 7 days are most relevant to today's
    focus.

Full protocol: ~/solo-os/docs/FEEDBACK_LOOP.md

Synthesise into one focused output. Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BRIEF - [day] [date]
  Project: [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Health:          [score]/10
  Open reviews:    [count]
  Uncommitted:     [count] change(s)
  Wiki sources:    [count] unprocessed
  Last EVOLVE:     [X] days ago

  NEEDS ATTENTION:
  [Only show items that need action. If nothing needs attention,
   write: Everything is clean.]

  [If any branch is READY TO MERGE]
  [branch] is ready to merge.

  [If any feature changed since its last audit]
  [feature] needs an audit.

  [If unprocessed wiki sources exist]
  [count] source(s) waiting in raw/

  [If a hypothesis is logged for retro]
  [count] hypothesis(es) ready for MARKET retro.

  [If any EVOLVE KEEP entries aged >=14d have no follow-up OR any
   MARKET priority-1 entries aged >=8w have no follow-up]
  FOLLOW-UPS NEEDED:
  [count] experiments need outcome feedback. Takes 30 seconds.
  Type f to answer now or skip.

  [If skip-tracker has deferred_monthly items due this week]
  DEFERRED ITEMS DUE:
  [rule] - deferred [X] days ago
  Type d to review or skip.

  [If skip-tracker has status=pending_question entries]
  SKIP PATTERNS DETECTED:
  [count] findings skipped 3+ times
  Type s to resolve or skip.

  [If relevant lessons exist from the last 7 days]
  RECENT LESSONS:
  [most relevant lesson in one line]
  [link: $OBSIDIAN_LESSONS_FILE]

  FOCUS TODAY:
  [Single clear recommendation based on everything read above.
  ONE thing. Not a list.]

  Type /explore to start working on it.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The session ends here. The user runs /explore again to act on the
recommendation.

===========================================
INTERACTIVE FOLLOW-UP HANDLERS (v3.1.0+)
===========================================

If the user types f / d / s in response to the briefing, drive the
corresponding protocol defined in ~/solo-os/docs/FEEDBACK_LOOP.md:

  f - Outcome follow-ups
      For each due EVOLVE KEEP: show the 4-option EVOLVE FOLLOW-UP
      block. For each due MARKET priority-1: show the 6-option
      MARKET FOLLOW-UP block. Wait for one keystroke per question.
      Write results to $OBSIDIAN_LESSONS_FILE under
      "## Outcome follow-ups" and apply confidence updates to the
      relevant wiki page frontmatter per the protocol.

  d - Deferred items
      For each deferred_monthly item due this week, ask:
      "Still want to fix this? yes / no". On yes: add to today's
      focus and set skip-tracker status=pending. On no: roll the
      defer date forward by 30 days.

  s - Skip patterns
      For each pending_question skip, show the 5-option skip
      question from the protocol. Apply the answer's resolution
      action: wiki frontmatter update, DECISIONS_FILE append,
      lessons file append, or skip_count reset per the protocol.

After any interactive block, write a one-line summary to the
lessons file and return the user to the BRIEF display.
