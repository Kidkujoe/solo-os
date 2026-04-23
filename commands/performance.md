---
name: performance
description: Measures real Core Web Vitals, Lighthouse scores, bundle sizes and load times. Compares against previous runs. Stores results in HEALTH.md so /seo and /pillars reference real numbers.
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

Orphan check FIRST (v3.2.0+). Run only when $PROJECT_CONTEXT does
not yet exist — i.e., this is the first time a command runs for
this project path:

  1. List all existing folders under ~/.claude/context/projects/.
  2. For each folder, read atlas/PRODUCT.md if present and extract
     the product name (first H1 or explicit "name:" field).
  3. Compare against the current project's package.json "name"
     field (if present) or the current directory basename.
  4. If one or more matches are found, display:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EXISTING CONTEXT FOUND
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    It looks like this project may have been renamed or moved.

    Found existing context for:
    [product name]
    Last active: [date from atlas/HEALTH.md]
    Contains:
      Atlas memory:      [yes/no]
      Review history:    [count records from REVIEWS.md]
      Skip resolutions:  [count from skip-tracker.json]
      Experiment log:    [count from $OBSIDIAN_PROGRAM_FILE]
      Lessons entries:   [count H3 blocks in lessons file]

    Is this the same project?

    A  Yes - migrate everything to new path
    B  No - this is a different project
    C  Not sure - show me the files first
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  A (migrate): cp -R the old context contents into the new
     $PROJECT_CONTEXT. Rewrite any absolute path strings inside
     the copied files that reference the old PROJECT_ID. Delete
     the old folder only after the copy verifies (same file count,
     matching sizes). Display:
       Migration complete. [count] files moved.
       Old context removed.

  B (new project): proceed with fresh context creation. Leave the
     old folder in place; /projects will later list it as inactive.

  C (not sure): list files in the old context folder with sizes
     and modification dates, then ask the A/B question again.

After the orphan check resolves (or if no match found):

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

Feedback-loop paths (v3.1.0+):
  OBSIDIAN_LESSONS_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME-lessons.md"
  SKIP_TRACKER="$PROJECT_CONTEXT/skip-tracker.json"
  DECISIONS_FILE="$PROJECT_CONTEXT/DECISIONS.md"
  Full feedback-loop protocol: ~/solo-os/docs/FEEDBACK_LOOP.md

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

Read $HEALTH_MD for previous performance scores.

PHASE 1 - ENVIRONMENT CHECK:
Detect Lighthouse: `which lighthouse && lighthouse --version`.
If missing offer: `npm install -g lighthouse`.
Verify Chrome is connected via MCP (required).
Look for build output: dist/, build/, .next/, .nuxt/, out/. Offer to
build if not found.
Detect app URL from dev server (ports 3000, 3001, 5173, 8080, 4321, 5000).
Ask if none responds.

Display setup panel: Lighthouse status, Chrome status, app URL, build
output location, previous scores found.

PHASE 2 - LIGHTHOUSE AUDIT (triple-run median, v3.2.0+):

Lighthouse scores vary 3-8 points on identical code due to CPU
and network noise. Run each form-factor THREE times and use the
median score as the authoritative value.

Run DESKTOP 3x (write runs 1/2/3 to separate files):
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-desktop-1.json --form-factor=desktop --chrome-flags="--headless" --quiet
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-desktop-2.json --form-factor=desktop --chrome-flags="--headless" --quiet
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-desktop-3.json --form-factor=desktop --chrome-flags="--headless" --quiet

Run MOBILE 3x:
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-mobile-1.json --form-factor=mobile --chrome-flags="--headless" --quiet
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-mobile-2.json --form-factor=mobile --chrome-flags="--headless" --quiet
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-mobile-3.json --form-factor=mobile --chrome-flags="--headless" --quiet

After each form-factor's three runs, display:

  Measuring [desktop|mobile] performance (3 runs)...
  Run 1: [score]
  Run 2: [score]
  Run 3: [score]
  Median: [score] <- used for comparison, HEALTH.md, EVOLVE

Keep the median run's JSON as the canonical report at
lighthouse-desktop.json / lighthouse-mobile.json (copy or symlink
from the median run); delete or archive the other two. Use the
median score for every keep/discard and regression decision.

Stream progress per mode and per run: URL, elapsed time, audit
steps as they run.

Extract Core Web Vitals (from the median run):
- LCP: GOOD <2500ms / NEEDS IMPROVEMENT 2500-4000 / POOR >4000
- CLS: GOOD <0.1 / NEEDS IMPROVEMENT 0.1-0.25 / POOR >0.25
- INP: GOOD <200ms / NEEDS IMPROVEMENT 200-500 / POOR >500
- FCP: value in ms
- TTFB: value in ms

Extract Lighthouse scores (0-100):
Performance, Accessibility, Best Practices, SEO.

PHASE 3 - BUNDLE ANALYSIS:
For each JS file in build output: size in KB. Flag >250KB as large,
>500KB as critical. Total JS size + gzipped estimate (x0.3).
Total CSS size. Largest file.
Images: flag any >200KB, non-WebP/AVIF, missing width/height.

Display bundle panel: total JS, total CSS, largest file, oversized
files with recommendations, image issues.

PHASE 4 - COMPARE TO PREVIOUS:
Read previous scores from $HEALTH_MD. Show trend:
Metric | Previous | Current | Change
LCP, CLS, INP, Performance, Bundle JS.
Trend: IMPROVING / STABLE / DECLINING.
List regressions.

PHASE 5 - RECOMMENDATIONS:
For each failing metric show:
- Current value, target, gap
- Most likely cause based on Lighthouse diagnostics
- Specific fix (code or configuration)
- Estimated improvement

SAVE TO HEALTH.md:
Append section:
## Performance Audit
Last run: [timestamp]
URL tested: [url]
Desktop: LCP [value] [rating], CLS, INP, Performance/Accessibility/Best Practices/SEO scores
Mobile: same fields
Bundle: Total JS, Total CSS, Largest file

===========================================
SKIP DETECTION (v3.1.0+)
===========================================

Every finding this command surfaces is subject to skip tracking in
$SKIP_TRACKER. For each rule read confidence_for_projects.[PROJECT_NAME]
from the wiki page frontmatter and apply the per-level enforcement:
  HIGH            → VIOLATION.
  MEDIUM          → SUGGESTION (non-blocking).
  LOW             → shown only in full-audit mode.
  DISPUTED        → silent unless explicitly requested.
  NOT_APPLICABLE  → silent.

Track skips per rule_id (first/second skip silent, third triggers
status=pending_question). The 5-option question, resolutions A-E,
and wiki confidence updates are defined in
~/solo-os/docs/FEEDBACK_LOOP.md. Follow it exactly.

Skip entries must include: rule_id, rule_name, source (wiki page),
skip_count, last_skipped (ISO timestamp), status, resolution.
