---
name: deploy
description: Detects deployment platform, triggers deployment, monitors progress, verifies the deployed version works and handles rollback on failure.
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
