---
name: deps
description: Proactive dependency health audit. Outdated packages, abandoned packages, breaking changes in major upgrades, security vulnerabilities, safe vs risky upgrade classification.
allowed-tools: Bash
---
PHASE 1 - DETECT PACKAGE MANAGER:
- package.json + package-lock.json -> npm
- package.json + yarn.lock -> yarn
- package.json + pnpm-lock.yaml -> pnpm
- requirements.txt or pyproject.toml -> pip
- Gemfile -> bundler
- go.mod -> go modules
- Cargo.toml -> cargo

If multiple found: audit each.

PHASE 2 - OUTDATED PACKAGES:
For npm/yarn/pnpm: `npm outdated --json`. Parse each outdated package.
For pip: `pip list --outdated --format=json`.

Classify each:
- PATCH (1.2.3 -> 1.2.4): very low risk, bug fix only
- MINOR (1.2.3 -> 1.4.0): usually safe, new features, backward compatible
- MAJOR (1.2.3 -> 2.0.0): breaking changes likely, review required

For each MAJOR update, search for breaking change notes in the package's
changelog. Summarise what breaks.

PHASE 3 - ABANDONED PACKAGES:
For each dependency check npm registry or equivalent:
- Last publish date
- Weekly download count
- GitHub repo status

Flag ABANDONED: not updated in 2+ years AND fewer than 1000 weekly downloads.
Flag AT RISK: not updated in 1+ year OR downloads declining significantly.

PHASE 4 - SECURITY CHECK:
`npm audit --json` across all dependencies. Parse all severities
(critical, high, moderate, low).

PHASE 5 - DISPLAY AND RECOMMEND:

  DEPENDENCY HEALTH REPORT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total dependencies: [count]
  Up to date: [count]
  Outdated: [count]

  SAFE TO UPGRADE NOW ([count]):
  [package] [current] -> [latest] (patch)
  Command: npm update [package]

  REVIEW BEFORE UPGRADING ([count]):
  [package] [current] -> [latest] (minor)
  No breaking changes found.
  Command: npm install [package]@[latest]

  BREAKING CHANGES - PLAN CAREFULLY ([count]):
  [package] [current] -> [latest] (major)
  Breaking: [summary]
  Guide: [link to migration guide]

  ABANDONED PACKAGES ([count]):
  [package] - last updated [date]
  Alternatives: [suggestions from search]

  SECURITY VULNERABILITIES ([count]):
  Critical: [count]  High: [count]

  Run /deps fix to apply safe updates.
  Run /deps upgrade [package] for guided major upgrade.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If $ARGUMENTS is "fix":
Apply all patch and safe minor updates.
Run build to verify nothing broke.
Run test suite. Show results.

If $ARGUMENTS is "upgrade [package]":
Show breaking change summary.
Offer to create a backup branch first.
Run the upgrade. Build. Test. Show results.
If anything breaks offer to rollback.
