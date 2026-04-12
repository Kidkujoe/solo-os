---
name: status
description: Get a snapshot of the current test session at any point
allowed-tools: Bash
---

Read ~/.claude/context/test-session.md
Read ~/.claude/context/test-accounts.md
Read ~/.claude/context/agent-state.json if it exists

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
