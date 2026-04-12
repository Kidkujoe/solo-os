---
name: resume
description: Resume a test session from where it left off or after granting access
allowed-tools: Bash, mcp__chrome-devtools__*
---

Read ~/.claude/context/test-session.md
Read ~/.claude/context/test-accounts.md

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

Then ask:
1. Continue from where we left off
2. Start a specific section again
3. Retry a restricted area I have now granted access to
4. Jump to the final report
5. Start completely fresh

Wait for response before doing anything.
If user provides new credentials or confirms access has been granted, use them immediately and continue from the paused section.
