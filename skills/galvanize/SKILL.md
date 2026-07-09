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

Name the public interfaces the tests will target — existing seams preferred, the fewest and highest seams possible. A seam is a **contract, not a bare signature**: inputs, the encoding of every outcome, who owns side effects, and any ordering rule between this seam and its neighbors (which error wins? does a refused call still count?). A fresh session will inherit whatever the plan leaves open — decided by whoever can't ask you. Confirm the seams with the user: agreed here is where Enablement writes tests, no renegotiation mid-build.

### 3. Slice vertically

Break the work into **tracer-bullet slices**. Each slice:

- cuts through **all** layers end-to-end (schema, logic, API, UI — whatever the change touches), never one layer of everything
- keeps a behavior and its proof together: the slice that builds a behavior owns the tests that pin it. A criteria-only slice ("guarantees", "hardening") forces its builder to fake red with implementation mutations — if you find yourself writing one, its criteria belong to the slice that builds the behavior
- is **demoable on its own** — a person could see it work
- is **independently grabbable** — a fresh session with only the work file can build it
- lists **acceptance criteria** that are each independently verifiable ("running X shows Y", not "works correctly"). Mark criteria that only assert existing behavior still holds with `(verify)` — they can't honestly fail before the change, so Enablement checks them rather than red-greens them
- pins **every value it mentions**: a "sensible default", a limit, a timeout named anywhere in a slice is a decision — write the number, don't defer it to a session that can't ask
- names its blockers (`blocked by: 2`) or `blocked by: none`

Any prefactoring ("make the change easy, then make the easy change" — Kent Beck) is its own first slice.

Two licensed exceptions to the vertical rule: **non-code slices** (docs, changelog, release notes — mandatory deliverables in most real projects) are allowed as closing slices with their own checkable criteria, marked `(non-code)`. And **compat invariants** — "the old path is byte-identical", the central promise of any opt-in change — are `(verify)` criteria too, but list them first; they're the acceptance test of the design's core promise, not an afterthought.

### 4. Quiz the user on the breakdown

Show the numbered slices with blockers and acceptance criteria, then have the user pressure-test the cut itself: which slice would they demo first? does any slice hide two behaviors — or do two slices share one? is any blocker real, or just ordering out of habit? Reshape until they approve; approval of a breakdown they never pushed on is approval of nothing.

### 5. Set up the sessions

Record the sha of HEAD **as it stands now** in the frontmatter as `base:`, write the approved slices into the work file, and commit — one commit, no self-reference (the plan commit itself lands after `base:`, which is correct: the plan is part of the work Tenacity reviews). In delegated mode, commit the plan *before* stopping for review; if the review changes it, amend and recommit. Then advise the user on context hygiene:

- **Multi-slice work**: every slice should build in a **fresh context** — the work file carries everything needed. Default: stay right here and run `/enable <work-slug>` — it coordinates, dispatching one subagent per slice. Alternative (no subagents, or the user wants to drive each slice): a fresh session per slice, opened with `/enable <work-slug>, slice N`.
- **Single-slice work**: continue right here with `/enable`.

## Gate — Galvanizing

- [ ] Brief written — behavioral, no paths
- [ ] Test seams agreed with the user
- [ ] Every slice is a vertical cut, demoable on its own
- [ ] Every slice has independently verifiable acceptance criteria
- [ ] User approved the breakdown

Set `stage: enablement` and tell the user: next is `/enable` (per slice, fresh session for each).
