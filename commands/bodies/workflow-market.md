---
name: workflow-market
description: MARKET workflow - understand your market and build a ranked product roadmap with evidence. Three steps, two approvals. PRISM-PV scoring. Estimated ~10,000-15,000 tokens.
allowed-tools: Bash, mcp__chrome-devtools__*
---

You are the MARKET workflow. Three steps. Two approvals. Output:
a ranked product roadmap with evidence and an anti-roadmap.

ESTIMATED COST: ~10,000 - 15,000 tokens.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MARKET
  Estimated: ~10,000 - 15,000 tokens
  Session so far: ~[count]
  Continue? Type yes to proceed or stop to cancel.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for confirmation.

===========================================
STEP 1 OF 3 — WHAT WE ALREADY KNOW
===========================================
Estimated: ~1,000 tokens

Read silently:
  $OBSIDIAN_VAULT/wiki/index.md
  Every Competitor-*.md page in wiki/
  Every Concept-*.md page about customer pain points
  $COMPASS_FILE if it exists

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MARKET - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Existing wiki intelligence:
    Competitors tracked: [count]
    Customer concepts:   [count]
    Last MARKET run:     [date or never]

  Known competitors:
  [list from wiki, one per line]

  What should I research next?

    A  All competitors fresh research
    B  Specific competitor: [user names them]
    C  New competitors only (skip ones already tracked)
    D  Customer pain signals only
    E  Everything from scratch

  APPROVAL: Choose research scope (A-E)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for selection.

===========================================
STEP 2 OF 3 — RESEARCH
===========================================
Estimated: ~8,000 - 12,000 tokens

Based on the approved scope, run the research pipeline.

MINE THESE SOURCES:
  Reddit threads about the problem space
  G2 and Capterra competitor reviews
  Product Hunt comments
  Twitter and Hacker News discussions
  App-store reviews if relevant

FOR EACH COMPETITOR:
  Extract what customers love.
  Extract what customers hate.
  Extract migration triggers.
  Extract feature requests.
  Update the wiki Competitor page automatically (write_competitor_note).

SCORE EVERY OPPORTUNITY (PRISM-PV):
  P  Pain signal strength
  R  Revenue and retention impact
  I  Implementation difficulty
  S  Strategic fit
  M  Market demand
  PV Painkiller vs Vitamin classification

Show progress as it runs:

  Researching Reddit...     done
  Researching G2...         done
  Researching Capterra...   done
  Scoring opportunities...  done

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STEP 2 COMPLETE
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 3 OF 3 — ROADMAP
===========================================
Estimated: ~1,000 tokens

Present the ranked opportunities:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  YOUR PRODUCT ROADMAP
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUILD THESE:

    1. [Feature name]
       Score: [PRISM-PV score]
       Type: [Painkiller / Vitamin]
       Evidence: [source count] sources
       Why: [one-sentence rationale]

    2. [Feature name]
       [same format]

    3. [Feature name]
       [same format]

  DO NOT BUILD:
    [Features researched but scored low]
    [One-line reason each]

  APPROVAL: Confirm top priority.
    Type the number to confirm
    Type adjust to change anything
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After approval:
  Save to $COMPASS_FILE.
  Update wiki with findings.
  Update Obsidian Research/ folder (write_competitor_note,
  write_insight_note, write_feature_note).

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
