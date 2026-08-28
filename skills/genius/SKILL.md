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

State lives in `.genius/<slug>/<slug>.md` — the bounded snapshot a cold session reads whole — with its history appended to `<slug>.log.md` and what binds the unbuilt slices in `CONTRACT.md`, both beside it in that same folder (the `genius-file` skill owns the discipline). Each stage ends when its one threshold is honestly true; each is a command the user types, and one they don't type simply doesn't run — its absent section is the record. Four layers run underneath: the `domain-glossary` skill keeps the project's shared language in `CONTEXT.md`, the `decision-record` skill keeps the index of its settled decisions in `.genius/DECIDED.md`, the `blindspot` skill hunts the unknowns the stages can't reach, and the `errata` skill corrects what any of them got wrong — rewriting what binds, appending to what records.

## What to do when invoked

**No argument** → status, from the in-flight work files only: each one's stage, what's unfinished, which stages never ran, and the exact next command; flag work untouched for weeks as stale and offer to resume or abandon. For calibration, read `.genius/HISTORY.md` instead of opening every done snapshot to find its post-mortem — one line per finished work, appended by `/tenacity` at close-out: a genius repeatedly weakest there is calibration, not coincidence, so say so when routing new work and let that stage get deliberate weight. And light up the backlog: `.genius/BACKLOG.md`'s lines are work the flow already discovered and nobody started — show them every time, because an idea the user must remember to ask about is an idea the flow already lost once. Nothing in flight, no history, no backlog? Show the flow and how to start.

**An idea** → start it: create the work file (`genius-file` skill) and open the Wonder interview. An idea that arrives as a tracker issue is read first, and the work file records which issue it answers; one taken from `.genius/BACKLOG.md` removes its line, the new work file its home now. Dropping a stage is the user's call, made by not typing it — never a package you propose. And stages trade; depth doesn't: a stage worth running is worth running at full depth, because a skimmed stage pays the ceremony and buys nothing. Reaching the next command is not progress — meeting this one's threshold is.

**A work slug** → deep status on that one: where it stands, anything smelly, the next command.

## When work feels wrong

The skipped or rushed genius is the usual cause — match the symptom: built the wrong thing → Wonder; the design fights the codebase → Invention or Discernment; the same decision keeps getting re-litigated → kill-reasons never recorded; sessions stall with nobody sure what's next → slices not grabbable; huge untested diff → Enablement; "done" three times → Tenacity; session after session builds on something the repo stopped doing → the binding docs drifted, `/reconcile`. Repair the most upstream gap first — downstream inherits its fix. And not everything starts at Wonder: an agreed design starts at `/galvanize` (earlier sections backfilled, marked so); an imported plan gets `/discern`'s attack before it gets slices; a bug gets the `diagnose` skill's loop — a red-capable reproduction before any hypothesis, and after three failed fixes stop fixing and question the setup. And not everything ends at slices, either: small work built directly after Wonder, ceremony skipped by choice, still closes at `/tenacity` — no slice list required, just something to verify fresh and call done honestly.
