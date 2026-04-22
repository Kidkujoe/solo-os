---
name: addaccount
description: Manually save test account details for a project
allowed-tools: Bash
---
Ask the user these questions one at a time:

1. What project is this for?
   What is the project folder name?

2. What is the test account email?

3. What type of authentication does this project use?
   A: Password only
   B: Magic link only
   C: Both password and magic link
   D: OAuth only like Google or GitHub
   E: Combination - please describe

4. If password - what is the password?

5. If magic link - where do emails go locally?
   A: Mailhog at localhost:8025
   B: Mailpit at localhost:8025
   C: Mailtrap web interface
   D: MailDev at localhost:1080
   E: Printed to terminal console
   F: Other - please describe
   G: Not set up yet

6. Is there a magic link bypass variable in your environment?
   If yes what is it called?

7. What role or access level does this account have?
   Example: admin, premium, standard user

8. How was this role granted?
   Example: manually in database, seed script, admin panel

9. Any notes or quirks about this account?

Save all answers to $GLOBAL_ACCOUNTS (filter by PROJECT_ID)

Format:
---
Project: [name]
Folder: [path]
Email: [email]
Auth type: [type]
Password: [password or none]
Magic link catcher: [tool and url or none]
Magic link bypass variable: [name or none]
Role: [role]
Role granted via: [method]
Date added: [date]
Notes: [notes]
---

Confirm when saved and show what was stored.
