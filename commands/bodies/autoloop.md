---
name: autoloop
description: Autonomous improvement loop from Karpathy autoresearch pattern. Reads the product program file, identifies the lowest scoring measurable area, proposes an improvement, measures before and after, keeps or discards based on the metric, logs the experiment and repeats. Only acts on measurable metrics. Changes requiring real user data are logged as hypotheses not acted on autonomously.
allowed-tools: Bash, mcp__chrome-devtools__*
---
Run the RESOLVER first.

Read the product program file:
`$OBSIDIAN_VAULT/program/$PROJECT_NAME.md`

If program file does not exist:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRODUCT PROGRAM FILE MISSING
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Run /autoloop-setup first.
  Takes about 5 minutes.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Then stop.

Read wiki pages listed in the program file as relevant sources. These
are compiled rules and knowledge the loop acts on.

===========================================
AUTOLOOP PHASE 1 - ESTABLISH BASELINE
===========================================

On first run, establish a baseline for every measurable metric.

Run these measurements:

**PERFORMANCE**
`lighthouse [app-url] --output=json`
Extract: performance score, LCP, CLS, INP.

**TEST SUITE**
Run the test command from `package.json`.
Extract: pass rate percentage.

**DESIGN CONSISTENCY**
`/design --score-only`
Extract: design score out of 10.

**SECURITY**
`/pillars --security --score-only`
Extract: security score.

**ACCESSIBILITY**
Lighthouse accessibility audit.
Extract: violation count.

Save baseline to `$OBSIDIAN_VAULT/program/$PROJECT_NAME-experiments.md`:

```
# Experiment Log — [project name]
Baseline established: [timestamp]

## Baseline
Performance: [score]
Tests: [pass rate]
Design: [score]
Security: [score]
Accessibility: [violations]
Primary metric: [value]
```

===========================================
AUTOLOOP PHASE 2 - IDENTIFY TARGET
===========================================

Compare all metrics against baseline and previous experiments.

Find the metric with:
- The lowest absolute score, AND
- The most realistic improvement potential based on wiki Rules pages

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AUTOLOOP — [project name]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Program file: [name]
  Wiki rules loaded: [count]

  CURRENT SCORES:
  Performance:   [score]
  Tests:         [pass rate]
  Design:        [score]
  Security:      [score]
  Accessibility: [violations]

  TARGET THIS LOOP:
  [Lowest scoring area]
  Current: [value]
  Realistic target: [value]
  Why this first: [reason]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
AUTOLOOP PHASE 3 - PROPOSE IMPROVEMENT
===========================================

Read the relevant wiki Rules pages for the target area.

Find the specific violation or gap causing the low score.

Check the program file:
- Is this file in the CAN change list?
- Is this within the allowed scope?

If not, find a different approach.

Apply the simplicity criterion from Karpathy autoresearch:
- Could **removing** something achieve the same improvement?
- Is there a simpler fix?
- A deletion that improves the metric is always preferred over an addition.

Propose:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PROPOSED IMPROVEMENT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Target metric: [metric]
  Current: [value]
  Expected after: [predicted value]

  What will change:
  [File and what changes]

  Why this improves the metric:
  [Specific reasoning]

  Wiki rule applied:
  [Rules page citation]

  Simplicity check:
  Adding complexity: [yes/no]
  Could removal achieve this: [yes/no]
  Verdict: PROCEED / SIMPLIFY FIRST

  Within allowed scope: [yes/no]

  Apply this change?
  Type yes / no / adjust
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for approval before changing any file.

===========================================
AUTOLOOP PHASE 4 - APPLY AND MEASURE
===========================================

After approval, apply the change. Commit to git:

```
git add [changed files]
git commit -m "autoloop: [description]"
```

Re-run the measurement immediately.

Display:

  MEASUREMENT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Before: [value]
  After:  [value]
  Change: [+/- value]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
AUTOLOOP PHASE 5 - KEEP OR DISCARD
===========================================

From Karpathy autoresearch pattern:

- **KEEP** if metric improved.
- **KEEP** if metric stayed the same but complexity was reduced.
  (A simplification win is always a keep.)
- **DISCARD** if metric got worse. Revert: `git revert HEAD`.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VERDICT: KEEP / DISCARD
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Reason: [plain English]
  Commit: [hash if kept]
  Reverted: [yes if discarded]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
AUTOLOOP PHASE 6 - LOG THE EXPERIMENT
===========================================

Append to experiment log at
`$OBSIDIAN_VAULT/program/$PROJECT_NAME-experiments.md`.

Every experiment is logged regardless of keep or discard. This is the
`results.tsv` equivalent from Karpathy autoresearch.

Format:

```
## [timestamp] | [description]
Target metric: [metric]
What was tried: [description]
Before: [value]
After: [value]
Verdict: KEEP / DISCARD
Reason: [plain English]
Commit: [hash or REVERTED]
Simplicity impact: ADDED / REMOVED / NEUTRAL / SIMPLIFICATION WIN
Wiki rule applied: [page name]
```

If the finding is worth preserving, write it back to the wiki as a
Synthesis page. This is the loop compounding in the knowledge base.

===========================================
AUTOLOOP PHASE 7 - HYPOTHESIS LOGGING
===========================================

If an improvement is found that cannot be measured in this session,
do not discard it. Log it as a hypothesis:

```
## [timestamp] | HYPOTHESIS: [description]
What this might improve: [metric]
Why it might work: [reasoning]
Cannot verify because: requires real user data over time
Verify with: /compass-retro after [timeframe] of real usage
Evidence from wiki: [relevant pages]
```

===========================================
AUTOLOOP PHASE 8 - LOOP OR STOP
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  LOOP COMPLETE
  Experiments this session: [count]
  Kept: [count]
  Discarded: [count]
  Hypotheses logged: [count]

  Metric movement:
  Primary metric: [start] -> [current]

  Continue to next improvement?
  Type yes / stop
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
