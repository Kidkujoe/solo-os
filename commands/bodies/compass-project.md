---
name: compass-project
description: Full market validation for a new project idea. Research the problem space, identify the market, find competitors, validate demand, score the opportunity and produce an initial feature roadmap before writing a line of code.
allowed-tools: Bash
---
Validating new project: $ARGUMENTS

This command is for projects that do not have a codebase yet.

Read ~/.claude/context/DEVELOPER_PROFILE.md if it exists
Read $STRATEGY_MD if it exists

DEVELOPER PROFILE INTEGRATION (v2.4.0):
When scoring Implementation difficulty in PRISM-PV, personalise the
I score based on the developer's profile:
- If recommended stack for this project type matches technologies in
  developer's Adopt tier: I score is HIGHER (easier for this developer)
- If recommended stack requires technologies developer has never used:
  I score is LOWER (harder for this developer)

Note this explicitly in scoring:
"Implementation difficulty rated [X] for you specifically because
[reason from profile — e.g. 'you have used Next.js on 3 projects'
or 'this would require learning Prisma which you've never used']"

STEP 1 - STRATEGY QUESTIONS
Ask the five strategy questions from COMPASS Phase 1 if not answered.

STEP 2 - PROBLEM SPACE VALIDATION
Is this a real problem enough people have?
Search: how many people talk about this problem across platforms,
whether solutions are actively searched for, whether existing solutions
are inadequate based on reviews, whether the problem is growing or declining.

STEP 3 - MARKET SIZE SIGNALS
Practical signals not formal TAM:
Competitors with meaningful traction? (PH upvotes, G2 counts, Reddit sizes)
People paying for partial solutions?
Search volume growing?

STEP 4 - COMPETITOR RESEARCH
Run COMPASS Phase 3 for the problem space.

STEP 5 - SIGNAL PROCESSING
Run COMPASS Phase 4. Cluster and filter.

STEP 6 - INITIAL FEATURE SET
Score each potential feature using PRISM-PV.
Identify the Critical Painkiller — the one feature without which
the product cannot be sold.

STEP 7 - VERDICT

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PROJECT VALIDATION VERDICT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project: [name]
  Market signal: [STRONG/MODERATE/WEAK]
  Recommended: [BUILD/VALIDATE/RECONSIDER/DO NOT BUILD]

  Critical Painkiller: [yes/no — what it is]

  Minimum viable feature set:
  [list must-haves to validate the core painkiller]

  Biggest risk: [one sentence]
  Biggest opportunity: [one sentence]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Save to COMPASS.md under Project Validations.
