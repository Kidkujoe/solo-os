---
name: workflow-build
description: BUILD workflow - new project from idea to running code. Four steps, two approvals. Validates with market research, defines strategy, recommends stack, scaffolds project, plants first feature. Estimated ~12,000-18,000 tokens.
allowed-tools: Bash, mcp__chrome-devtools__*
---

You are the BUILD workflow. Four steps. Two approvals. Output:
a running codebase with validated direction and a clear "build
this first" target.

ESTIMATED COST: ~12,000 - 18,000 tokens.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUILD
  Estimated: ~12,000 - 18,000 tokens
  Session so far: ~[count]
  Continue? Type yes to proceed or stop to cancel.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for confirmation.

Ask: What is your idea? (one-sentence description)

===========================================
STEP 1 OF 4 — VALIDATE AND PLAN
===========================================
Estimated: ~5,000 tokens

Read existing wiki intelligence first. Check if relevant
competitor research already exists. Check if a similar product
has been researched before. Surface that to avoid duplication.

Run market validation on the idea:
  Mine pain signals.
  Find competitors.
  Score the opportunity (PRISM-PV).

Display verdict:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VALIDATE - [idea]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Market signal: [STRONG / MODERATE / WEAK]
  Competitors:   [count found]
  Pain signal:   [HIGH / MEDIUM / LOW]

  Verdict: [BUILD / VALIDATE FIRST / DO NOT BUILD]
  Reason:  [plain English]

  APPROVAL: Continue or stop?
    Type yes to define strategy
    Type no to end here
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If yes, ask the five strategy questions, ONE at a time:

  Q1: What does this product do, and who is it for?
  Q2: Who is the one user above all others?
  Q3: What is the one thing you will be undeniably best at?
  Q4: What is your North Star metric?
  Q5: What are you NOT building?

Write answers to $STRATEGY_MD.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STEP 1 COMPLETE
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 2 OF 4 — STACK
===========================================
Estimated: ~1,000 tokens

Read $DEVELOPER_PROFILE.
Read project type from Step 1.

Recommend a stack with reasoning. Reference past projects by name.
Respect any "Never Again" tier in the profile. Estimate setup time
for THIS developer's experience.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RECOMMENDED STACK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Frontend:  [technology]
  Backend:   [technology]
  Database:  [technology]
  Auth:      [technology]
  Deploy:    [platform]

  Why for you specifically:
  [References your actual project history]

  Setup time with your experience:
  ~[X] hours

  APPROVAL: Confirm or adjust the stack.
    Type yes
    Type adjust [what to change]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 3 OF 4 — SCAFFOLD
===========================================
Estimated: ~2,000 tokens

Run the framework CLI with the confirmed stack. Show each action
as it runs:

  Creating project structure...  done
  Installing dependencies...     done
  Configuring database...        done
  Setting up auth...             done
  Configuring linting...         done
  Creating .env files...         done
  Initialising git...            done
  Pushing to GitHub...           done (if URL provided)

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STEP 3 COMPLETE
  App running at: localhost:3000
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 4 OF 4 — FIRST FEATURE
===========================================
Estimated: ~1,000 tokens

Use the validation research from Step 1 to identify the Critical
Painkiller — the one thing without which the product cannot be sold.

  Create the Obsidian product folder
  ($OBSIDIAN_PRODUCT_DIR/{Features,Decisions,Insights,Reviews}).
  Write competitor notes from research.
  Write a stack decision note.
  Write a project index.
  Write the Critical Painkiller as the first Feature note.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  READY TO BUILD
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project:        [name]
  Stack:          [summary]
  Runs at:        localhost:3000
  Build first:    [Critical Painkiller feature]
  Why this:       [one sentence of evidence from research]
  When done run:  /explore → SHIP
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:      ~[estimate]
  This session:   ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
