---
name: status
description: Get a snapshot of the current test session at any point
allowed-tools: Bash
---
Read $PRODUCT_MD silently if it exists
Read $SESSION_FILE
Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
Read $AGENT_STATE if it exists

Display:
Session started: [time]
Project: [name]
Testing: [what]
Auth type: [type]
Test account: [email or none]

Progress:
[tick] Section 1 Visual Testing - [status]
[tick] Section 2 Code Review - [status]
[tick] Section 3 Console Monitoring - [status]
[tick] Section 4 Responsive - [status]
[tick] Section 5 Accessibility - [status]
[tick] Section 6 CodeRabbit - [status]
[tick] Section 7 Edge Cases - [status]
[tick] Section 8 Fix Team - [status]
[tick] Section 9 HTML Report - [status]

Restricted areas:
[list each restricted area and access status]

Issues found: [count]
Issues fixed: [count]
Warnings remaining: [count]
Current confidence score: [score]/10
Currently on: [current section]
Next up: [what comes next]

If agent-state.json exists and has data for this project:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGENT TEAM STATUS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [emoji] [agent name]  [status] [current task]
  [for each agent in the state file]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Agent messages: [count] ([unread] unread)
  Conflicts: [count pending]
  Blocked fixes: [count waiting for user]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Files currently claimed:
  [filename] — [agent name] ([reason])
  [for each claimed file]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If there are blocked fixes show:
  BLOCKED — NEEDS YOUR INPUT:
  [issue description] — [agent name] waiting
  Type /resume to address this

REVIEW STATUS:
Read $PROJECT_CONTEXT/REVIEWS.md if it exists.
Run `git branch` to get all branches.

Display:

  REVIEW STATUS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Open branches:        [count]
  Ready to merge:       [count]
  Review in progress:   [count]
  Fixes needed:         [count]
  Conflicts detected:   [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If any branch is ready to merge:
  [branch-name] is ready to merge.
  Run /merge-ready [branch] to proceed.

If any review is stale (>48h old):
  [branch-name] review is [X] hours old.
  Consider re-running /review-cycle.

ASYNC CODERABBIT REVIEW POLLING:
Async CodeRabbit review completion is only detected when /status or
/reviews is run. It is NOT checked in the background between sessions.

For each branch with an open PR:
Fetch: GET /repos/[owner]/[repo]/pulls/[pr-number]/reviews
Compare against last recorded state.

If a CodeRabbit review completed since last check:

  CODERABBIT REVIEW READY
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Branch: [name]
  PR: [url]
  Findings: [count] ([severity breakdown])
  Completed: [timestamp]

  Run /review-cycle [branch] to review findings and apply fixes.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DEPLOYMENT STATUS:
Last deploy: [timestamp or NEVER]
Platform: [detected or UNKNOWN]
Production URL: [url or NOT SET]
Post-deploy smoke test: [PASSED / FAILED / NOT RUN]

DEPENDENCY HEALTH:
Last /deps run: [date or NEVER]
Outdated packages: [count or UNKNOWN]
Security vulnerabilities: [count or UNKNOWN]
If never run: "Run /deps for a health check"

ENVIRONMENT:
Last /env-diff run: [date or NEVER]
Missing in production: [count or UNKNOWN]
If never run: "Run /env-diff to verify"

PERFORMANCE:
Last /performance run: [date or NEVER]
Performance score: [value or NEVER RUN]
If not run in 30+ days: "Run /performance for up-to-date scores"
