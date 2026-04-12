# How visual-test-pro Works

A plain English walkthrough of the full system for someone using it for the first time.

## What happens when you type /test

When you type `/test` in Claude Code, the system wakes up and starts by reading two files on your machine. One tracks the current test session and the other stores any login details you have saved. This is how Claude remembers where it left off and how to get into your app.

## The project scan

Before testing anything, Claude scans your project folder. It looks at your package.json, finds your framework (Next.js, React, Vue, whatever you use), detects your authentication setup, checks for a database, and maps out all the pages in your app. It also figures out which pages need a login to access. This scan takes a few seconds and gives Claude a complete picture of what needs testing.

## The options menu

After scanning, Claude shows you a menu with four choices:

1. **Quick Check** — Just looks at public pages. No code review. Low token cost. Good for daily use during development.
2. **Standard Test** — Tests everything including pages behind a login. Does a code review. Generates an HTML report. Good for end of sprint reviews.
3. **Deep Test** — Everything in Standard plus a CodeRabbit sweep, comprehensive code review, and full accessibility audit. High token cost. Best before a launch.
4. **Custom** — You pick exactly what to include.

Choose the one that fits what you need right now. You can always run a different mode later.

## The confirmation before starting

Claude shows you exactly what it plans to do — how many pages it will test, whether it will try restricted areas, whether it will do a code review. It asks you to confirm before starting. Nothing happens until you say yes.

## How each section works

### Visual testing

Claude opens your app in Chrome and goes through every page. It clicks buttons, fills in forms with realistic data (not "test123"), submits forms to check validation, scrolls through everything, and takes screenshots. It is looking for things that are broken, missing, or do not look right.

### Responsive checks

Claude resizes the browser to desktop (1440px), tablet (768px), and mobile (375px) widths. It takes screenshots at each size and notes any layout problems like text overflow, elements overlapping, or navigation breaking.

### Console monitoring

While testing, Claude watches the browser console for errors, warnings, and failed network requests. If something takes more than 2 seconds to load, it flags that too.

### Accessibility

Claude checks the basics: images have alt text, buttons have labels, text contrast looks reasonable, form inputs have associated labels. This is not a full WCAG audit but catches the most common problems.

### Code review

Claude reads through your key files looking for security issues (like unprotected API routes or SQL injection risks), bugs, and code quality problems. Every issue gets a severity level: Critical, High, Medium, or Low.

## How issues are found and shown

Each issue Claude finds gets a plain English description. No jargon. It tells you what the problem is, why it matters, and what to do about it. Critical issues are shown in red, warnings in amber.

## How the fix decision works

Claude never fixes anything without asking first.

For critical issues, it explains the problem, shows you exactly what it plans to change, warns you about any side effects, and waits for your permission.

For high issues, it recommends a fix and asks.

For medium and low issues, it just lists them in the report for you to handle when you are ready.

## How side effect warnings work

Before making any change, Claude thinks about what else might be affected. If fixing a security issue in your login system might change how the login page looks or behaves, Claude tells you that upfront. You get to decide whether the fix is worth the side effect.

## How the HTML report is generated

After all testing is done, Claude builds a single HTML file with everything it found. The report uses clean styling and plain English throughout. You can open it in any browser and share it with anyone — they do not need to be technical to understand it.

You can also generate or regenerate the report at any time by typing `/report`. This is separate from the testing so it does not use extra tokens for retesting.

## How memory works across sessions

Claude stores three things on your machine:

- **test-session.md** — What happened during the current or last test
- **test-accounts.md** — Login details you saved with `/addaccount`
- **test-data.json** — Structured findings data

When you start a new test, Claude checks these files and asks if you want to continue the last session or start fresh. Your saved test accounts persist across sessions so you never have to enter them again.

## How to use /resume and /status

**`/resume`** shows you where the last session left off and gives you five options: continue from where it stopped, redo a specific section, retry a restricted area with new access, jump straight to the report, or start completely fresh.

**`/status`** gives you a snapshot at any time during a test. It shows which sections are done, how many issues were found, what has been fixed, and what comes next. Useful if you lose track or want a quick update.

## How restricted areas are handled

When Claude finds a page that needs a login, it works through a sequence of attempts:

1. Uses saved credentials from `/addaccount` if they exist
2. Looks for seed scripts or test user setups in your project
3. Tries signing up through your app's signup page
4. For magic links: checks local email catchers, then bypass variables
5. If nothing works: stops and asks you for help

Claude never forces past a login or guesses credentials. If it cannot get in, it tells you what it tried and gives you options.

## When Claude asks for your help

Claude will stop and ask you in these situations:

- It cannot log in after trying all methods
- It is unsure whether a fix should be applied
- Token usage is getting high and it needs your decision
- It found something unusual that needs your judgement
- A fix did not work and it needs guidance on what to try next

When Claude asks, it always explains why it is asking and what your options are. You are always in control.
