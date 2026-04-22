---
name: copyai-research
description: Research-only version of Copy Intelligence. Gathers competitor intelligence, customer language and pain points from public platforms and produces a copy strategy with evidence. Does not rewrite any copy.
allowed-tools: Bash
---
Run Phases 1 through 5 of the Copy Intelligence skill only.

Read $PRODUCT_MD silently if it exists
Read $VOICE_MD if it exists

Phase 1: Build and confirm Product Intelligence Brief
Phase 2: Identify competitors via web search, confirm with user
Phase 3: Competitive intelligence — read positioning, mine weaknesses
  from Reddit, G2, Capterra, Product Hunt, Trustpilot, Twitter/X,
  YouTube comments, Hacker News, Indie Hackers. Identify migration triggers.
Phase 4: Voice of customer research — source real customer language
  about the problem from Reddit, Quora, Twitter/X, YouTube comments.
Phase 5: Synthesise into Copy Intelligence Report with confirmed strategy.

Stop after displaying the confirmed copy strategy.
Do not rewrite any copy.

Save findings to $ATLAS/COPYAI.md

Display:
  Research complete. Your copy strategy
  is saved in COPYAI.md.

  To get full rewrites based on this
  strategy run: /copyai

  To share the strategy report run:
  /report then open copy-report.html
