---
name: new-project
description: Complete new project kickstart. Idea to ready-to-code in one session. Validates, defines strategy, recommends stack, scaffolds project, creates first roadmap, sets up Obsidian. Target under 40 minutes.
allowed-tools: Bash, mcp__chrome-devtools__*
---

===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run: pwd to get the absolute project path.
Take the folder basename. Add a 6-character hash of the full path
(try md5sum first, fall back to shasum). Format as:
PROJECT_ID = [basename]-[6char-hash]
PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is not a project directory (is home, is
~/.claude, has no code files), display PROJECT NOT DETECTED
warning and stop. Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS:
mkdir -p $PROJECT_CONTEXT
mkdir -p $PROJECT_CONTEXT/atlas
mkdir -p $PROJECT_CONTEXT/screenshots
mkdir -p $PROJECT_CONTEXT/reports

STEP R3 - ESTABLISH ALL FILE PATHS:
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
REPORTS           = $PROJECT_CONTEXT/reports
TEST_REPORT       = $REPORTS/test-report.html
COPY_REPORT       = $REPORTS/copy-report.html
COMPASS_REPORT    = $REPORTS/compass-report.html
EMPATHY_REPORT    = $REPORTS/empathy-report.html
ATLAS             = $PROJECT_CONTEXT/atlas
PRODUCT_MD        = $ATLAS/PRODUCT.md
DESIGN_MD         = $ATLAS/DESIGN.md
DECISIONS_MD      = $ATLAS/DECISIONS.md
DEPENDENCIES_MD   = $ATLAS/DEPENDENCIES.md
REGRESSIONS_MD    = $ATLAS/REGRESSIONS.md
HEALTH_MD         = $ATLAS/HEALTH.md
STRATEGY_MD       = $ATLAS/STRATEGY.md
VOICE_MD          = $ATLAS/VOICE.md
SEO_MD            = $ATLAS/SEO.md

Global resources (shared across all projects):
REPORT_TEMPLATE    = ~/.claude/context/report-template.html
GLOBAL_ACCOUNTS    = ~/.claude/context/test-accounts-global.md
DEVELOPER_PROFILE  = ~/.claude/context/DEVELOPER_PROFILE.md

STEP R4 - VERIFY ISOLATION:
Every file path used in this command must either start with
$PROJECT_CONTEXT or be one of the approved global resources listed
below.

Approved globals inside ~/.claude/:
  ~/.claude/context/report-template.html      (shared HTML template)
  ~/.claude/context/test-accounts-global.md   (keyed test accounts)
  ~/.claude/context/DEVELOPER_PROFILE.md      (cross-project developer profile, v2.4.0+)
  ~/.claude/context/projects/                 (parent of all project folders)
  ~/.claude/commands/                         (the commands themselves)

Approved globals inside ~/Documents/SecondBrain/ (v2.5.0+ Obsidian vault):
  $OBSIDIAN_VAULT and anything under it, including raw/, wiki/,
  schema/, program/, Products/, Research/, Patterns/, Inbox/,
  Templates/, Developer/. Resolved dynamically in STEP R8.

If any path outside these is referenced, stop and report.

STEP R5 - DISPLAY CONTEXT CONFIRMATION:
Display a one-line confirmation so user can see which project:
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CHECK FOR CONTAMINATION:
If SESSION_FILE exists, check its first line for:
  # Project: [project-id]
If the stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning and ask user: 1) archive and start fresh, 2) show contents,
3) stop. Wait for response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

STEP R8 - KNOWLEDGE BRIDGE INITIALIZATION (v2.3.0+):
Read $STRATEGY_MD if it exists and extract the line:
  Obsidian vault: [path]
If found set OBSIDIAN_VAULT to that path.
If not found default to: OBSIDIAN_VAULT="$HOME/Documents/SecondBrain"

Derive these paths:
  OBSIDIAN_PRODUCTS="$OBSIDIAN_VAULT/Products"
  OBSIDIAN_RESEARCH="$OBSIDIAN_VAULT/Research"
  OBSIDIAN_PATTERNS="$OBSIDIAN_VAULT/Patterns"
  OBSIDIAN_INBOX="$OBSIDIAN_VAULT/Inbox"
  OBSIDIAN_PRODUCT_DIR="$OBSIDIAN_PRODUCTS/$PROJECT_NAME"

Wiki-layer paths (v2.5.0+):
  OBSIDIAN_RAW="$OBSIDIAN_VAULT/raw"
  OBSIDIAN_WIKI="$OBSIDIAN_VAULT/wiki"
  OBSIDIAN_SCHEMA="$OBSIDIAN_VAULT/schema"
  OBSIDIAN_PROGRAM="$OBSIDIAN_VAULT/program"
  OBSIDIAN_PROGRAM_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME.md"

Check vault exists. If not found display:
  Obsidian vault not found at $OBSIDIAN_VAULT
  Knowledge Bridge disabled for this run.
  Set up Obsidian to enable. Continuing without it.
Then set OBSIDIAN_BRIDGE=off and skip all bridge calls.

If vault exists but $OBSIDIAN_PRODUCT_DIR is missing, create:
  mkdir -p "$OBSIDIAN_PRODUCT_DIR"/{Features,Decisions,Insights,Reviews}

Set OBSIDIAN_BRIDGE=on. Commands should call read/write functions
defined in RESOLVER.md § KNOWLEDGE_BRIDGE at their specified hooks.

END OF RESOLVER — continue with command logic below
===========================================


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
