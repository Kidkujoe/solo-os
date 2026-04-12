# Changelog

## v1.3.0

- Added multi-agent fix system
- Specialist agents now work in parallel on Security, Logic, UI, Data and Performance fixes simultaneously
- Agents coordinate with each other before touching shared files
- Test Agent verifies every fix and sends failed fixes back for retry
- Live agent dashboard shows progress in real time
- Conflict detection when agents need the same file
- Plain English agent communication log in HTML report
- Escalation to user after three failed attempts per fix
- Time saved vs sequential fixing shown in summary
- Available in /test and /test-deep modes

## v1.2.0

- Added intelligent edge case discovery
- Claude now analyses the codebase and independently generates edge cases specific to each app
- Edge cases categorised by risk level: high, medium, interesting
- New /edgecases command for analysis without running a full test
- Edge cases saved to memory for future sessions
- HTML report now includes edge case findings in plain English
- Edge case discovery runs in /test and /test-deep before the options menu
- Users choose how to handle edge cases: test all, high risk only, skip, or save for later

## v1.1.0

- Added real time visible cursor during visual testing
- Purple cursor with click animations and plain English action labels
- Status bar overlay showing current test action in plain English
- Smooth natural mouse movement between elements
- Cursor cleans up before screenshots so reports stay clean
- Cursor re-injects automatically after every page navigation
- Hover state changes cursor colour and size
- Click animation shrinks dot and expands ring
- Applied to both /test and /test-quick commands

## v1.0.0

- Initial release
- 7 commands: /test, /test-quick, /test-deep, /report, /resume, /status, /addaccount
- Visual browser testing with Chrome MCP
- Code review with security and quality checks
- Authentication handling including magic links
- Smart fix decision flow with side effect warnings
- Token awareness with options and recommendations
- Plain English HTML reports
- Session memory and resume support
- Test account management
