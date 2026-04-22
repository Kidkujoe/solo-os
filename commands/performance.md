---
name: performance
description: Measures real Core Web Vitals, Lighthouse scores, bundle sizes and load times. Compares against previous runs. Stores results in HEALTH.md so /seo and /pillars reference real numbers.
allowed-tools: Bash, mcp__chrome-devtools__*
---



===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run `pwd` to get the absolute project path.
Derive PROJECT_ID = [basename]-[6char hash of full path] using md5sum
(fall back to shasum if unavailable).
Set PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is NOT a project directory (is home, is ~/.claude,
no code files present), display PROJECT NOT DETECTED warning and stop.
Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS if missing:
mkdir -p $PROJECT_CONTEXT/atlas $PROJECT_CONTEXT/screenshots $PROJECT_CONTEXT/reports

STEP R3 - ALL PATHS (use these variables, never hardcode):
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
TEST_REPORT       = $PROJECT_CONTEXT/reports/test-report.html
COPY_REPORT       = $PROJECT_CONTEXT/reports/copy-report.html
COMPASS_REPORT    = $PROJECT_CONTEXT/reports/compass-report.html
EMPATHY_REPORT    = $PROJECT_CONTEXT/reports/empathy-report.html
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

Approved global resources (shared across all projects):
REPORT_TEMPLATE   = $REPORT_TEMPLATE
GLOBAL_ACCOUNTS   = ~/.claude/context/test-accounts-global.md

STEP R4 - VERIFY ISOLATION:
Every path used must start with $PROJECT_CONTEXT or be one of the two
approved globals. Any other ~/.claude/context/ path is a violation.

STEP R5 - DISPLAY CONFIRMATION (one line):
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CONTAMINATION CHECK:
If $SESSION_FILE exists, check its first line for `# Project: [id]`.
If stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning with options: archive + start fresh / show contents / stop.
Wait for user response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

TEST-ACCOUNTS USAGE:
When reading accounts, read $GLOBAL_ACCOUNTS and filter to the section
matching PROJECT_ID. Never read another project's section.
When writing accounts, update the $PROJECT_ID section only.

END OF RESOLVER — command-specific logic follows
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

PHASE 2 - LIGHTHOUSE AUDIT:
Run DESKTOP:
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-desktop.json --form-factor=desktop --chrome-flags="--headless"
Run MOBILE:
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-mobile.json --form-factor=mobile --chrome-flags="--headless"

Stream progress per mode: URL, elapsed time, audit steps as they run.

Extract Core Web Vitals:
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
