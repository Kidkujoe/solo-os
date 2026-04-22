---
name: stack-profile
description: Builds your permanent developer profile. Infers from existing project contexts and asks targeted questions about experience, comfort levels and goals. Saves globally to DEVELOPER_PROFILE.md.
allowed-tools: Bash
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

NOTE: This command uses a GLOBAL file outside project context:
PROFILE_FILE="$HOME/.claude/context/DEVELOPER_PROFILE.md"

PHASE 1 - CHECK IF EXISTS:
If PROFILE_FILE has Status: CONFIRMED display:
  DEVELOPER PROFILE ALREADY EXISTS
  Last updated: [date]  Products: [count]  Technologies: [count]
  Run /stack-update to change. Type "show" to view, "rebuild" to restart.

Otherwise proceed.

PHASE 2 - INFER FROM PROJECTS:
Read all ~/.claude/context/projects/*/atlas/PRODUCT.md,
STRATEGY.md, HEALTH.md, DECISIONS.md, REVIEWS.md.

Extract: product names, tech stacks from code, deployment platforms,
key libraries, decisions revealing preferences, recurring pain patterns
from reviews.

Display WHAT I FOUND IN YOUR PROJECTS panel with detected products,
technologies seen across projects, recurring pain signals.

PHASE 3 - EIGHT QUESTIONS (one at a time, wait for each):

Q1 EXPERIENCE + STYLE: 1 self-taught / 2 few years / 3 several years /
   4 senior, combined with A solo / B with contractors / C small team.
   Type like "3A" or "2B".

Q2 SHIPPED PRODUCTS: For each detected product ask honestly what worked
   well in the tech stack and what caused pain. Be specific.

Q3 WHAT YOU KNOW WELL: Which detected technologies do you feel genuinely
   confident with ("could debug production at 2am")? Anything NOT in the
   detected list that you know well?

Q4 WANT TO LEARN: Want to learn something in next project? Or stay in
   familiar territory to move fast?

Q5 HARD CONSTRAINTS: Anything never to recommend against? (Must stay in
   TypeScript, specific deployment, budget limits, specific ecosystems.)
   Type "none" if none.

Q6 PREFERENCES: Pick letters: A convention over config / B full control /
   C minimal dependencies / D batteries included / E proven over cutting
   edge / F active community / G best documentation / H fastest to prototype.

Q7 TIME + SCALE: 1 full time / 2 part time / 3 evenings and A small /
   B medium / C large / D unknown scale. Type like "2D".

Q8 GOAL PRIORITY ORDER: Rank A ship fast / B build it right / C learn /
   D keep costs low / E build to sell / F long term maintainability /
   G impress investors.

PHASE 4 - BUILD AND CONFIRM:
Compile DEVELOPER_PROFILE.md from inferred data + answers.

Display complete profile with sections: Who you are, What you know well,
What caused pain, Preferences, Constraints, Goals, Tech Radar (Adopt /
Trial / Assess / Hold / Never Again), How this shapes recommendations.

Include specific examples of how the profile will change recommendations
(e.g. "Because you know Next.js well with no incidents across 3 projects,
I will always recommend it over alternatives unless there's specific reason not to").

Ask yes / edit. Save with Status: CONFIRMED.

PHASE 5 - OBSIDIAN SYNC (if vault exists):
Write profile summary to ~/Documents/SecondBrain/Developer/Profile.md.
Write Tech Radar to ~/Documents/SecondBrain/Developer/TechRadar.md
with sections Adopt / Trial / Assess / Hold / Never Again.
Create ~/Documents/SecondBrain/Developer/TechDecisions/ and
~/Documents/SecondBrain/Developer/LessonsLearned/ folders.
