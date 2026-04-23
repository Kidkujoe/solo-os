---
name: review-cycle
description: Full automated review pipeline. Runs pre-review gates, detects and fires CodeRabbit, shows live progress, presents findings for approval, applies fixes, verifies, creates PR and requests merge when all clear.
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

===========================================
KNOWLEDGE BRIDGE HOOKS (v2.3.0)
===========================================

If OBSIDIAN_BRIDGE=on (STEP R8):

At the start — call read_pattern_context from RESOLVER.md §
KNOWLEDGE_BRIDGE. Display the list of known patterns so CodeRabbit
findings that match a known pattern are tagged as recurring.

On completion — call write_review_note with feature, branch, date,
quality_score, counts by severity, and the merge commit hash if
merged.

If the cycle detects a recurring finding (same issue class has
appeared in ≥3 prior reviews in this project) call write_pattern_note
with instances pulled from the Reviews/ history.

If a bridge call fails do not abort — log and continue.
===========================================

Running full review cycle for: $ARGUMENTS

The review cycle runs 11 stages. Each stage must complete before the
next begins. At any stage, critical failures halt the pipeline.

STAGE 1 - CODERABBIT + GIT DETECTION:

CodeRabbit detection sequence:
D1. Check CLI: run `which coderabbit` and `coderabbit --version`.
    If found: CR_CLI=true, record version and path.
D2. Check GitHub App: parse `git remote get-url origin` for platform,
    owner, repo. Fetch https://api.github.com/repos/[owner]/[repo]/installations
    to check if CodeRabbit app is listed. If yes: CR_GITHUB_APP=true.
D3. Check VS Code extension: if VSCODE_PID set or TERM_PROGRAM=vscode,
    run `code --list-extensions | grep -i coderabbit`.
D4. Check .coderabbit.yaml in project root.
D5. Determine best route:
    - Local/uncommitted changes → CLI (fast feedback)
    - Pushed or PR expected → GitHub App (thorough)
    - Neither found → offer installation
D6. Display detection results and recommendation.

Save to $PROJECT_CONTEXT/cr-detection.json.

Git platform detection:
- Run `git remote get-url origin`, parse platform (github/gitlab/bitbucket)
- Run `git remote show origin | grep 'HEAD branch'` for DEFAULT_BRANCH
- Run `git branch --show-current` for CURRENT_BRANCH
- Run `git status --porcelain` for uncommitted changes
- Run `git log origin/[current]..HEAD --oneline` for unpushed

Cache all to $PROJECT_CONTEXT/git-config.json.
Display GIT CONTEXT panel: platform, remote, branch, target, uncommitted, unpushed.

STAGE 2 - PRE-REVIEW GATE (6 gates):

GATE 1 - SECRETS SCAN (mandatory, no skip):
Scan all changed files for API keys, tokens, passwords, connection strings.
Patterns: sk_live_, pk_live_, ghp_, gho_, ghu_, AKIA, AIza, Bearer,
password=, secret=, api_key=, *_SECRET, *_KEY in non-example files.
If found: STOP PIPELINE. Show file:line, rotation guidance, .gitignore action.

GATE 2 - DEPENDENCY AUDIT:
If package.json: `npm audit --json`, parse HIGH and CRITICAL.
If requirements.txt: `pip audit --json`.
If Gemfile: `bundle audit`.
If Critical or High > 0: offer auto-fix or skip-with-risk.
Check new packages for: <500 weekly downloads, >2y since update, any CVE.

GATE 3 - BUILD CHECK:
Detect build command from package.json scripts.
Run with 60s timeout. Stream output.
If fails: ask fix-or-skip.

GATE 4 - TEST SUITE:
Detect test command (jest, vitest, pytest, rspec, go test, mocha).
Run with 120s timeout.
If fails: show which tests, ask fix-or-skip.

GATE 5 - LINT:
Detect linter (eslint, prettier, pylint, rubocop).
Run with max-warnings=0.
If errors and auto-fix available: offer to run it.

GATE 6 - IMPACT ASSESSMENT:
Run `git diff [DEFAULT_BRANCH]..HEAD --name-only`.
Classify:
- HIGH RISK: auth, session, login, password, token, permission, role,
  middleware, security, payment, checkout, billing, stripe, subscription,
  database, migration, schema, API endpoints, env/config files
- MEDIUM RISK: business logic, state management, API clients
- LOW RISK: UI, styling, tests, docs

