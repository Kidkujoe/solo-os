---
name: stack-update
description: Update your developer profile after finishing a project, having a new experience, learning something new or changing goals or constraints.
allowed-tools: Bash
---
Read ~/.claude/context/DEVELOPER_PROFILE.md.

$ARGUMENTS describes what to update. If empty show current profile and
ask what to change.

UPDATE TYPES:

FINISHED A PROJECT:
Add to shipped products section. Add honest assessment of what worked
and what caused pain. Update technology comfort ratings based on
experience. Update Tech Radar accordingly.

HAD AN INCIDENT:
Record incident against relevant technology. This affects future
recommendations for that technology. Consider moving to Hold or
Never Again tier.

LEARNED SOMETHING NEW:
Update comfort level for technology. Move up Tech Radar if appropriate
(Assess → Trial → Adopt).

CHANGED GOALS:
Update goal priority order. Update constraints if any changed. Note
what changed and why.

TRYING SOMETHING NEW:
Move technology into Trial tier. Record what project you're trying
it on and what you want to learn.

After any update:
- Display what changed and how it will affect future recommendations
- Update Obsidian Developer/ folder files if vault exists
- Update LessonsLearned/ if incident was recorded
- Update TechRadar.md if tier changed
