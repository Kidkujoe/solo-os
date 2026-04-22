---
name: screenshots
description: Manage screenshots from all test sessions
allowed-tools: Bash
---
Read the screenshots folder at:
$SCREENSHOTS/

Display a summary:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCREENSHOT MANAGER
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total screenshots: [count]
  Total size: [size]
  Oldest session: [date]
  Newest session: [date]

  BY PROJECT:
  [project name]
    [date] session: [count] screenshots [size]

  OPTIONS:
  1. Delete all screenshots older than 7 days
  2. Delete all screenshots older than 30 days
  3. Delete screenshots for a specific project
  4. Delete all screenshots everywhere
  5. Archive old sessions to zip files
  6. Open the screenshots folder
  7. Show me what is in a specific session

  Type a number to choose.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for user to choose.

Never delete anything without confirming exactly
what will be deleted and how much space will be freed.

For option 1 or 2:
List every session that would be deleted with its
date, project name, screenshot count and size.
Ask: Delete these [count] sessions? Type yes to confirm.

For option 3:
List all projects with sessions. Ask which project.
Then list all sessions for that project. Confirm before deleting.

For option 4:
Show total count and size. Warn this cannot be undone.
Confirm twice before deleting.

For option 5:
Compress each session folder older than 7 days to zip.
Delete the original folders after successful compression.
Show space saved.

For option 6:
Open the screenshots folder in the file explorer.

For option 7:
List all sessions. Ask which one.
List every screenshot in that session with filename,
size, and what page or element it shows.
