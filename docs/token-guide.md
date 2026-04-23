# Token Usage Guide

A plain English guide to understanding and managing how many tokens solo-os uses.

## What are tokens

Think of tokens as working memory for Claude. Every message you send, every file Claude reads, every screenshot it takes, and every response it writes uses some of this memory. You have a fixed amount per session — like a budget. When it runs out, the session ends and you start a new one.

## Why testing uses more than a normal conversation

A normal Claude conversation is mostly text back and forth. Testing is different. Claude is reading your code files, taking screenshots of your app (which use a lot of memory), analysing what it sees, writing findings to files, and generating a detailed report. Each screenshot alone can use as much memory as hundreds of lines of text.

## The three modes and their real cost

### Quick Check — Low usage
- Looks at public pages only
- Takes a few screenshots
- Checks the console for errors
- No code review
- No HTML report — just a terminal summary
- **Uses roughly 40% of your session window**
- Best for: daily development checks, quick sanity tests

### Standard Test — Medium usage
- Tests all pages including restricted areas
- Takes screenshots at three breakpoints
- Does a focused code review
- Generates a full HTML report
- **Uses roughly 65% of your session window**
- Best for: end of sprint reviews, feature completion checks

### Deep Test — High usage
- Tests everything comprehensively
- Full code review of all key files
- CodeRabbit sweep if installed
- Full accessibility audit
- Screenshots at five breakpoints
- Comprehensive HTML report
- **Uses up to 90% of your session window**
- Best for: pre-launch reviews, major releases

## What uses the most tokens

### Screenshots
Screenshots are the biggest token cost. Each one is like loading a large image into memory. We minimised this by:
- Only taking screenshots that add value
- Not screenshotting the same page twice unless something changed
- Grouping responsive screenshots efficiently

### Code review
Reading and analysing code files uses moderate tokens. The more files reviewed, the more tokens used. Quick mode skips this entirely. Standard mode reviews changed files. Deep mode reviews everything.

### CodeRabbit sweep
If you have CodeRabbit installed and run a deep test, the sweep results are pulled in and analysed. This adds moderate token cost but catches things Claude might miss.

### HTML report generation
Building the report uses tokens because Claude has to compile all findings, write plain English summaries, and generate structured HTML. This is why we made `/report` a separate command — you can generate the report in a fresh session if needed, without re-running the tests.

## Smart tips for Max users

You have a 1 million token context window. This is a lot of room.

- You can comfortably run deep tests without worrying about running out
- You can test large apps with many pages in a single session
- Save deep tests for before launches rather than daily use — not because you will run out, but because it takes time
- Use quick checks during daily development
- If you want to test multiple apps, use separate sessions for each

## Smart tips for Pro users

Your context window is smaller, so token management matters more.

- Use quick checks as your daily default
- Save standard tests for when you have finished a feature or sprint
- Run deep tests sparingly — before major releases only
- If a session runs low on tokens, choose "skip to report" when prompted
- Use `/resume` to continue in a fresh session if needed
- Run `/report` in a separate session if you ran out during testing

## When to use which mode

| Situation | Recommended mode |
|---|---|
| Just pushed some code, want a quick look | Quick |
| Finished a feature, want to check it properly | Standard |
| About to show the app to someone | Standard |
| End of sprint review | Standard |
| About to launch or go live | Deep |
| Major release with many changes | Deep |
| Debugging a specific page | Quick (with that page as argument) |
| Daily development routine | Quick |

## What the token warning looks like

When tokens are getting low during a test, Claude will pause and show you something like:

```
Token usage is getting high.
What would you like to do?

1. Continue and finish (may run out)
2. Skip to report generation
3. Save progress and resume later
```

**Option 1** continues testing. If tokens run out before finishing, you lose the rest of that session but your progress is saved in test-session.md.

**Option 2** skips any remaining test sections and goes straight to generating the HTML report with whatever has been found so far. This is usually the best choice.

**Option 3** saves everything to test-session.md and stops. You can start a fresh session later and type `/resume` to pick up where you left off.

## How to split a large app into multiple sessions

If your app has many pages and you want thorough coverage without using all your tokens at once:

1. Run `/test` and choose Custom mode
2. Pick specific sections or pages to test
3. When done, your findings are saved
4. Start a new session
5. Run `/test` again with different sections
6. Each session adds to the same test-session.md file

## How the separate /report command saves tokens

The `/report` command generates (or regenerates) the HTML report from saved session data. This means:

- If a session runs out before generating the report, start a new session and type `/report`
- If you want to regenerate the report after fixing issues, just type `/report` — no need to retest
- The report command only reads data files and generates HTML — very low token cost
