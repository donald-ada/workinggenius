---
name: genius
description: The map of the Working Genius workflow — where each piece of work stands, what to run next, and where genius gaps are hiding.
disable-model-invocation: true
argument-hint: "optional: a work slug, or a new idea to start tracking"
allowed-tools: Bash(python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py *)
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

State lives in `.genius/<slug>/<slug>.md` — the bounded snapshot a cold session reads whole — with its history in `<slug>.log.md` and what binds the unbuilt slices in `CONTRACT.md`, beside it (the `genius-file` skill owns the discipline). Each stage ends when its one threshold is honestly true; each is a command the user types, and one they don't type simply doesn't run — its absent section is the record. Four layers run underneath: the `domain-glossary` skill keeps the shared language in `CONTEXT.md`, the `decision-record` skill keeps the index of settled decisions in `.genius/DECIDED.md`, the `blindspot` skill hunts the unknowns the stages can't reach, and the `errata` skill corrects what any of them got wrong.

## What to do when invoked

The counts first, taken as this command was invoked. On Claude Code the block below is replaced by the instrument's output before you read it; where a policy notice shows instead (shell injection disabled), run it before saying a number, because a number said without one is a guess:

```!
python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py status
```

Those are the counts; what this command adds is the reading — which stage, what is unfinished, what went stale — never the arithmetic.

**No argument** → status, from the in-flight work files only: each one's stage, what's unfinished, which stages never ran, and the exact next command; flag work untouched for weeks as stale and offer to resume or abandon. For calibration read `.genius/HISTORY.md`, one line per finished work, instead of opening every done snapshot: a genius repeatedly weakest there is calibration, so say so when routing new work. And light up the backlog: `.genius/BACKLOG.md`'s lines are work the flow already discovered and nobody started — show them every time, because an idea the user must remember to ask about is one the flow already lost once. Say how many have grown past a seed's character bound (counted above) and name `/triage` as what puts the questions to these lines; whether a work already answered a seed is a ruling, not a count, so it is not done here. Nothing in flight, no history, no backlog? Show the flow and how to start.

**An idea** → start it: create the work file (`genius-file` skill) and open the Wonder interview. An idea that arrives as a tracker issue is read first, and the work file records which issue it answers; one taken from `.genius/BACKLOG.md` removes its line. Dropping a stage is the user's call, made by not typing it — never a package you propose. And stages trade; depth doesn't: a stage worth running is worth running at full depth, because a skimmed stage pays the ceremony and buys nothing. Reaching the next command is not progress — meeting this one's threshold is.

**A work slug** → deep status on that one: where it stands, anything smelly, the next command.

## When work feels wrong

The skipped or rushed genius is the usual cause — match the symptom: built the wrong thing → Wonder; the design fights the codebase → Invention or Discernment; the same decision keeps getting re-litigated → kill-reasons never recorded; sessions stall with nobody sure what's next → slices not grabbable; huge untested diff → Enablement; "done" three times → Tenacity; session after session builds on something the repo stopped doing → the binding docs drifted, `/reconcile`; the backlog has grown past reading and the same idea appears twice → `/triage`. Repair the most upstream gap first — downstream inherits its fix. Not everything starts at Wonder: an agreed design starts at `/galvanize` (earlier sections backfilled, marked so); an imported plan gets `/discern`'s attack before it gets slices; a bug gets the `diagnose` skill's loop. And not everything ends at slices: small work built directly after Wonder is built by `/enable <slug>` with no Slices section — the same loop, aimed at the Problem's success criteria — and still closes at `/tenacity`.