Display gate summary: all clear / proceed with caution / blocked.

STAGE 2B - MIGRATION CHECK (if schema changed):
Before commit, if any schema or migration files changed:
Run /migrate logic in preview mode silently.
If dangerous operations detected (DROP, TRUNCATE, ALTER that could
lose data): flag prominently before commit, ask user to review
migration plan before proceeding.

STAGE 3 - COMMIT CHANGES:
If uncommitted changes exist: suggest commit message based on diff.
Ask yes/edit/custom. After confirmation: `git add -A`, `git commit -m`.
Show commit hash.

STAGE 4 - PUSH:
Display CONFIRM PUSH panel: branch, platform, owner/repo, commits.
Wait for yes. After push show PUSH CONFIRMED: branch, platform, hash,
message, URL to branch on platform.

STAGE 5 - CODERABBIT REVIEW:
If using CLI: run `coderabbit review`. Stream output live.
Update finding counts in real time.
If using GitHub App: run `gh pr create --title "[feature]" --body "..."
--base [DEFAULT_BRANCH]`. Poll PR reviews endpoint every 30s.
Show elapsed time, check count, streaming findings.

Progress display:
  CODERABBIT REVIEW IN PROGRESS
  Using: [CLI v[ver] / GitHub App]
  Branch: [name]  Files: [count]
  Status: [Connecting / Scanning / Analysing / Generating]
  Progress: [=====>    ]  Elapsed: [mm:ss]
  Findings: Critical [X]  High [X]  Medium [X]  Info [X]
  Currently reviewing: [file]

Desktop notification on completion if review took >60s.

STAGE 6 - VISUAL BROWSER TEST:
Run quick test mode on the feature (same as /test-quick but scoped).
Combine findings with CodeRabbit findings in unified view.

STAGE 7 - REVIEW QUALITY CHECK:
Score the review itself out of 100:
- Coverage: -20 if any changed files not reviewed
- Confidence: -10 if predominantly uncertain language
  ("might", "possibly", "consider")
- Distribution: -15 if any high-risk file has zero findings (suspicious)
- Completeness: -25 if review did not complete (timeout, error, truncated)
- Speed: -10 if review took <30s (too fast to be thorough)

Classification: 80-100 THOROUGH, 60-79 ADEQUATE, 40-59 PARTIAL,
<40 INSUFFICIENT. Below 60 blocks merge approval.

STAGE 8 - FINDINGS AND FIXES:
Present findings grouped by severity (Critical first). For each:
- SEVERITY and title
- File:line
- Issue description in plain English
- Current code snippet
- Proposed fix
- Impact if not fixed
- Risk of fix (LOW/MEDIUM/HIGH)
- Ask: yes / no / edit / later

Apply approved fixes. Run Test Agent to verify each fix in browser
before moving to next.

STAGE 9 - DOCUMENTATION CHECK:
- README: feature mentioned? Anything outdated?
- CHANGELOG.md: updated for this feature?
- Code comments: complex sections commented? Any comment lies?
- API docs: new endpoints documented?

Offer to update docs.

STAGE 10 - REVIEW HISTORY:
Append to $PROJECT_CONTEXT/REVIEWS.md using the sign-off record format:
feature-name, date, branch, status, all gate results, CodeRabbit details
(tool, duration, files, quality score, findings, fixed, skipped), visual
test result, documentation status, merge details.

Detect recurring findings: if same finding category appears 3+ times
across reviews, offer to add code standard, suppress in .coderabbit.yaml,
or just note it.

STAGE 11 - MERGE READINESS:
Run the /merge-ready logic on this branch.
Display final status:

  REVIEW CYCLE COMPLETE
  Feature: [name]  Branch: [name]
  Pre-review gates: [PASSED]
  CodeRabbit review: [COMPLETE]
  Review quality: [X]/100
  Visual test: [PASSED]
  Fixes applied: [count]
  Docs updated: [yes/no]
  Overall: [READY / NEARLY / NOT]

If READY: ask "Shall I create PR and request merge to [DEFAULT_BRANCH]?"
Wait for explicit yes before proceeding.

CONFIGURATION:
If no .coderabbit.yaml exists offer to create default for project type:
- profile: balanced
- auto_review enabled (not on drafts)
- path_instructions for auth/payment files (max security scrutiny)
- ignore: *.md, node_modules, dist, build, .env*
