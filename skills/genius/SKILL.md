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

**No argument** → report status. Scan every non-done work file — frontmatter, the `**Gate — <Stage>**` checklists, skip markers, and the current stage's section body; don't load whole files just for status. Done files get one summary line. For each in-flight item show: slug, current stage, unchecked gate items, recorded skips, and the exact next command — and if the stage sits **ahead of** an earlier gate that's neither checked nor skipped, the next command is repairing that gate, not the stage command. Flag anything untouched for roughly two weeks or more as stale and offer to resume or abandon it. If nothing is in flight, show the flow table and how to start.

**An idea or request** → start work. First, size it honestly and say which path you'd take:

- **Express** — single obvious approach, one seam, fits one session, no new concept. Wonder in one paragraph, Invention/Discernment skipped with reason, straight to `/galvanize`. (`/genius express <idea>` forces this path.)
- **Full flow** — everything else. Run the `genius-file` skill to create the work file, then hand to `/wonder`.

For the full flow, also ask how much rope you have — `mode: guided` (checkpoints as written), `delegated` (run on your recommendations, one stop at the Galvanizing breakdown), or `auto` (no stops; the user explicitly asked for hands-off). Modes live in the work file; the `genius-file` skill owns their semantics.

**A work slug** → deep status on that one: read its file, summarize where it stands, flag anything smelly (see below), and name the next command.

## Diagnosing genius gaps

When work feels wrong, the skipped or rushed genius is the usual cause. Read the work file and match the symptom:

- "We built it and the user doesn't want it" → Wonder was skipped or soft (was the problem statement really confirmed?)
- "The design fights the codebase everywhere" → Invention never explored options that follow the grain, or Discernment never attacked the winner
- "We keep re-litigating the same decision" → Discernment's kill-reasons weren't recorded
- "Sessions keep stalling, nobody knows what's next" → Galvanizing's slices aren't independently grabbable
- "Huge diff, no tests, works on my machine" → Enablement drifted from the seams
- "It was 'done' three times" → Tenacity's gate was claimed without fresh evidence

Three rules of the diagnosis:

- **Compound causes are normal.** Name every gap the file shows, then recommend repairing the **most upstream** one first — downstream stages inherit its fix. Never prescribe re-running the whole flow.
- **The loudest smell is an unrecorded bypass** — a stage that ran while an earlier gate sits unchecked with no skip line. Recorded skips are honest suspects; unrecorded bypasses are usually the culprit. (And repeated false "done" is the three-failed-fixes rule wearing different clothes: stop re-fixing, question the setup.)
- **Evidence isn't only in the file.** When a claim begs verification ("exported fine on my machine"), look at the repo: does the code exist, does anything test it?

## Entering mid-flow

Not everything starts at Wonder:

- **A design already agreed in conversation** → start at `/galvanize`; backfill Wonder and Discernment sections from the conversation, marked as backfilled.
- **A bug with an obvious fix** → express path (see the `genius-file` skill).
- **A bug that resists diagnosis** → that's Wonder for bugs: question the symptom until you have a tight reproduction — no fix before a root cause. After three failed fixes, stop fixing and question the architecture; the fourth attempt is where thrashing starts.
- **Someone else's plan handed to you** → `/discern` it first; imported plans deserve an attack before they deserve slices. Record the plan as an imported option (Invention skipped, reason recorded). The attack will surface questions the plan never answered — those are Wonder's questions: settle them with a targeted mini-interview (or `assumed:` lines), write them into a Wonder section marked backfilled, and check its gate before slicing. Imported plans import unexamined problems.
