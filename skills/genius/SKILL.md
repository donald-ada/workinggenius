---
name: genius
description: The map of the Working Genius workflow — where each piece of work stands, what to run next, and where genius gaps are hiding.
disable-model-invocation: true
argument-hint: "optional: a work slug, or a new idea to start tracking"
---

# The Genius Map

You don't remember every skill, so ask the map. This skill routes; it never builds.

## The flow

Every piece of work travels through six geniuses, in three pairs:

| Stage | Genius | Command | Skipping it looks like |
|---|---|---|---|
| **Ideation** | Wonder — question the work | `/wonder` | building exactly the wrong thing |
| | Invention — generate options | `/invent` | anchoring on the first idea |
| **Activation** | Discernment — judge and choose | `/discern` | plausible-but-wrong ships |
| | Galvanizing — mobilize into slices | `/galvanize` | a plan nobody can start |
| **Implementation** | Enablement — build with tight loops | `/enable` | flying blind until a big-bang reveal |
| | Tenacity — finish with evidence | `/tenacity` | "done" that isn't |

State lives in `.genius/<slug>.md` (the `genius-file` skill owns the format). Each stage ends in a gate; the next stage checks it. Skips are allowed but always recorded — that's how gaps stay visible.

Underneath the flow runs one vocabulary layer: the `domain-glossary` skill keeps `CONTEXT.md`, the project's shared language. `/wonder` and `/discern` drive it actively; every other stage just speaks it. Unlike work files, it's project-level — it compounds across all work.

## What to do when invoked

**No argument** → report status. Run the `genius-file` skill to read every non-done work file; for each, show: slug, current stage, unchecked gate items, recorded skips, and the exact next command. If nothing is in flight, show the flow table and how to start.

**An idea or request** → start work. Run the `genius-file` skill to create the work file, then hand to `/wonder`. If the work is genuinely small, offer the express path (Wonder in one paragraph, Invention/Discernment skipped with reason, straight to `/galvanize`).

**A work slug** → deep status on that one: read its file, summarize where it stands, flag anything smelly (see below), and name the next command.

## Diagnosing genius gaps

When work feels wrong, the skipped or rushed genius is the usual cause. Read the work file and match the symptom:

- "We built it and the user doesn't want it" → Wonder was skipped or soft (was the problem statement really confirmed?)
- "The design fights the codebase everywhere" → Invention never explored options that follow the grain, or Discernment never attacked the winner
- "We keep re-litigating the same decision" → Discernment's kill-reasons weren't recorded
- "Sessions keep stalling, nobody knows what's next" → Galvanizing's slices aren't independently grabbable
- "Huge diff, no tests, works on my machine" → Enablement drifted from the seams
- "It was 'done' three times" → Tenacity's gate was claimed without fresh evidence

Name the gap, then recommend re-running that one genius — not the whole flow.

## Entering mid-flow

Not everything starts at Wonder:

- **A design already agreed in conversation** → start at `/galvanize`; backfill Wonder and Discernment sections from the conversation, marked as backfilled.
- **A bug with an obvious fix** → express path (see the `genius-file` skill).
- **A bug that resists diagnosis** → that's Wonder for bugs: question the symptom until you have a tight reproduction, then flow on.
- **Someone else's plan handed to you** → `/discern` it first; imported plans deserve an attack before they deserve slices.
