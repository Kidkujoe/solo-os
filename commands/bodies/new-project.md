---
name: new-project
description: Complete new project kickstart. Idea to ready-to-code in one session. Validates, defines strategy, recommends stack, scaffolds project, creates first roadmap, sets up Obsidian. Target under 40 minutes.
allowed-tools: Bash, mcp__chrome-devtools__*
---

===========================================
FLAG ROUTER (v2.6.0) — CHECK BEFORE ANYTHING ELSE
===========================================

Inspect $ARGUMENTS for a flag. Validation-only mode runs Phase 1 only
then stops at the BUILD verdict — it does not proceed to strategy,
stack or scaffolding.

If $ARGUMENTS contains "--validate-only":
  Display: Validation only mode. I will run Phase 1 (idea validation)
  and stop at the BUILD / VALIDATE / DECLINE verdict. Strategy, stack
  and scaffolding will NOT run.
  Set VALIDATE_ONLY = true.
  Strip "--validate-only" from $ARGUMENTS so the rest of the command
  sees only the project idea.
  Continue with the existing logic below, but at the end of Phase 1
  (after the BUILD verdict is displayed) STOP. Do not enter Phase 2.

If "--validate-only" is not present, set VALIDATE_ONLY = false and
proceed normally through all phases.

Read ~/.claude/context/DEVELOPER_PROFILE.md.

$ARGUMENTS is the project idea in plain English.
Example: "An RSVP tool for small event venues"
Example: "A time tracking tool for freelance designers"

If no DEVELOPER_PROFILE exists:
  SET UP YOUR DEVELOPER PROFILE FIRST
  /new-project works best with your profile so recommendations are
  personal. Run /stack-profile first (10 minutes) then come back.
  Or type "proceed" to continue with generic recommendations.

Display session plan:
  NEW PROJECT KICKSTART
  Idea: [from $ARGUMENTS]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  30-40 minutes total:
  Phase 1: Validate the idea (10 min)
  Phase 2: Define your strategy (5 min)
  Phase 3: Choose your stack (5 min)
  Phase 4: Scaffold the project (10 min)
  Phase 5: First roadmap (5 min)
  Phase 6: Obsidian setup (2 min)
  Phase 7: Ready to code

PHASE 1 - VALIDATE THE IDEA:
Run complete /compass-project logic scoped to $ARGUMENTS:
- Problem space validation
- Competitor identification and research
- Customer pain signal mining from Reddit, G2, review sites
- Market signal assessment
- PRISM-PV scoring of core idea
- Critical Painkiller identification

Check ~/Documents/SecondBrain/Research/Competitors/ for existing notes.
Reference relevant ones.

At end display:
  PHASE 1 COMPLETE - IDEA VALIDATION
  Verdict: BUILD / VALIDATE FIRST / DO NOT BUILD
  Market signal: STRONG / MODERATE / WEAK
  Critical Painkiller: [identified / not found]

  If BUILD: The core thing to build first: [feature]
  Why this first: [evidence from research]

If DO NOT BUILD: explain why. Ask if user wants to pivot. If yes, ask
how and re-run Phase 1. If no, end session gracefully.

Only continue to Phase 2 with BUILD or VALIDATE FIRST verdict.

PHASE 2 - DEFINE STRATEGY (5 questions, one at a time):

Q1 In one sentence what does this product do and who is it for?
Q2 Who is the ONE type of user you're building for above all others?
   Describe their situation and frustration, not just job title.
Q3 What is the one thing you want to be undeniably best at?
Q4 What is your North Star metric?
   1 Activation / 2 Retention / 3 Revenue / 4 Acquisition
Q5 What are you NOT building even if customers ask?
   Type "unknown" if not sure yet.

Write to $STRATEGY_MD and $PRODUCT_MD.

Display summary: Product / Building for / Best at / North Star / Not building.

PHASE 3 - CHOOSE THE STACK:
Run complete /stack-recommend logic using context from Phases 1 and 2
plus DEVELOPER_PROFILE.md.

Personalised to: project type, target user, scale, developer's history,
developer's goals and constraints.

Display: Frontend / Backend / Database / Auth / Deployment + estimated
setup time with their experience level.

