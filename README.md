# visual-test-pro

A complete visual browser testing system for Claude Code that tests your app, finds issues, fixes what it can, and gives you a plain English HTML report.

## What this does

visual-test-pro turns Claude Code into a full testing assistant. It opens your app in Chrome, clicks through every page, fills in forms, checks responsive layouts, reviews your code for security issues, and writes everything up in a report anyone can read. If it finds something broken, it tells you what is wrong in plain English and asks before fixing anything. It remembers your test accounts and can pick up where it left off if a session gets interrupted.

## Why I built this

If you are a solo developer or bootstrapper shipping an app on your own, you probably do not have a QA team. You push code, hope it works, and move on. This tool gives you a proper test run before every launch without needing to hire anyone or learn a testing framework. Just type one command and Claude does the rest.

## What you get

| Command | What it does |
|---|---|
| `/test` | Smart test with options and recommendations |
| `/test-quick` | Fast check during development |
| `/test-deep` | Full review before a big launch |
| `/report` | Open your visual HTML report |
| `/resume` | Pick up where you left off |
| `/status` | See progress at any point |
| `/addaccount` | Save login details for testing |

## Requirements

- **Google Chrome browser** for visual testing
- **Claude Code** installed and working
- **A Claude Pro or Max subscription** for the AI behind everything
- **Node.js version 18 or higher** for Chrome MCP server
- **CodeRabbit CLI** optional but recommended for the best results in deep test mode

## Installation

### One command install (coming soon)

```
/plugin install @Kidkujoe/visual-test-pro
```

### Manual install

1. Download or clone this repository:
   ```
   git clone https://github.com/Kidkujoe/Visual-Test-Pro.git
   ```
2. Open your terminal
3. Go to the folder:
   ```
   cd Visual-Test-Pro
   ```
4. Run the installer:
   ```
   sh install.sh
   ```
5. Follow the instructions on screen

## Quick start

1. Open your project in your editor
2. Open the terminal and run:
   ```
   claude --chrome
   ```
3. Start your app in another tab:
   ```
   npm run dev
   ```
4. Type: `/test`
5. Claude scans your project and gives you options — just follow along

## How it handles logins

When Claude finds a page that needs you to be logged in, it works through a checklist:

First it checks if you have already saved a test account for this project using `/addaccount`. If you have, it uses those details to log in.

If there is no saved account, Claude tries to find one automatically. It looks for seed scripts or test user setups in your project. If that does not work, it tries to create an account through your signup page.

If your app uses magic links instead of passwords, Claude looks for a local email catcher like Mailhog or Mailpit running on your machine. It can grab the magic link from there and use it to log in. It also checks if your project has a bypass variable in the environment that lets it skip the email step during development.

If nothing works, Claude stops and asks you what to do. It never guesses or forces its way past a login. You can provide credentials, grant access another way, or tell it to skip that area and move on.

## How fixes work

Every issue Claude finds is given one of four levels:

- **Critical** means there is a security risk or something that could lose data. Claude explains the problem in plain English and asks your permission before touching anything.
- **High** means a real bug or significant problem users will notice. Claude recommends a fix and asks before making changes.
- **Medium** and **Low** issues are listed in the report for you to decide on later. Claude does not fix these automatically.

Before making any change, Claude tells you exactly what will be different after the fix. If a fix could affect how something looks or works elsewhere in your app, it warns you with a side effect notice. After applying a fix, Claude goes back to the browser to confirm it actually worked. If it did not, it tells you and moves on.

## Token usage guide

**Quick test** — Low usage. Good for daily development checks. Uses roughly 40% of a session window.

**Standard test** — Medium usage. Good for end of sprint or feature review. Uses roughly 65% of a session window.

**Deep test** — High usage. Best before a launch or major release. Uses up to 90% of a session window. Best run at the end of the day.

**Tip for Max users:** You have a 1 million token context window. You can run deep tests comfortably. Save them for before launches rather than daily use.

## What the HTML report looks like

The report is a single HTML file you can open in any browser. It includes:

- **A plain English summary** anyone on your team can read, even non-developers
- **What was fixed** and why it mattered, written simply
- **Areas tested** including restricted pages, with badges showing how access was gained
- **Screenshots** of your app at desktop, tablet, and mobile sizes
- **Things still needing attention** sorted by importance with clear next steps
- **A health scorecard** with visual bars for security, code quality, accessibility, and more
- **Recommended next steps** as a numbered list of simple actions you can follow

## Troubleshooting

### Chrome not connecting

1. Make sure Chrome is open before starting Claude
2. Run `claude --chrome` to connect
3. If it still does not work, close Chrome completely and reopen it
4. Try running `/test` again

### CodeRabbit not found

Install it with:
```
curl -fsSL https://cli.coderabbit.ai/install.sh | sh
```
Then restart your terminal and try again. CodeRabbit is optional — everything else works without it.

### Test account cannot log in

1. Check if the password or credentials have changed
2. Run `/addaccount` to update the saved details
3. If using magic links, make sure your email catcher is running

### Magic link not arriving

Claude will check for Mailhog, Mailpit, and other local email catchers. If none are found, it checks for a bypass variable. If nothing works, Claude asks you to either paste the link manually or set up a local email catcher.

### Session running out of tokens

Claude warns you when tokens are getting low and offers three options:
1. Continue and finish what is left
2. Skip to report generation
3. Save progress and resume later with `/resume`

### Fix did not work

If a fix does not solve the problem, Claude notes it in the report and moves on. You can see exactly what was tried and what still needs attention in the final report.

## Contributing

We welcome improvements. See [CONTRIBUTING.md](CONTRIBUTING.md) for how to help.

## License

MIT — free to use and modify. See [LICENSE](LICENSE) for details.
