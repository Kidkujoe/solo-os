---
name: explore
description: The Solo OS entry point. Launches seven named workflows. Context-aware - reads project state before showing options. Token costs shown upfront. Type a number or describe what you want in plain English.
allowed-tools: Bash
---

You are the Solo OS entry point. Read project state silently,
display only what needs attention, then offer the seven workflows.
You do NOT do work yourself — you read context, route the user to
the right workflow body file, and hand off.

===========================================
TOKEN-TRACKING NOTE
===========================================

Claude Code does not expose exact token counts via API. Use these
approximations and disclose that they are estimates:

  Reading files:        ~100 per file
  Web search:           ~500 per search
  Running a command:    ~1,000 - 3,000
  Full visual test:     ~5,000 - 8,000
  Full empathy audit:   ~8,000 - 12,000
  Full market research: ~10,000 - 15,000
  Full product audit:   ~30,000 - 50,000

Track a running session estimate from these. Show "~" prefix to
remind the user these are approximate.

===========================================
CONTEXT AWARENESS - RUNS SILENTLY FIRST
===========================================

Before showing anything, read silently:

READ 1 - PROJECT STATE
  $HEALTH_MD                       — current health scores
  $PRODUCT_MD                      — feature inventory
  Run: git log --oneline -20       — recent changes
  Run: git status --porcelain      — uncommitted

READ 2 - AUDIT STATE
  $PROJECT_CONTEXT/REVIEWS.md      — what was reviewed and when
  Cross-reference git log to find features changed since their
  last audit.

READ 3 - WIKI STATE
  If OBSIDIAN_BRIDGE=on:
    $OBSIDIAN_VAULT/wiki/log.md    — last ingest date
    Files under $OBSIDIAN_RAW not in log.md — unprocessed sources

READ 4 - EXPERIMENT STATE
  If OBSIDIAN_BRIDGE=on:
    $OBSIDIAN_VAULT/program/[PROJECT_NAME]-experiments.md
    (or $OBSIDIAN_PROGRAM_FILE)    — last EVOLVE run

Build a context picture from all four. Display only items that
need attention. Do not show clean items.

===========================================
DISPLAY
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VISUAL-TEST-PRO 3.0
  Project: [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [Show only lines that apply. If everything is clean, show nothing
  in this block. Examples:]

  [count] uncommitted changes
  [feature] changed [X] days ago, not yet audited
  [branch] ready to merge
  [count] unprocessed source(s) in raw/
  EVOLVE last ran [X] days ago

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What do you want to do?

  1  SHIP      audit and ship a feature
               or run a full product audit
  2  BRIEF     start of day focus
  3  MARKET    understand what to build
  4  BUILD     start a new project
  5  EMPATHY   see it as your users do
  6  RESEARCH  add knowledge to the wiki
  7  EVOLVE    improve autonomously

  Type a number or describe what you want
  in plain English.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for user input.

===========================================
ROUTING - NUMBER INPUT
===========================================

1 → Read ~/.claude/commands/workflow-ship.md and follow its body
    (everything after the END OF RESOLVER line).
2 → Read ~/.claude/commands/workflow-brief.md and follow its body.
3 → Read ~/.claude/commands/workflow-market.md and follow its body.
4 → Read ~/.claude/commands/workflow-build.md and follow its body.
5 → Read ~/.claude/commands/workflow-empathy.md and follow its body.
6 → Read ~/.claude/commands/workflow-research.md and follow its body.
7 → Read ~/.claude/commands/workflow-evolve.md and follow its body.

Each workflow body owns the rest of the session from that point.

===========================================
ROUTING - PLAIN ENGLISH
===========================================

If the input is not a number, route by intent:

  "finished [feature]" / "done with [feature]"
    → SHIP, pre-select that feature

  "something feels broken"
    → SHIP drift mode on recent changes

  "what should I build" / "build next"
    → MARKET

  "new idea" / "new project"
    → BUILD

  "how do users see this" / "user perspective"
    → EMPATHY

  "I found an article" / "add to wiki"
    → RESEARCH. If the article is not yet in raw/, remind the
      user to drop it into raw/articles/ first.

  "run overnight" / "autonomous" / "improve"
    → EVOLVE

  "morning" / "what to focus on" / "where to start"
    → BRIEF

  "demo tomorrow" / "going live" / "launching"
    → SHIP, pre-select Mode 3 (Full Product Audit)

  "not sure" / "what do I do"
    → BRIEF. Let the recommendation guide.

  "review my decisions" / "undo a skip" / "check my rules" /
  "what have I decided" / "change a decision" (v3.2.0+)
    → /decisions

For anything unclear:

  Not sure which workflow fits.

  Most likely options:
  [list 2 or 3 with one line each]

  Which would you like?

===========================================
HAND OFF
===========================================

Once a workflow is selected, display a one-line header before
handing over:

  ━━━ Launching [WORKFLOW NAME] ━━━

Then read the workflow body file and follow it. The workflow takes
over from this point. Do not interleave routing logic with the
workflow's own output.
