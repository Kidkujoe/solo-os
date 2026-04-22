---
name: projects
description: List all projects that have Visual-Test-Pro context data.
allowed-tools: Bash
---

Read ~/.claude/context/projects/ and list every project folder found.

For each project folder show:
- Project ID
- Project name (basename before the hash suffix)
- Last active (last modified date of any file in the folder)
- Data size (total folder size)
- Atlas exists (PRODUCT.md present?)
- Last test date (from HEALTH.md or test-session.md if exists)
- Last audit date (from HEALTH.md if exists)

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  YOUR PROJECTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [count] projects with context data

  [Project name]
  ID: [project-id]
  Last active: [date]
  Data: [size]
  Atlas: [yes/no]
  Last test: [date or never]

  [Continue for each project]

  Total context data: [total size]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If $ARGUMENTS is "clean [project-name]":
Show what will be deleted and ask for confirmation before removing.

If $ARGUMENTS is "detail [project-name]":
Show full file listing with sizes for that specific project.
