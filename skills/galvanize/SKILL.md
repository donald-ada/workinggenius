---
name: galvanize
description: Turn the chosen design into mobilized work — a brief, vertical slices with acceptance criteria, and agreed test seams. Use when a tracked piece of work is at its galvanizing stage.
---

# Galvanizing

The genius of rallying work into motion. Its failure mode is the vague plan: a decision everyone agrees with and nobody can start. Galvanizing converts the decision into slices a fresh session can pick up cold.

Run the `genius-file` skill: read the work file. Discernment's gate must be checked (or skipped, recorded) before this stage begins.

## Process

### 1. Write the brief

Condense Wonder's problem and Discernment's chosen approach into 2–5 sentences in the work file. Behavioral, not procedural: describe what the system will do, name interfaces and contracts — never file paths or line numbers, which go stale before the first slice starts. Use the vocabulary of `CONTEXT.md` (if it exists) throughout the brief and the slice titles.

### 2. Agree the test seams

Name the public interfaces the tests will target — existing seams preferred, the fewest and highest seams possible. Confirm them with the user: seams agreed here are where Enablement writes tests, no renegotiation mid-build.

### 3. Slice vertically

Break the work into **tracer-bullet slices**. Each slice:

- cuts through **all** layers end-to-end (schema, logic, API, UI — whatever the change touches), never one layer of everything
- is **demoable on its own** — a person could see it work
- is **independently grabbable** — a fresh session with only the work file can build it
- lists **acceptance criteria** that are each independently verifiable ("running X shows Y", not "works correctly")
- names its blockers (`blocked by: 2`) or `blocked by: none`

Any prefactoring ("make the change easy, then make the easy change") is its own first slice.

### 4. Quiz the user on the breakdown

Show the numbered slices with blockers and acceptance criteria. Ask: granularity right? dependencies right? merge or split anything? Iterate until approved.

### 5. Set up the sessions

Write the approved slices into the work file, and record the starting point in its frontmatter: `base: <current commit sha>` — Tenacity reviews the whole work's diff against this. Then advise the user on context hygiene:

- **Multi-slice work**: run each slice in a **fresh session** — open it, say `/enable <work-slug>, slice N`, and the work file carries everything needed. Fresh context per slice keeps every session sharp. Slices with no blocker between them can even run in parallel sessions (separate worktrees).
- **Single-slice work**: continue right here with `/enable`.

## Gate — Galvanizing

- [ ] Brief written — behavioral, no paths
- [ ] Test seams agreed with the user
- [ ] Every slice is a vertical cut, demoable on its own
- [ ] Every slice has independently verifiable acceptance criteria
- [ ] User approved the breakdown

Set `stage: enablement` and tell the user: next is `/enable` (per slice, fresh session for each).
