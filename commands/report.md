---
name: report
description: Generate or regenerate the plain English HTML report from the last test session
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

Generate an HTML test report from the current session data.

STEP 1 - LOAD DATA
- Read $PRODUCT_MD silently if it exists
- Read $SESSION_FILE
- Read $DATA_FILE
- Check if there is session data to report on

If no session data exists:
  Display:
  No test session found. Run /test first
  to generate test data, then use /report
  to create the HTML report.
  And stop.

STEP 2 - LOAD TEMPLATE
- Read $REPORT_TEMPLATE
- If template does not exist, use the built-in
  report structure with clean minimal styling

STEP 3 - BUILD REPORT
Generate a complete HTML report with these sections:

HEADER:
- Project name
- Report title
- Date and time generated

SUMMARY:
- 3 to 5 sentences in plain English explaining
  what was tested, how access was gained, and
  the overall result. Written so anyone can
  understand it without technical knowledge.

WHAT WE FIXED FOR YOU:
- List each fix applied during the session
- Explain what was wrong in plain English
- Explain what was changed
- If no fixes were applied, say so

AREAS TESTED AND HOW WE GOT IN:
- List every area tested
- Show how access was gained for restricted areas
- Show access badges: Fully Tested, Partially
  Tested, Could Not Access, Skipped

SCREENSHOTS:
- Organised by breakpoint: Desktop, Tablet, Mobile
- Each screenshot has a caption
- Screenshots link to the full size image

THINGS THAT NEED ATTENTION:
- Critical issues with red left border
  Label: Do This Now
- High issues with amber left border
  Label: Do This Soon
- Medium issues with amber left border
  Label: Nice To Have
- Each issue has:
  Plain English title
  What: description of the problem
  Why it matters: impact explanation
  Next step: what to do about it

HEALTH SCORECARD:
- Overall Health
- Visual Quality
- Code Quality
- Responsive Design
- Security
- Authentication
- Accessibility
Each with a progress bar and plain English status

RECOMMENDED NEXT STEPS:
- Numbered list of actions in priority order
- Written as simple instructions anyone can follow

WHAT TO RUN NEXT (visual-test-pro command guide):
After the recommended next steps add a section titled
"Your Next Command" that translates the findings into
specific commands the user should run.

Use this logic to pick the most relevant command:

IF Critical or High security issues found:
  → Run /pillars to audit Security, Reliability,
    Scalability, Observability in depth

IF design inconsistencies found:
  → Run /design for full design integrity audit

IF copy issues or placeholder text found:
  → Run /copy for brand voice audit
  → Or /copyai for research-driven rewrites with evidence

IF missing page titles, metas or SEO issues found:
  → Run /seo for full SEO audit

IF user is pre-launch or planning features:
  → Run /compass for product intelligence and roadmap
  → Or /compass-feature "[name]" to evaluate one idea

IF regressions or code dependencies need tracking:
  → Run /atlas for master product brain refresh
  → Or /atlas-check for regression + consistency check

IF fixes were paused or session interrupted:
  → Run /resume to continue where you left off

Also include a compact reference card at the end of
the report listing ALL available commands grouped by
purpose, so users can discover what else is possible:

TESTING AND FIXES
  /test         Smart visual test with options
  /test-quick   Fast daily check
  /test-deep    Full pre-launch review
  /resume       Continue paused session
  /status       See current progress

PRODUCT INTELLIGENCE
  /atlas            Master product brain and recommendations
  /atlas-quick      Quick refresh, tell me what to do next
  /atlas-map        Full codebase rescan
  /atlas-check      Regression and consistency check
  /atlas-feature    Post-feature checklist for one feature
  /compass          PRISM-PV product intelligence with roadmap
  /compass-feature  Evaluate a single feature idea
  /compass-project  Validate a new project before coding
  /compass-retro    Retrospective on a built feature

QUALITY AND AUDITS
  /pillars     Four Pillars production readiness audit
  /edgecases   Discover edge cases specific to this app
  /design      Design integrity audit
  /seo         Full SEO audit
  /copy        Brand voice and copy audit
  /copyai      Research-driven copy with evidence
  /copyai-research  Copy research without rewrites

UTILITIES
  /report       Regenerate this HTML report
  /screenshots  Manage screenshots
  /addaccount   Save test login details

Write this as clean formatted cards in the HTML.
Each command card: command name, one-line purpose,
"when to run it" hint. Group by purpose with clear
section headings.

FOOTER:
- Generated by Claude Code with visual-test-pro
- Date and time
- File path where report is saved
- Plugin version

STEP 4 - SAVE AND OPEN
- Save report to $TEST_REPORT
- Open the report in Chrome using MCP
- Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  REPORT GENERATED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Your report is ready at:
  $TEST_REPORT

  It should be open in Chrome now.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
