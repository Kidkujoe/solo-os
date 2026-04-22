---
name: deploy
description: Detects deployment platform, triggers deployment, monitors progress, verifies the deployed version works and handles rollback on failure.
allowed-tools: Bash, mcp__chrome-devtools__*
---
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
