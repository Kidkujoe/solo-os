# Troubleshooting

Solutions to common problems, organised by what went wrong.

---

## Chrome Problems

### Chrome is not connecting

**What causes it:** Claude Code needs to connect to Chrome through a special extension. If Chrome is not open or the connection was not started, Claude cannot see or interact with your app.

**How to fix it:**
1. Make sure Chrome is open
2. Close Claude Code if it is running
3. Start Claude Code with Chrome enabled: `claude --chrome`
4. Try your test command again

**If that does not work:**
- Close Chrome completely (check your system tray — it sometimes runs in the background)
- Reopen Chrome
- Run `claude --chrome` again

### Extension is not showing

**What causes it:** The Chrome DevTools MCP extension may not be installed or registered.

**How to fix it:**
1. Run the installer again: `sh install.sh`
2. The installer will try to register the Chrome MCP server
3. If it fails, register it manually:
   ```
   claude mcp add chrome-devtools --scope user -- npx -y chrome-devtools-mcp@latest
   ```

**If that does not work:**
- Check your Node.js version is 18 or higher: `node -v`
- Try running `npx -y chrome-devtools-mcp@latest` on its own to see if there are errors

### Extension not signed in

**What causes it:** Some Chrome setups require the extension to be explicitly allowed.

**How to fix it:**
1. Open Chrome settings
2. Go to Extensions
3. Make sure all required extensions are enabled
4. Restart Chrome and try again

### Chrome needs updating

**What causes it:** Very old versions of Chrome may not support the DevTools protocol features needed.

**How to fix it:**
1. Open Chrome
2. Go to Settings > About Chrome
3. Let it update
4. Restart Chrome

### Wrong browser being used

**What causes it:** If you have multiple browsers installed, Claude might not be connecting to Chrome.

**How to fix it:**
1. Make sure Google Chrome (not Chromium, Brave, or Edge) is your default or is explicitly open
2. Close other browsers to avoid confusion
3. Run `claude --chrome` with Chrome as the only browser open

### WSL users on Windows

**What causes it:** WSL runs Linux inside Windows. Chrome runs on the Windows side, which can cause connection issues.

**How to fix it:**
1. Make sure Chrome is open on the Windows side
2. Run Claude Code from your WSL terminal
3. The MCP server should bridge the connection automatically
4. If not, try running Claude Code from a Windows terminal (Git Bash or PowerShell) instead

### Mac permission issues

**What causes it:** macOS may block Chrome automation features.

**How to fix it:**
1. Go to System Settings > Privacy & Security > Accessibility
2. Make sure your terminal app has permission
3. You may also need to allow it under Automation
4. Restart your terminal and try again

---

## CodeRabbit Problems

### Not installed

**What causes it:** CodeRabbit CLI is optional. If it is not installed, deep test mode skips the sweep.

**How to fix it:**
```
curl -fsSL https://cli.coderabbit.ai/install.sh | sh
```
Then restart your terminal.

### Not authenticated

**What causes it:** CodeRabbit needs to be authenticated before first use.

**How to fix it:**
1. Run `coderabbit auth` or `cr auth`
2. Follow the prompts to sign in
3. Try your test again

### Times out during review

**What causes it:** Large projects can take a while for CodeRabbit to analyse.

**How to fix it:**
1. Wait a bit longer — some projects take a few minutes
2. If it consistently times out, try running CodeRabbit separately: `cr review`
3. If that works, the timeout may be in the MCP connection — restart the session

### Returns no results

**What causes it:** CodeRabbit may not find any issues, or it may not support your language or framework.

**How to fix it:**
1. Check that CodeRabbit supports your project type
2. Try running `cr review` directly to see if it produces output
3. If it works directly but not through solo-os, report the issue

---

## Auth and Login Problems

### Test account cannot be created

**What causes it:** Your app's signup page may require email verification, have a captcha, or be disabled.

**How to fix it:**
1. Create the account manually in your app
2. Use `/addaccount` to save the credentials
3. Run `/test` again — Claude will use the saved account

### Login always fails

**What causes it:** Password may have changed, account may be disabled, or the login page may have changed.

**How to fix it:**
1. Try logging in manually in Chrome to verify the credentials work
2. If they do not work, update them with `/addaccount`
3. If they do work manually but Claude cannot log in, the login page may have changed — report the issue

### Magic link not arriving

**What causes it:** No local email catcher running, or the app is sending to a real email service.

**How to fix it:**
1. Install Mailhog: `brew install mailhog` (Mac) or download from GitHub
2. Start it: `mailhog`
3. Configure your app to use localhost:1025 as the SMTP server
4. Run `/resume` to continue testing

### Magic link expired

**What causes it:** The link was generated but Claude took too long to use it.

**How to fix it:**
1. This usually resolves on retry — Claude will request a new link
2. If it keeps happening, check your magic link expiry time (very short expiries like 1 minute can be tricky)
3. Consider adding a bypass variable to your .env for development

### Cannot find the email catcher

**What causes it:** The email catcher is running but on a different port than expected.

**How to fix it:**
1. Check what port your email catcher is running on
2. Use `/addaccount` to specify the correct URL
3. Common ports: 8025 (Mailhog/Mailpit), 1080 (MailDev)

### Database access denied

**What causes it:** Claude tried to generate a magic link token directly from the database but could not connect.

**How to fix it:**
1. Make sure your database is running
2. Check your .env has the correct database URL
3. If using a remote database, Claude may not have access — use a different login method

### Restricted page still blocked after login

**What causes it:** The login session may have expired, or the page requires a specific role.

