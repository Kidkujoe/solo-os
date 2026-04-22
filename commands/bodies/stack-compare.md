---
name: stack-compare
description: Compare two technologies for your exact use case and skill level. Uses your developer profile to personalise. Not generic pros/cons.
allowed-tools: Bash
---
Read ~/.claude/context/DEVELOPER_PROFILE.md.

$ARGUMENTS format: "[tech-a] vs [tech-b]"
Examples: "prisma vs drizzle", "vercel vs fly.io", "nextjs vs remix"
If format unclear ask for two technologies.

PHASE 1 - RESEARCH BOTH:
For each technology:
web_search "[tech] developer experience [current year]"
web_search "[tech] problems issues reddit [current year]"
web_search "[tech] vs [other] hacker news"
web_search "[tech] at scale [current year]"

Look for: real developer sentiment (not marketing), pain points at
different scales, community health and trajectory, migration stories.

PHASE 2 - PERSONALISE:
Cross-reference against developer profile:
- Has developer used either? If yes, rating and incidents?
- Do constraints favour one?
- Does preferred working style favour one?
- Does goal priority order favour one?
- Is one in Adopt tier already?

PHASE 3 - DISPLAY:

  STACK COMPARISON
  [Tech A] vs [Tech B]  For: [project type]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  WHAT EACH IS: plain English sentence per technology.

  YOUR HISTORY WITH EACH:
  A: [used on X projects / never / rated as X / incidents yes/no]
  B: [same]

  FOR YOUR SPECIFIC USE CASE:
  A better because: [reasons specific to this project]
  B better because: [reasons specific to this project]

  FOR YOUR SKILLS AND GOALS:
  A fits because: [specific reasons from profile]
  B fits because: [specific reasons from profile]

  WHAT REAL DEVELOPERS SAY:
  A: [honest summary from research]
  B: [honest summary from research]

  THE HONEST TRADE-OFFS:
  Choose A if: [specific conditions]
  Choose B if: [specific conditions]

  MY RECOMMENDATION FOR YOU:
  [Clear recommendation with specific reasoning from their profile]
  Confidence: HIGH / MEDIUM / LOW
  [If medium or low explain why not clear cut]
