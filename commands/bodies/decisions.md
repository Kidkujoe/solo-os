---
name: decisions
description: Review and correct all recorded decisions for this project. Covers skip resolutions, intentional design choices, deferred items and disputed rules. Change any decision that was recorded incorrectly or that is no longer valid.
allowed-tools: Bash
---

You are the /decisions command. It lets the developer review and
correct every decision recorded by the v3.1.0 feedback loop so no
recorded decision is ever permanently wrong.

Run the RESOLVER first to set $PROJECT_CONTEXT, $SKIP_TRACKER,
$DECISIONS_FILE, $OBSIDIAN_LESSONS_FILE, $OBSIDIAN_WIKI.

Read:
  $SKIP_TRACKER                — skips with resolution/status
  $DECISIONS_FILE              — intentional design choices
  $OBSIDIAN_LESSONS_FILE       — deferred, not-applicable, disputed
  $OBSIDIAN_WIKI/Rules-*.md    — confidence_for_projects frontmatter

Full protocol reference: ~/solo-os/docs/FEEDBACK_LOOP.md

===========================================
PHASE 1 — BUILD REVIEW LIST
===========================================

Compile every recorded decision into four groups:

  NOT APPLICABLE: skip-tracker entries with resolution =
    "not_applicable", plus wiki pages where
    confidence_for_projects.[PROJECT_NAME] = NOT_APPLICABLE.

  INTENTIONAL CHOICES: every H2 entry in $DECISIONS_FILE.

  DEFERRED: skip-tracker entries with status = "deferred_monthly".

  DISPUTED: wiki pages where
    confidence_for_projects.[PROJECT_NAME] ∈ {MEDIUM, LOW, DISPUTED}
    with a non-zero disputes count.

For each decision record: rule_name or decision_description, source
(wiki page or file), date recorded, current status, and where it
lives so it can be updated.

===========================================
PHASE 2 — DISPLAY
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  DECISIONS - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [count] recorded decisions

  NOT APPLICABLE ([count])
  Rules marked as not relevant:

  [n]  [rule name]
       Marked: [date]
       Source: [wiki page]

  INTENTIONAL CHOICES ([count])
  Design decisions never to flag again:

  [n]  [decision description]
       Recorded: [date]

  DEFERRED ([count])
  Items on monthly reminder:

  [n]  [rule name]
       Deferred: [date]
       Last surfaced: [date]

  DISPUTED ([count])
  Rules with reduced confidence:

  [n]  [rule name]
       Current confidence: [level]
       Disputed: [count] times

  Type a number to review that decision.
  Type all to walk every decision in sequence.
  Type done to exit.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
PHASE 3 — REVIEW ONE DECISION
===========================================

When the user types a number, show the full context:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  REVIEWING DECISION [n]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Rule / decision: [name]
  Source: [wiki page or DECISIONS.md anchor]
  Current status: [NOT APPLICABLE | INTENTIONAL | DEFERRED | DISPUTED]
  Recorded: [date]

  The rule says:
  [full rule statement from wiki page — truncate to ~5 lines]

  Why it was marked this way:
  [reason recorded, if any]

  What would you like to do?

  A  Keep as [current status]
     Correct decision. Leave it.

  B  Change to MEDIUM confidence
     Maybe it applies sometimes.
     Show as suggestion not violation.

  C  Restore to HIGH confidence
     Wrong decision originally. Enforce this rule again.

  D  Change to INTENTIONAL CHOICE
     It applies but we deliberately do it differently. Never flag.

  E  Change to DEFERRED
     Want to address eventually. Monthly reminder only.

  Type A B C D or E.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Apply the answer to ALL relevant stores so nothing drifts:

  A (keep): no change. Move on.

  B (MEDIUM): update the wiki page
     confidence_for_projects.[PROJECT_NAME] = MEDIUM. Remove any
     not_applicable_for entry. Set skip-tracker resolution to
     "dispute" with disputes = max(1, current). Append to lessons
     under "## Confidence updates applied".

  C (HIGH): update the wiki page
     confidence_for_projects.[PROJECT_NAME] = HIGH. Remove any
     not_applicable_for entry. Clear disputes count. Remove the
     skip-tracker entry (or reset skip_count to 0 with
     status=active). Append to lessons.

  D (INTENTIONAL): append to $DECISIONS_FILE with today's date and
     a one-line rationale. Remove the skip-tracker entry. Set wiki
     confidence_for_projects.[PROJECT_NAME] = NOT_APPLICABLE with
     reason "intentional design choice confirmed via /decisions on
     [date]". Append to lessons.

  E (DEFERRED): set skip-tracker status = deferred_monthly, last
     surfaced = today. Leave wiki confidence untouched. Append to
     lessons.

After every change, write a one-line note to
$OBSIDIAN_LESSONS_FILE under "## Confidence updates applied":

  ### [YYYY-MM-DD] - Decision reviewed via /decisions
  Rule: [name]
  Changed from [old status] to [new status].

===========================================
PHASE 4 — BULK REVIEW
===========================================

If the user types `all`, walk every decision in sequence.
Show each with Phase 3's full context. Show progress:

  Decision 3 of 12.
  [rule name]
  [options A-E]

Tally throughout. At the end:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  REVIEW COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Reviewed:            [count]
  Unchanged:           [count]
  Updated:             [count]
  Restored to HIGH:    [count]

  All changes saved to:
    $SKIP_TRACKER
    $DECISIONS_FILE
    Wiki confidence frontmatter
    $OBSIDIAN_LESSONS_FILE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
NOTES
===========================================

- Never prompt for every decision on a fresh run; only show the
  A-E question after the user selects a number or types `all`.
- If a store is missing (no lessons file, no skip-tracker), skip
  that group silently. Do not error.
- For the wiki frontmatter edits, preserve any other fields
  present (last_reviewed, not_applicable_for for other projects,
  etc.). Only touch this project's entries.
