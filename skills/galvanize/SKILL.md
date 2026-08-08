---
name: galvanize
description: Turn the chosen design into mobilized work — a brief, vertical slices with acceptance criteria, and agreed test seams. Use when a tracked piece of work is at its galvanizing stage.
---

# Galvanizing

The genius of rallying work into motion. Its failure mode is the vague plan: a decision everyone agrees with and nobody can start.

The concept: **convert the decision into slices a fresh session can pick up cold.** A short behavioral brief, test seams agreed with the user as contracts, and vertical slices — each cutting through every layer the change touches, each demoable on its own, each with acceptance criteria a stranger could verify. A value the plan leaves "sensible" is a decision deferred to a session that can't ask — write the number. Pressure-test the cut with the user before finalizing; approval of a breakdown nobody pushed on is approval of nothing.

Record `base:` (the commit Tenacity will diff from) and commit the plan. Where the repo tracks work in issues (`Issue tracking:` pinned, or the user asks), publish the approved breakdown before any building starts, in a shape a tracker can filter and follow: **one parent issue for the work** (title = the work's title; body = the brief, the work file path, and a task list of the slice issues — the tracker's progress view), then **one issue per slice** linked under it (sub-issues where the tooling allows; the parent's task list alone where it doesn't). Parent and slices all wear **one shared `working-genius` label**, created if the repo lacks it — the one-click filter for everything the flow published; per-work grouping is the parent's job, so no per-work labels pile up. Write the numbers back: `— issue: #N` on each slice line, `**Parent issue:** #N` in the Galvanizing section. The work file stays the source of truth; issues mirror it.

Then `/enable` — one fresh context per slice. Done when a fresh session could grab any slice with only the work file — proven by reading each slice cold: every value a number, every criterion checkable by a stranger. A slice that still raises a question only you can answer isn't done being planned.
