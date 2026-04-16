---
name: compass-feature
description: Evaluate a specific feature idea using the PRISM-PV framework. Research whether the pain signal is real, score it, classify as Painkiller or Vitamin, check strategic fit and recommend build, validate or decline.
allowed-tools: Bash
---

Evaluating feature: $ARGUMENTS

Read ~/.claude/context/atlas/PRODUCT.md silently if it exists
Read ~/.claude/context/atlas/STRATEGY.md
Read ~/.claude/context/atlas/COMPASS.md

Run COMPASS Phases 0, 1, 3, 4, 5, 6 and 7 scoped to this feature.

Research this specific feature across all platforms with collection targets.
Tag and cluster data. Score using full PRISM-PV framework.
Run conflict checks. Provide validation recommendation if score 6-9.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FEATURE VERDICT: [name]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRISM-PV Score: [X]/25
  Classification: [BUILD/VALIDATE/DECLINE]
  PV Status: [Painkiller type / Vitamin type]
  Urgency: [ACUTE/GROWING/LATENT/TRIGGERED]

  P [pain]: [X]/6  R [revenue]: [X]/4
  I [effort]: [X]/2  S [strategic]: [X]/3
  M [market]: [X]/3  PV: [X]/2
  Modifiers: [+/- X]

  Build vs buy: [recommendation]
  Moat: [strength]
  Strategic fit: [rating]

  Evidence: [count] instances across [count] platforms

  Top quote:
  "[quote]"
  Platform: [name] | Date: [date]
  Behaviour: [action]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Add result to COMPASS.md under Feature Evaluations.
