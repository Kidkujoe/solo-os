---
name: atlas-quick
description: Quick Atlas refresh — update context and tell me what to do next
allowed-tools: Bash, mcp__chrome-devtools__*
---
===========================================
KNOWLEDGE BRIDGE HOOKS (v2.3.0)
===========================================

If OBSIDIAN_BRIDGE=on (STEP R8):

At the start — call read_product_context from RESOLVER.md §
KNOWLEDGE_BRIDGE. Surface recent notes and Inbox items so the
recommendation is informed by accumulated context.

After recommendation — if the user confirms a strategic decision
call write_decision_note.

If a bridge call fails do not abort — log and continue.
===========================================

Run Atlas phases 1 and 7 only.
Refresh context from changed files and give one clear recommendation.
No full scan. Fast.

Read all Atlas context files silently.
Check files modified since last Atlas run timestamp in HEALTH.md.
Update any context that has drifted from the code.
Then ask: What are you focused on today?
Give the recommendation with health score and trend.
