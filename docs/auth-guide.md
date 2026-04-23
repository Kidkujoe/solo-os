# Authentication Guide

A complete plain English guide to how solo-os handles logins and restricted areas.

## What are restricted areas

Restricted areas are pages in your app that need a login to access. Things like dashboards, settings pages, admin panels, user profiles, and account management pages. If someone tries to visit these pages without being logged in, they usually get redirected to a login page.

Most apps have at least some restricted areas. Testing them is important because that is where the real functionality lives — and where bugs hide.

## The test account system

solo-os uses a simple file on your machine to store test account details. When you save a test account with `/addaccount`, the details are written to `~/.claude/context/test-accounts.md`. This file stays on your machine and is never uploaded anywhere.

The account file stores:
- Which project the account is for
- The email address
- What type of login is used (password, magic link, or both)
- The password if there is one
- Where magic link emails go
- Whether there is a bypass variable
- The account's role (admin, user, premium, etc.)
- Any notes or quirks

## How password login works

When Claude needs to log in to a restricted area with a password, it follows this order:

1. **Check saved accounts** — Looks in test-accounts.md for this project
2. **Use saved credentials** — If found, navigates to the login page and types in the email and password
3. **Check for success** — Verifies the login worked by checking if it reached the restricted page
4. **If login fails** — Tries the credentials once more in case of a timing issue
5. **If still failing** — Stops and tells you the saved credentials are not working

If there are no saved credentials:
1. **Look for seed scripts** — Checks your project for test user setup scripts
2. **Try the signup page** — Attempts to create a new account through your app
3. **If signup works** — Saves the new credentials for future sessions
4. **If nothing works** — Asks you to provide credentials or use `/addaccount`

## How magic link login works

Magic links are login links sent by email instead of using a password. They are common in modern apps. Claude handles them like this:

1. **Check saved accounts** — Looks for this project in test-accounts.md
2. **Check for bypass variable** — Some projects have an environment variable that lets you skip the email step during development. Claude checks your .env files for this.
3. **If bypass exists** — Uses it to generate a login link directly, skipping the email
4. **Check email catchers** — If no bypass, Claude looks for a local email catching tool:
   - Mailhog at localhost:8025
   - Mailpit at localhost:8025
   - MailDev at localhost:1080
   - Console output
5. **Request the magic link** — Enters the email on your login page to trigger the magic link email
6. **Grab the link** — Opens the email catcher, finds the email, and extracts the magic link
7. **Use the link** — Opens the magic link in Chrome to complete the login
8. **If no email catcher** — Tries to generate a magic link token directly from the database
9. **If nothing works** — Asks you to help

## What local email catchers are

When your app sends an email (like a magic link), it normally goes to a real email address. During development, you do not want real emails being sent. A local email catcher intercepts these emails and shows them in a simple web interface on your machine.

Think of it like a mailbox that catches every email your app sends, without them actually going anywhere. You can open the web interface and see the emails, click the links in them, and verify they work.

Popular email catchers:
- **Mailhog** — Simple and common. Runs at localhost:8025.
- **Mailpit** — A modern replacement for Mailhog. Same address.
- **MailDev** — Another alternative. Runs at localhost:1080.

If your app sends magic links and you do not have an email catcher set up, Claude will tell you and suggest installing one.

## What a magic link bypass variable is

Some developers add a shortcut to their app for development. Instead of sending an actual email, the app checks for a special environment variable. If it exists, the app generates the login link directly and either prints it to the console or returns it from the API.

For example, your `.env` file might have something like:
```
MAGIC_LINK_BYPASS=true
```

When Claude finds this, it can trigger the login and grab the link without needing an email catcher at all. This is the fastest way to handle magic link auth during testing.

## When Claude asks for your help

Claude will stop and ask you when:

- **No credentials found** — There is no saved account and it could not create one automatically
- **Saved credentials not working** — The password might have changed or the account might be disabled
- **No email catcher running** — Magic link emails have nowhere to go
- **Magic link not arriving** — The email catcher is running but no email appeared
- **Magic link expired** — The link was found but it expired before Claude could use it
- **Cannot access the database** — Claude tried to generate a token directly but could not connect

When this happens, Claude tells you exactly what it tried and gives you options:
1. Provide credentials manually
2. Run `/addaccount` to save details
3. Skip restricted areas and test only public pages
4. Grant access another way (like logging in yourself and sharing the session)

## All the options when Claude is stuck

If Claude cannot get past a login, you have several choices:

- **Paste a magic link** — If you can trigger one yourself, paste the URL
- **Provide email and password** — Claude will try logging in with what you give
- **Log in yourself** — Log in using Chrome yourself, then tell Claude to continue. It will use your active session.
- **Use /addaccount** — Save proper credentials for next time
- **Skip restricted areas** — Test only what is publicly accessible
- **Set up an email catcher** — Install Mailhog or Mailpit, then run `/resume`
- **Add a bypass variable** — Add one to your .env and run `/resume`

## How /addaccount works

Type `/addaccount` and Claude walks you through a series of questions:

1. Which project is this for?
2. What is the test email?
3. What type of auth? (password, magic link, both, OAuth)
4. What is the password? (if applicable)
5. Where do magic link emails go? (if applicable)
6. Is there a bypass variable?
7. What role does this account have?
8. How was the role set up?
9. Any notes?

The answers are saved to test-accounts.md. Next time you run `/test` on that project, Claude uses these details automatically.

## How saved accounts work across sessions

Your saved accounts persist between sessions. If you save an account today and test again next week, Claude still has the credentials. They are stored in a plain text file on your machine at `~/.claude/context/test-accounts.md`.

You can save accounts for multiple projects. Claude matches them by project folder name.

To update an account, just run `/addaccount` again for the same project. The new entry will be added alongside the old one — Claude uses the most recent entry.

## Magic link security checks

Even when testing, Claude reviews how your magic link system works. This matters because magic links are a common target for attackers. Claude checks:

- **Token randomness** — Is the token random enough that someone cannot guess it? Good tokens use UUID plus random bytes. Bad tokens use sequential numbers or timestamps.
- **Token expiry** — Does the link expire? Good systems expire links in 10-30 minutes. No expiry means a stolen link works forever.
- **Single use** — Can the link only be used once? Good systems mark the token as used after login. Reusable links are a security risk.
- **Rate limiting** — Can someone spam the system with link requests? Good systems limit how many links can be generated per minute.
- **Email scoping** — Is the token tied to a specific email? Good systems connect the token to a user. Bad systems let anyone use any token.
- **Enumeration protection** — Can someone figure out valid emails by watching the response? Good systems give the same response whether the email exists or not.

These checks appear in your test report under the security section.

## What the access badges in the report mean

The HTML report shows how Claude accessed each area:

- **Fully Tested** (green) — Claude got in and tested everything on this page
- **Partially Tested** (amber) — Claude could see the page but could not test all functionality (for example, could view but not edit)
- **Could Not Access** (red) — Claude could not get past the login for this area
- **Skipped** (grey) — This area was skipped by your choice or because it was not relevant to the test mode selected

Each badge also shows the method used: "Logged in with saved password", "Used magic link from Mailhog", "Generated token from database", etc. This helps you understand exactly how each area was reached.
