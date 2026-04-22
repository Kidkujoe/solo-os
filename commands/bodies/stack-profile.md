---
name: stack-profile
description: Builds your permanent developer profile. Infers from existing project contexts and asks targeted questions about experience, comfort levels and goals. Saves globally to DEVELOPER_PROFILE.md.
allowed-tools: Bash
---
NOTE: This command uses a GLOBAL file outside project context:
PROFILE_FILE="$HOME/.claude/context/DEVELOPER_PROFILE.md"

PHASE 1 - CHECK IF EXISTS:
If PROFILE_FILE has Status: CONFIRMED display:
  DEVELOPER PROFILE ALREADY EXISTS
  Last updated: [date]  Products: [count]  Technologies: [count]
  Run /stack-update to change. Type "show" to view, "rebuild" to restart.

Otherwise proceed.

PHASE 2 - INFER FROM PROJECTS:
Read all ~/.claude/context/projects/*/atlas/PRODUCT.md,
STRATEGY.md, HEALTH.md, DECISIONS.md, REVIEWS.md.

Extract: product names, tech stacks from code, deployment platforms,
key libraries, decisions revealing preferences, recurring pain patterns
from reviews.

Display WHAT I FOUND IN YOUR PROJECTS panel with detected products,
technologies seen across projects, recurring pain signals.

PHASE 3 - EIGHT QUESTIONS (one at a time, wait for each):

Q1 EXPERIENCE + STYLE: 1 self-taught / 2 few years / 3 several years /
   4 senior, combined with A solo / B with contractors / C small team.
   Type like "3A" or "2B".

Q2 SHIPPED PRODUCTS: For each detected product ask honestly what worked
   well in the tech stack and what caused pain. Be specific.

Q3 WHAT YOU KNOW WELL: Which detected technologies do you feel genuinely
   confident with ("could debug production at 2am")? Anything NOT in the
   detected list that you know well?

Q4 WANT TO LEARN: Want to learn something in next project? Or stay in
   familiar territory to move fast?

Q5 HARD CONSTRAINTS: Anything never to recommend against? (Must stay in
   TypeScript, specific deployment, budget limits, specific ecosystems.)
   Type "none" if none.

Q6 PREFERENCES: Pick letters: A convention over config / B full control /
   C minimal dependencies / D batteries included / E proven over cutting
   edge / F active community / G best documentation / H fastest to prototype.

Q7 TIME + SCALE: 1 full time / 2 part time / 3 evenings and A small /
   B medium / C large / D unknown scale. Type like "2D".

Q8 GOAL PRIORITY ORDER: Rank A ship fast / B build it right / C learn /
   D keep costs low / E build to sell / F long term maintainability /
   G impress investors.

PHASE 4 - BUILD AND CONFIRM:
Compile DEVELOPER_PROFILE.md from inferred data + answers.

Display complete profile with sections: Who you are, What you know well,
What caused pain, Preferences, Constraints, Goals, Tech Radar (Adopt /
Trial / Assess / Hold / Never Again), How this shapes recommendations.

Include specific examples of how the profile will change recommendations
(e.g. "Because you know Next.js well with no incidents across 3 projects,
I will always recommend it over alternatives unless there's specific reason not to").

Ask yes / edit. Save with Status: CONFIRMED.

PHASE 5 - OBSIDIAN SYNC (if vault exists):
Write profile summary to ~/Documents/SecondBrain/Developer/Profile.md.
Write Tech Radar to ~/Documents/SecondBrain/Developer/TechRadar.md
with sections Adopt / Trial / Assess / Hold / Never Again.
Create ~/Documents/SecondBrain/Developer/TechDecisions/ and
~/Documents/SecondBrain/Developer/LessonsLearned/ folders.
