---
name: compass-retro
description: Retrospective comparing what COMPASS predicted about a feature against what actually happened. Calibrates scoring accuracy over time.
allowed-tools: Bash
---

Running retrospective for: $ARGUMENTS

Read ~/.claude/context/atlas/COMPASS.md
Find the original feature entry with score and prediction.

Ask:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  COMPASS RETROSPECTIVE
  Feature: [name]
  Original score: [X]/25
  Classification: [type]
  Prediction: [what was expected]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Did users adopt this feature?
     Well adopted / Some / Barely / Not used

  2. Did it move your North Star metric?
     Significantly / Slightly / No change / Negative

  3. Was Painkiller/Vitamin classification correct?
     Exactly right / Partially / Wrong

  4. Was the pain signal real?
     Exactly as described / Less acute /
     Greater than expected / Did not materialise

  5. Anything unexpected? [free text]

Calculate calibration. Was original score accurate?
What should adjust for future scoring?
Save to COMPASS.md under Retrospectives with calibration notes.
