---
name: galvanize
description: Turn the chosen design into mobilized work — a brief, vertical slices with acceptance criteria, and agreed test seams. Use when a tracked piece of work is at its galvanizing stage.
---

# Galvanizing

The genius of rallying work into motion. Its failure mode is the vague plan: a decision everyone agrees with and nobody can start.

The concept: **convert the decision into slices a fresh session can pick up cold.** A short behavioral brief, test seams agreed with the user as contracts, and vertical slices — each cutting through every layer the change touches, each demoable on its own, each with acceptance criteria a stranger could verify. A value the plan leaves "sensible" is a decision deferred to a session that can't ask — write the number. Pressure-test the cut with the user before finalizing; approval of a breakdown nobody pushed on is approval of nothing.

Record `base:` (the commit Tenacity will diff from) and commit the plan. Where the repo tracks work in issues (`Issue tracking:` pinned, or the user asks), publish the approved slices — one issue per slice, numbers written back to the work file — before any building starts; the work file stays the source of truth, issues mirror it.

Then `/enable` — one fresh context per slice. Done when a fresh session could grab any slice with only the work file — proven by reading each slice cold: every value a number, every criterion checkable by a stranger. A slice that still raises a question only you can answer isn't done being planned.
