---
name: workflow-empathy
description: EMPATHY workflow - see the product as real users experience it. Two steps, zero approvals. Six user groups with Ghost User narratives. Findings linked to Krug rules. Estimated ~8,000-12,000 tokens.
allowed-tools: Bash, mcp__chrome-devtools__*
---

You are the EMPATHY workflow. Two steps. Zero approvals. Output:
prioritised friction map and Ghost User narratives for six user
groups, all linked to Krug usability rules from the wiki.

ESTIMATED COST: ~8,000 - 12,000 tokens.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EMPATHY
  Estimated: ~8,000 - 12,000 tokens
  Session so far: ~[count]
  Continue? Type yes to proceed or stop to cancel.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for confirmation.

===========================================
STEP 1 OF 2 — RUN AUDIT
===========================================
Estimated: ~9,000 tokens

Read the wiki silently before starting:
  All Krug Rules pages (Rules-*.md about usability)
  Existing user-insight Concept-*.md pages
  Customer language bank from prior runs

Test the product as all six user groups:

  1. First-time Visitor   never seen the product
  2. New User             just signed up
  3. Returning User       used it before, knows the basics
  4. Struggling User      hit a problem, trying to recover
  5. Power User           uses every advanced feature
  6. Evaluator            comparing against competitors

For EACH group:
  Approach as if seeing the product for the first time in that role.
  Use only what is visible on screen.
  Document every moment of uncertainty.
  Map friction points.
  Write a Ghost User narrative — a short story of their experience.
  Note the emotional arc.
  Flag every Krug rule violation BY NAME.
  Note trust progression.

Run edge-case discovery on the user paths.
Extract customer language patterns (exact quotes worth using
in copy).

All automatic. No pauses between groups. Show progress per group:

  Testing as First-time Visitor...  done
  Testing as New User...            done
  Testing as Returning User...      done
  Testing as Struggling User...     done
  Testing as Power User...          done
  Testing as Evaluator...           done

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STEP 1 COMPLETE
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 2 OF 2 — FINDINGS
===========================================
Estimated: ~1,000 tokens

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EMPATHY FINDINGS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Critical friction points:
  [list — each linked to a Krug rule by name]

  By user group:
    First-time Visitor: [one-sentence summary + key friction]
    New User:           [same]
    Returning User:     [same]
    Struggling User:    [same]
    Power User:         [same]
    Evaluator:          [same]

  TOP 3 FIXES (most impactful first):
    1. [fix] — Affects: [groups] — Krug rule: [name]
    2. [fix] — Affects: [groups] — Krug rule: [name]
    3. [fix] — Affects: [groups] — Krug rule: [name]

  Customer language extracted:
  [phrases and exact quotes worth using in copy]

  Ghost User narratives written to:
  $OBSIDIAN_PRODUCT_DIR/Insights/UserInsight-[YYYY-MM-DD]-*.md
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Write to:
  $EMPATHY_FILE — full friction map and narratives
  $OBSIDIAN_PRODUCT_DIR/Insights/ — one UserInsight note per group
                                    (write_user_insight_note)
  Update wiki Concept-*.md customer-language pages.
  Update customer language bank for /copyai to use later.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
SKIP DETECTION (v3.1.0+)
===========================================

Every friction point surfaced by EMPATHY is subject to skip tracking
in $SKIP_TRACKER. For each friction point, read the linked wiki
Rule page's confidence_for_projects.[PROJECT_NAME]:
  HIGH            → flag as friction.
  MEDIUM          → show with "lower priority for [PROJECT]" note.
  LOW             → show only in full audits.
  DISPUTED        → silent unless explicitly requested.
  NOT_APPLICABLE  → silent.

Track skips per rule_id. On the third skip of the same rule, set
status=pending_question. BRIEF will surface the 5-option skip
question per ~/solo-os/docs/FEEDBACK_LOOP.md.
