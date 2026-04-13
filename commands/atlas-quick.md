---
name: atlas-quick
description: Quick Atlas refresh — update context and tell me what to do next
allowed-tools: Bash, mcp__chrome-devtools__*
---

Run Atlas phases 1 and 7 only.
Refresh context from changed files and give one clear recommendation.
No full scan. Fast.

Read all Atlas context files silently.
Check files modified since last Atlas run timestamp in HEALTH.md.
Update any context that has drifted from the code.
Then ask: What are you focused on today?
Give the recommendation with health score and trend.
