---
name: env-diff
description: Compares environment variables across local and production environments. Flags missing variables, dev-only flags in production, required variables not defined anywhere. Never exposes values - names only.
allowed-tools: Bash
---
CRITICAL RULE: Display variable NAMES only. Never display, log or output
any variable VALUES. If a value is accidentally visible in output
immediately warn the user and redact.

PHASE 1 - READ ENV FILES:
Find all env files in project root:
.env, .env.local, .env.development, .env.production, .env.staging,
.env.example, .env.template.

Extract variable NAMES only from each. Never read or display values.

.env.example and .env.template define REQUIRED variables.

PHASE 2 - READ CODE REFERENCES:
Scan codebase for env var references:
- process.env.[NAME]        (JavaScript/TypeScript)
- os.environ[[NAME]]        (Python)
- ENV[[NAME]]               (Ruby)
- getenv([NAME])            (PHP/C)
- os.Getenv([NAME])         (Go)

Build complete list of every env var the code expects.

PHASE 3 - DETECT PRODUCTION ENV:
If deployment platform is configured try to fetch production vars
(names only, never values):
- Vercel: `vercel env ls`
- Netlify: `netlify env:list --plain`
- Fly.io: `flyctl secrets list`
- Others: note that production env cannot be read automatically; ask
  user to paste list of production variable names.

PHASE 4 - COMPARISON AND DISPLAY:

  ENVIRONMENT VARIABLE AUDIT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Variables in code: [count]
  Defined locally: [count]
  Defined in production: [count or UNKNOWN]

  MISSING IN PRODUCTION ([count]):
  [VAR_NAME] - required by [file]
  This will cause [feature] to fail in production.

  MISSING LOCALLY ([count]):
  [VAR_NAME] - defined in production
  May cause issues in development.

  IN CODE BUT NOT DEFINED ANYWHERE ([count]):
  [VAR_NAME] - referenced in [file]
  Neither local nor production has this.
  Will cause runtime error.

  DEV-ONLY VARIABLES IN PRODUCTION ([count]):
  [VAR_NAME] - name suggests dev usage
  Patterns flagged: DEBUG_, DEV_, LOCAL_, TEST_
  Verify these should be in production.

  ALL PRESENT AND CORRECT: [count] variables.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For each missing-in-production variable also show:
- Which code file(s) reference it
- What feature will break without it

Never show values. Only names.
