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
