---
name: atlas-feature
description: Run the post-feature checklist for a specific feature
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

===========================================
KNOWLEDGE BRIDGE HOOKS (v2.3.0)
===========================================

If OBSIDIAN_BRIDGE=on (STEP R8):

At the start — call read_pattern_context and read_product_context from
RESOLVER.md § KNOWLEDGE_BRIDGE. Flag any known recurring pattern
against this feature as a known risk, not a new finding.

After review complete — call write_feature_note with status="built",
filling in prism_score and pv_classification from the feature's
COMPASS record if it exists.

If a new recurring pattern is detected (same class of issue seen 3+
times in this project's review history) call write_pattern_note.

If a bridge call fails do not abort — log and continue.
===========================================

Run Atlas phase 6 only for: $ARGUMENTS

Post-feature checklist for the named feature:

Step 1: Regression check — dependency diff on changed files
Step 2: Quick visual test on this feature
Step 3: Edge case scan on changed files
Step 4: Security + reliability check on changed files
Step 5: Design consistency check against DESIGN.md
Step 6: CodeRabbit review (if installed)
Step 7: Update PRODUCT.md and DESIGN.md with changes
Step 8: Terminology check against VOICE.md
Step 9: Basic SEO check (title, meta, H1, indexing)
Step 10: UX empathy check (Group 1 and Group 2 friction)

Give verdict: READY / NEARLY READY / NOT READY

STEP 11 - AUTOMATED REVIEW PIPELINE:
After the post-feature checklist passes, offer to trigger the full
review cycle automatically.

Display:

  POST-FEATURE CHECKLIST COMPLETE
  Starting automated review pipeline
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  This will run:
  1. Pre-review gates (secrets, deps, build, tests, lint, impact)
  2. CodeRabbit code review
  3. Visual browser test
  4. Fix approval flow
  5. Documentation check
  6. Merge readiness assessment

  Estimated time: 10-30 minutes depending on code size and
  CodeRabbit speed.

  Start now?  Type yes / later

If yes: run /review-cycle with the feature name as argument.

STEP 12 - DEPLOY PROMPT:
After /review-cycle completes and branch is merged:

  Feature merged successfully.

  Deploy to production?
  Type yes to run /deploy
  Type later to deploy manually
  Type no to skip

If yes: run /deploy with the feature name as argument.
