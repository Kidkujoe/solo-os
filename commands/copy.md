---
name: copy
description: Full copy and brand voice audit. Checks terminology consistency, tone, error messages, empty states and marketing vs product alignment.
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
REPORT_TEMPLATE   = ~/.claude/context/report-template.html
GLOBAL_ACCOUNTS   = ~/.claude/context/test-accounts-global.md

STEP R4 - VERIFY ISOLATION:
Every file path used in this command must either start with
$PROJECT_CONTEXT or be one of the two approved global resources.
If any other ~/.claude/context/ path is referenced, stop and report.

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
WIKI INTEGRATION (v2.5.0)
===========================================

If OBSIDIAN_BRIDGE=on, at the start of every run:

1. Read `$OBSIDIAN_VAULT/wiki/index.md`.
2. Load `Rules-BrandVoice.md` if it exists — this is the authority
   for terminology, tone, and style. Not VOICE.md, not generic
   copywriting best practice.
3. Load every `Concept-*.md` page about customer language. These are
   the user's own words about pains, desires, and framings — cite
   from them rather than inventing phrases.

Display:

  Wiki authority loaded:
  Brand voice: [Rules-BrandVoice.md or "none — using VOICE.md fallback"]
  Customer language concepts: [count]
  Auditing against YOUR voice + YOUR users' language.

===========================================
COMMAND BODY
===========================================

You are running a full copy and brand voice audit for: $ARGUMENTS

Read $PRODUCT_MD silently if it exists
Read $VOICE_MD
Read $SEO_MD if it exists
Read $ATLAS/COPYAI.md if it exists

IF COPYAI.md exists and was generated in the last 6 months:
Use the confirmed copy strategy and customer language bank as the
foundation for this audit. Reference it when making suggestions.

IF COPYAI.md does not exist:
Display at the start:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TIP: For stronger copy suggestions
  run /copyai first.

  /copyai researches your competitors,
  sources real customer language from
  Reddit, review sites and social
  platforms, and builds a copy strategy
  grounded in evidence before auditing.

  Run /copy now for a standard audit
  Run /copyai for intelligence-driven
  copy strategy and rewrites
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
PHASE 1 - BUILD OR LOAD VOICE GUIDE
===========================================

If VOICE.md is empty or contains only the template comment:

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUILDING YOUR BRAND VOICE GUIDE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  I have not defined your brand voice yet.
  I will read your codebase and draft a
  voice guide from what I find. You can
  confirm or correct it before I use it.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Read every user-facing string in the project:
- All visible text in the browser
- All button labels, form labels, placeholder text
- All error messages, success messages, empty states
- All tooltip and helper text
- All email templates if present
- All marketing and landing page copy
- All onboarding copy

From this derive:
- The apparent tone being used
- Terminology patterns that exist
- Inconsistencies already present
- Quality of error messages and empty states

Draft VOICE.md with:
# [Product Name] - Brand Voice

## What this product is in one sentence
## Who we are talking to
## Our tone
## Words we always use (terminology map)
## Words we never use
## How we write CTAs (verb-first pattern)
## How we write error messages (what happened + what to do)
## How we write empty states (acknowledge + one action)
## How we write success messages
## Tone by context (marketing, onboarding, dashboard, errors, emails)

Display the draft and ask:
Does this look right?
Type yes to confirm / edit to change / skip to audit without confirming

If confirmed: save to VOICE.md with status: Confirmed by user
If already confirmed from a previous run: load and use it.

===========================================
PHASE 2 - TERMINOLOGY AUDIT
===========================================

Read every user-facing string with VOICE.md loaded.

CHECK 1: FEATURE NAMING CONSISTENCY
Build a map of every term used for each feature or concept.
Flag anywhere the same thing is called different names.

For each inconsistency show:
  TERMINOLOGY INCONSISTENCY
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Concept: [what this thing is]
  Names found: [list with locations]
  Recommended term: [which one and why]
  Suggested changes: [file:line for each]
  Apply all? Type yes / no / one-by-one
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHECK 2: CTA CONSISTENCY
Check all buttons and links follow the voice guide CTA pattern.
Flag CTAs that don't start with a verb, use vague language,
or use submit/OK/yes.

CHECK 3: TONE CONSISTENCY
Compare tone on marketing pages vs inside the app.
Flag sections that sound significantly different.
Rate each section: On voice / Slightly off / Off brand

===========================================
PHASE 3 - QUALITY AUDIT
===========================================

CHECK 4: ERROR MESSAGE QUALITY
Find every error message. For each evaluate:
- Says what went wrong in plain English?
- Says what user can do next?
- Avoids technical jargon?
- Matches product tone?

Flag poor messages with suggested rewrites.

CHECK 5: EMPTY STATE QUALITY
Find every empty state. For each check:
- Acknowledges the emptiness?
- Gives one clear action?
- Friendly and helpful tone?

Flag poor empty states with suggested rewrites.

CHECK 6: MARKETING VS PRODUCT ALIGNMENT
Compare landing page claims with product reality:
- Claims the product doesn't deliver yet
- Features described differently between marketing and product
- Pricing promises vs actual limits
- Setup described as simple vs complex reality

For each mismatch show options:
1. Update marketing to be accurate
2. Simplify product to match claim
3. Add context to bridge the gap

===========================================
PHASE 4 - BROWSER COPY CHECK
===========================================

Open Chrome and visually read copy on every page.

Check for:
- Text truncated incorrectly
- Placeholder text never replaced
- TODO or lorem ipsum still visible
- Developer strings exposed to users
- Hardcoded test data visible
- Copy overlapping other elements
- Copy too small to read on mobile

Screenshot any copy issues found.

===========================================
PHASE 5 - RESULTS
===========================================

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  COPY AUDIT RESULTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Copy score:        [X]/10
  Voice consistency: [X]/10

  Critical: [count]
  High: [count]
  Suggestions: [count]

  Fixes applied: [count]
  Pending your approval: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Save findings to VOICE.md (update terminology map)
and to test-session.md.
Update HEALTH.md with copy score.
