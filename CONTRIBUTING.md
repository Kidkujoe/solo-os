# Contributing to solo-os

Thanks for wanting to help improve solo-os. Whether you are fixing a typo, reporting a bug, or adding a new feature, your contribution is welcome.

## How to suggest an improvement

1. Go to the [Issues page](https://github.com/Kidkujoe/solo-os/issues)
2. Click "New issue"
3. Give it a clear title like "Add support for Playwright" or "Improve mobile test coverage"
4. Describe what you would like to see and why it would help
5. If you have ideas on how to implement it, include those too

## How to report a bug

1. Go to the [Issues page](https://github.com/Kidkujoe/solo-os/issues)
2. Click "New issue"
3. Include:
   - What you were doing when the bug happened
   - What you expected to happen
   - What actually happened
   - Your operating system (Windows, Mac, Linux)
   - Your Claude Code version (`claude --version`)
   - Your Node.js version (`node -v`)
   - Any error messages you saw
4. If possible, include the relevant section from your test-session.md

## How to submit a change

1. Fork this repository on GitHub
2. Clone your fork to your machine:
   ```
   git clone https://github.com/your-username/solo-os.git
   ```
3. Create a new branch for your change:
   ```
   git checkout -b my-improvement
   ```
4. Make your changes
5. Test your changes (see below)
6. Commit with a clear message:
   ```
   git commit -m "Add support for custom port numbers"
   ```
7. Push to your fork:
   ```
   git push origin my-improvement
   ```
8. Go to the original repository and click "New pull request"
9. Select your branch and describe what you changed and why

## Code style

This project uses plain English in all command files and documentation. When writing or editing:

- Use simple words. If a simpler word works, use it.
- Avoid technical jargon unless absolutely necessary. If you must use a technical term, explain it.
- Write instructions as if explaining to a friend who builds apps but is not a developer.
- Keep sentences short and clear.
- Use "you" and "your" when talking to the user.
- Use "Claude" when referring to what the AI does.

For shell scripts:
- Use clear variable names
- Add comments for anything not immediately obvious
- Handle errors gracefully with helpful messages
- Test on both Mac and Linux if possible

## Testing a change before submitting

Before submitting a pull request:

1. Run the installer on a clean setup to make sure it works:
   ```
   sh install.sh
   ```
2. Test any commands you changed by running them in Claude Code
3. If you changed the report template, generate a test report and check it looks right
4. If you changed the install or uninstall script, test both
5. Make sure your changes work on at least one of: Mac, Linux, or Windows (Git Bash/WSL)

## How changes are reviewed

When you submit a pull request:

1. A maintainer will read through your changes
2. They may suggest improvements or ask questions
3. Once everything looks good, the change will be merged
4. Your contribution will be part of the next release

We try to review pull requests within a few days. If it has been more than a week, feel free to leave a comment asking for a review.

## Questions?

If you are unsure about anything, open an issue and ask. There are no silly questions.
