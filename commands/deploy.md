---
name: deploy
description: Detects deployment platform, triggers deployment, monitors progress, verifies the deployed version works and handles rollback on failure.
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

PHASE 1 - PLATFORM DETECTION:
Check for each platform's fingerprint:
- VERCEL: vercel.json, .vercel/, `which vercel`, VERCEL_TOKEN env
- NETLIFY: netlify.toml, .netlify/, `which netlify`, NETLIFY_AUTH_TOKEN
- RENDER: render.yaml, Render API token
- FLY.IO: fly.toml, `which flyctl`, FLY_API_TOKEN
- DIGITALOCEAN: .do/app.yaml, `which doctl`, DIGITALOCEAN_ACCESS_TOKEN
- RAILWAY: railway.json or railway.toml, `which railway`
- CUSTOM/VPS: Dockerfile, docker-compose.yml, deploy.sh, Makefile deploy target
- CI/CD: .github/workflows/*.yml, .gitlab-ci.yml (auto-deploy on push)

Display DEPLOYMENT PLATFORM DETECTION panel:
platform, CLI available, auth configured, config file, auto-deploy on push,
current production URL.

If no platform detected ask user to choose from numbered list:
Vercel, Netlify, Render, Fly.io, DigitalOcean, Railway, Custom/VPS, CI/CD.

Save to $PROJECT_CONTEXT/deploy-config.json.

PHASE 2 - PRE-DEPLOY CHECKS:
- BUILD VERIFICATION: successful build artifact exists? If not run build. If fails stop.
- MIGRATION CHECK: migration files newer than last deploy timestamp? Warn if yes.
- ENV VAR CHECK: run /env-diff silently. Warn if missing production vars.
- PERFORMANCE BASELINE: record current score from $HEALTH_MD for post-deploy comparison.

PHASE 3 - DEPLOY CONFIRMATION:
Display panel: platform, branch, commit hash + message, target Production, URL,
pre-deploy check results. Wait for explicit yes.

PHASE 4 - EXECUTE AND MONITOR:
Execute deploy command for detected platform:
- Vercel: `vercel --prod`
- Netlify: `netlify deploy --prod`
- Fly.io: `flyctl deploy`
- Railway: `railway up`
- DigitalOcean: `doctl apps create-deployment`
- Render: trigger via API
- Custom: `./deploy.sh` or `make deploy`

Stream output. Poll every 15 seconds if streaming not available.
Show: platform, started timestamp, elapsed, status (Building/Deploying/Warming/Live).

PHASE 5 - POST-DEPLOY VERIFICATION:
- AVAILABILITY: wait 30s for warmup, fetch production URL, verify HTTP 200. Retry after 60s if error.
- SMOKE TEST: open URL in Chrome, navigate critical user journey, confirm feature live, no console errors, loads under 5s.
- VERSION CHECK: if version endpoint or visible version number, verify matches expected commit.

Display DEPLOY COMPLETE panel: status, URL, duration, smoke test result, app loads, console errors, feature visible, overall verdict.

If smoke test fails show DEPLOY VERIFICATION FAILED panel with options:
1. Rollback to previous deploy (runs /rollback)
2. Investigate and fix forward
3. Keep current deploy and monitor

SAVE DEPLOY RECORD to $PROJECT_CONTEXT/REVIEWS.md: timestamp, platform,
commit hash, duration, smoke test result.
