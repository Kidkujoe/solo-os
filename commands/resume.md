---
name: resume
description: Resume a test session from where it left off or after granting access
allowed-tools: Bash, mcp__chrome-devtools__*
---

Read ~/.claude/context/test-session.md
Read ~/.claude/context/test-accounts.md
Read ~/.claude/context/agent-state.json if it exists

Display a clean summary:
Session started: [time]
Project: [project name]
What is being tested: [description]
Auth type detected: [type]
Test account: [email if exists]

Sections completed:
[list each completed section]

Issues found: [count]
Issues fixed: [count]
Issues still needing attention: [count]

Current confidence score: [score]/10

Where we paused: [reason if paused]

If agent-state.json has an incomplete session for this
project, also display the full agent team status:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGENT TEAM STATUS WHEN PAUSED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [emoji] [agent name]  [status] - [task]
  [for each agent that was active]

  Fixes completed and verified: [count]
  Fixes in progress when paused: [count]
  Fixes still to do: [count]

  FILES BEING EDITED WHEN PAUSED:
  [list any files with in_progress claims]

  BLOCKED FIXES: [count waiting for user]
  UNREAD AGENT MESSAGES: [count]
  PENDING CONFLICTS: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If there are unread agent messages show them:

  UNREAD AGENT MESSAGES:
  [Agent A] -> [Agent B] (sent before pause):
  [message content]

Then ask:
1. Continue from where we left off
   Restart all in-progress agent work
   Continue from current position
2. Start a specific section again
3. Retry a blocked fix — I have now
   granted access or have more context
   [Show what agent was blocked and why]
4. Jump to the final report
5. Start completely fresh

Wait for response before doing anything.

If user chooses 1 and agents were active:
Re-spawn agents from their saved state.
Show each agent waking up:

  Waking up agent team...

  [emoji] [agent name]  Restored
  [for each agent, noting any unread messages]

  Continuing from where we left off...

If user chooses 3 and a fix was blocked:
Show the blocked fix details from agent-state.json.
Accept new context from the user.
Re-spawn the blocked agent with the new context.
Other agents continue from their saved state.

If user provides new credentials or confirms access
has been granted, use them immediately and continue
from the paused section.
