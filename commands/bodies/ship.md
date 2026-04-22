---
name: ship
description: Lightweight daily driver for small commits that do not need the full review cycle. Quick check, generated commit message, commit with approval and push. For tweaks, copy changes, small fixes.
allowed-tools: Bash, mcp__chrome-devtools__*
---
$ARGUMENTS can describe what was changed. If empty detect from git diff.

DECISION GUIDE:
USE /ship WHEN: typo, copy change, small UI tweak, minor bug fix in
non-critical area, docs update, config change, adding a test.

USE /review-cycle INSTEAD WHEN: new feature, auth/payment/security changes,
database schema changes, API endpoints added/modified, major refactor.

STEP 1 - CHECK WHAT CHANGED:
Run `git status --porcelain` and `git diff --stat HEAD`.
If no changes: "Nothing to ship. No uncommitted changes." Stop.

STEP 2 - QUICK SECRETS SCAN:
Scan changed files only for patterns: sk_live_, pk_live_, ghp_, gho_,
ghu_, AKIA, AIza, Bearer [long-string], password=, secret=, api_key=,
*_SECRET, *_KEY in non-example files.
If found: STOP immediately. Same rules as /review-cycle GATE 1.

STEP 3 - BUILD CHECK (FAST):
Run build with 30 second timeout. If fails ask fix-or-skip.

STEP 4 - QUICK BROWSER CHECK:
If Chrome connected do 10 second visual spot check on primary changed area.
Not a full test. Just confirm nothing is obviously broken.

STEP 5 - GENERATE COMMIT MESSAGE:
Read git diff. Generate conventional commits format:
type(scope): description

Types: feat, fix, docs, style, refactor, test, chore, perf.

Examples:
- fix(auth): correct session timeout handling
- feat(dashboard): add export button
- docs(readme): update installation steps
- style(landing): fix button alignment

Offer 3 message options from the diff. Ask: 1/2/3 or custom.

STEP 6 - COMMIT AND PUSH:
Display READY TO SHIP panel: count files, chosen message, current branch,
push target platform + remote. Wait for explicit yes.

Execute:
  git add -A
  git commit -m "[message]"
  git push origin [CURRENT_BRANCH]

Show SHIPPED panel: commit hash, message, branch, URL to commit on platform.

STEP 7 - ATLAS QUICK UPDATE:
Silently update $HEALTH_MD with ship timestamp. Note as minor change,
not a full feature.