PHASE 4 - SCAFFOLD THE PROJECT:

STEP 4A - FRAMEWORK CLI:
For Next.js: `npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"`
For Remix: `npx create-remix@latest .`
For SvelteKit: `npm create svelte@latest .`
Other frameworks: appropriate create command.
Show output live.

STEP 4B - STANDARD FILES:
Create .env.local with required vars for confirmed stack.
Create .env.example with same keys, no values.
Update .gitignore to include .env.local.
Create standard folder structure: src/components, src/lib, src/hooks,
src/types, src/utils (adapted to framework).

STEP 4C - DATABASE:
For Drizzle: install drizzle-orm + drizzle-kit, create src/lib/db.ts,
drizzle.config.ts, src/db/schema.ts starter.
For Prisma: install @prisma/client + prisma, run `npx prisma init`.
For Supabase: install @supabase/supabase-js, create src/lib/supabase.ts.

STEP 4D - AUTH:
For Clerk: install @clerk/nextjs, add middleware.ts, wrap with ClerkProvider.
For NextAuth: install next-auth, create API route.
For Supabase Auth: included with Supabase setup.
For Lucia: install lucia.

STEP 4E - LINTING AND TESTING:
ESLint usually included by framework — verify config.
Prettier: install prettier + eslint-config-prettier, create .prettierrc.
Testing: Vitest (preferred) or Jest if not included.

STEP 4F - GIT:
git init
git add .
git commit -m "Initial commit: [project] scaffolded with [stack]"

Ask for GitHub repo URL:
  GIT SETUP
  Local git repository created.
  Do you have a GitHub repo for this?
  Type the URL to connect it, or type "skip".

If URL provided:
git remote add origin [url]
git branch -M main
git push -u origin main
Confirm push succeeded.

Display:
  PHASE 4 COMPLETE - PROJECT SCAFFOLDED
  Framework, Database, Auth, Linting, Git all set up.
  Your app runs at: localhost:3000
  Start it with: npm run dev

PHASE 5 - FIRST ROADMAP:
Based on Phase 1 validation research create first COMPASS.md.
Use PRISM-PV scores to rank minimum viable features.

Identify:
- The Critical Painkiller: the one feature that validates the product
- Three to five supporting features that complete MVP

Display:
  PHASE 5 - YOUR FIRST ROADMAP
  BUILD THIS FIRST: [Critical Painkiller feature name]
  Why: [evidence from research]
  This is the feature that validates the entire product.

  THEN BUILD THESE:
  2. [feature] — Why: [one sentence from research] — Effort: [estimate]
  3. [feature] — Why: [one sentence] — Effort: [estimate]
  4. [feature] — Why: [one sentence] — Effort: [estimate]

  DO NOT BUILD YET: [features researched but not in MVP set]

  Saved to $COMPASS_FILE.

PHASE 6 - OBSIDIAN SETUP (if vault exists):
Create ~/Documents/SecondBrain/Products/[project-name]/ with subfolders:
Features/, Decisions/, Insights/, Reviews/, and _index.md.

Write _index.md with:
- What the product is from Phase 2
- Validation verdict from Phase 1
- Stack decision from Phase 3
- Links to first roadmap features
- Link to project context folder

Write competitor notes from Phase 1 research to:
~/Documents/SecondBrain/Research/Competitors/

Write stack decision to:
~/Documents/SecondBrain/Developer/TechDecisions/[project]-[date].md

Write project kickstart note to Inbox:
"# [Project] - Started [date]
Idea: [one sentence]
Verdict: BUILD
Critical Painkiller: [feature]
Stack: [summary]
First thing to build: [feature]"

PHASE 7 - READY TO CODE:

  YOUR NEW PROJECT IS READY
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project: [name]

  VALIDATED — Market signal: [level]  Critical Painkiller: [feature]
  STRATEGY — Building for: [user]  North Star: [metric]
  STACK — [summary in one line]
  SCAFFOLDED — Start with: npm run dev  Runs at: localhost:3000

  FIRST THING TO BUILD: [Critical Painkiller feature name]
  Why this first: [one sentence from research]

  When done with that feature run: /atlas-feature [feature name]

  Time in this session: [duration]
