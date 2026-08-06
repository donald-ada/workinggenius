---
name: genius
description: The map of the Working Genius workflow — where each piece of work stands, what to run next, and where genius gaps are hiding.
disable-model-invocation: true
argument-hint: "optional: a work slug, or a new idea to start tracking"
---

# The Genius Map

The map answers three questions: where every piece of work stands, what runs next, and which genius went missing when something feels wrong. It routes; it never builds.

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

State lives in `.genius/<slug>.md` (the `genius-file` skill owns the discipline). Each stage ends when its one threshold is honestly true; skips are allowed and always recorded. Two layers run underneath: the `domain-glossary` skill keeps the project's shared language in `CONTEXT.md`, and the `blindspot` skill hunts the unknowns the stages can't reach.

## What to do when invoked

**No argument** → status, from the work files: each in-flight work's stage, what's unfinished, recorded skips, and the exact next command; flag work untouched for weeks as stale and offer to resume or abandon. Read done files' `**Post-mortem:**` lines as a set — a genius repeatedly weakest is calibration, not coincidence, and it should bend your sizing and mode recommendations. Nothing in flight? Show the flow and how to start.

**An idea** → size it and start, announcing the call with its reason (the user overrules with a sentence): **express** — single obvious approach, fits one session, no new concept: Wonder in a paragraph, straight to slices; **full flow** — anything else. Ceremony is priced (a measured full six-stage run cost 11× its no-plugin baseline, n=1 — `evals/RESULTS.md`), so say what the stages are buying or what makes them safe to skip, and record the call as the `**Sizing:**` line. Settle the mode (guided / delegated / auto — the `genius-file` skill owns the semantics; every mode keeps the Wonder interview live).

**A work slug** → deep status on that one: where it stands, anything smelly, the next command.

## When work feels wrong

The skipped or rushed genius is the usual cause — match the symptom: built the wrong thing → Wonder; the design fights the codebase → Invention or Discernment; the same decision keeps getting re-litigated → kill-reasons never recorded; sessions stall with nobody sure what's next → slices not grabbable; huge untested diff → Enablement; "done" three times → Tenacity. Repair the most upstream gap first — downstream inherits its fix. And not everything starts at Wonder: an agreed design starts at `/galvanize` (earlier sections backfilled, marked so); an imported plan gets `/discern`'s attack before it gets slices; a bug that resists diagnosis gets Wonder-for-bugs — a tight reproduction before any fix, and after three failed fixes stop fixing and question the setup.