**How to fix it:**
1. Check that the test account has the right role (admin, premium, etc.)
2. Use `/addaccount` to update the role information
3. If the page requires a specific permission, grant it to the test account in your database or admin panel

---

## Session Problems

### Claude lost track mid session

**What causes it:** Context compression or a long session can sometimes cause Claude to lose track of where it was.

**How to fix it:**
1. Type `/status` to see what has been completed
2. Type `/resume` to pick up from where it left off
3. All progress is saved in test-session.md so nothing is lost

### Session ran out of tokens

**What causes it:** The test used more tokens than available in the session window. This happens more with deep tests on large apps.

**How to fix it:**
1. Start a new session: `claude --chrome`
2. Type `/resume`
3. Claude will show what was completed and what is left
4. Choose to continue from where it stopped
5. To generate the report from completed data, type `/report` in a new session

### Cannot resume a session

**What causes it:** The test-session.md file may be empty or corrupted.

**How to fix it:**
1. Check the file: open `~/.claude/context/test-session.md`
2. If it is empty, there is no session to resume — start a new test
3. If it has content but `/resume` is not working, try reading the file manually and telling Claude what section to start from

### Test data file is empty or corrupted

**What causes it:** A session may have ended before the data could be saved properly.

**How to fix it:**
1. Check `~/.claude/context/test-data.json`
2. If it is empty or has invalid content, delete it
3. Create a new one: `echo "{}" > ~/.claude/context/test-data.json`
4. Start a new test

### Screenshots folder is missing

**What causes it:** The folder was deleted or was never created.

**How to fix it:**
```
mkdir -p ~/.claude/context/screenshots
```

---

## Fix Problems

### Fix was applied but did not work

**What causes it:** The fix may not have addressed the root cause, or there may be caching involved.

**How to fix it:**
1. Claude notes failed fixes in the report
2. Try refreshing the page hard (Ctrl+Shift+R)
3. Check if the dev server needs restarting
4. The issue will appear in the report as still needing attention

### Fix broke something else

**What causes it:** A fix had an unexpected side effect that the side effect warning did not predict.

**How to fix it:**
1. Check git for the change: `git diff`
2. Revert the change if needed: `git checkout -- [file]`
3. Report the issue so the side effect detection can be improved
4. Fix the issue manually instead

### Side effect warning was wrong

**What causes it:** Side effect prediction is not perfect. Sometimes a fix has no side effects when one was predicted, or vice versa.

**How to fix it:**
1. If the fix worked fine, just continue
2. If it caused an issue, revert and fix manually
3. This helps improve future predictions

### Claude cannot find the file to fix

**What causes it:** The project structure may be unusual, or the file may have been moved or renamed.

**How to fix it:**
1. Tell Claude the correct file path
2. Claude will try again with the right location

### Fix needs database changes

**What causes it:** Some fixes require schema changes or data migrations that Claude cannot do automatically.

**How to fix it:**
1. Claude will explain what database changes are needed
2. Make the changes yourself or use your migration tool
3. Type `/resume` to continue after the changes

---

## Report Problems

### HTML report did not open

**What causes it:** Chrome may not have opened the file automatically, or the file path may be wrong.

**How to fix it:**
1. Open the file manually: `~/.claude/context/test-report.html`
2. Double-click it in your file explorer — it opens in your default browser
3. Or type `/report` to regenerate and reopen it

### Report is blank or missing data

**What causes it:** The test session may not have saved properly, or the report was generated before testing finished.

**How to fix it:**
1. Check `~/.claude/context/test-session.md` has content
2. If it does, type `/report` to regenerate
3. If it is empty, you need to run a new test first

### Screenshots not showing in report

**What causes it:** The screenshots use file paths that may not resolve correctly in the browser.

**How to fix it:**
1. Check the screenshots folder: `ls ~/.claude/context/screenshots/`
2. If screenshots exist, the paths in the HTML may need updating
3. Type `/report` to regenerate with correct paths

### Report from wrong session showing

**What causes it:** The report file gets overwritten each time. If you generated a report for a different project, it replaced the old one.

**How to fix it:**
1. Before generating a new report, save the old one somewhere
2. Copy it: `cp ~/.claude/context/test-report.html ~/my-old-report.html`
3. Then type `/report` for the current session

---

## Installation Problems

### install.sh permission denied

**What causes it:** The script does not have execute permission.

**How to fix it:**
```
chmod +x install.sh
sh install.sh
```

### MCP server not registering

**What causes it:** The Claude CLI mcp command may have failed.

**How to fix it:**
1. Try registering manually:
   ```
   claude mcp add chrome-devtools --scope user -- npx -y chrome-devtools-mcp@latest
   ```
2. If that fails, check your Node.js version
3. Try running `npx -y chrome-devtools-mcp@latest` to see if there are errors

### Commands not showing after install

**What causes it:** The files may not have been copied to the right location.

**How to fix it:**
1. Check the files exist: `ls ~/.claude/commands/`
2. You should see test.md, test-quick.md, test-deep.md, report.md, resume.md, status.md, addaccount.md
3. If any are missing, run the installer again: `sh install.sh`

### Claude Code version too old

**What causes it:** solo-os requires Claude Code 2.0.0 or higher.

**How to fix it:**
```
npm update -g @anthropic-ai/claude-code
```

### Node version too old

**What causes it:** The Chrome MCP server requires Node.js 18 or higher.

**How to fix it:**
1. Check your version: `node -v`
2. Download the latest LTS from https://nodejs.org
3. Install it and restart your terminal
