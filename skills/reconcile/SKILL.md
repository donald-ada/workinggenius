---
name: reconcile
description: Check the project's binding documents against the repo they describe — settled decisions, glossary terms, pinned commands, in-flight plan contracts, the links between file and record — and route every drift to its correction.
disable-model-invocation: true
argument-hint: "optional: a work slug, or one doc to check"
allowed-tools: Bash(python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py *)
---

# Reconcile

The `errata` skill catches what a session trips over. Nobody trips over the rest: `.genius/DECIDED.md`, `CONTEXT.md`, `DESIGN.md`, `ARCHITECTURE.md`, the pinned verify commands, the contracts of work still in flight. Those are read as authoritative by every fresh session precisely because nothing in the flow reads them adversarially, and each keeps being obeyed until something expensive happens.

The concept: **the binding documents are claims about a repo that has moved. Go check them against it.**

## When to run it

The user types it, at the moments the answer changes something: before designing against settled ground, after a refactor or dependency change large enough to have moved the ground, when a session has just cited a doc that turned out wrong, or when work resumes after weeks away. Not on a schedule: **a scan with nothing to find will find something**, and a manufactured drift is worse than the drift it invented.

## What gets checked

Every line, against the repo — never against what you remember of it. With an argument, only that slug or that doc. Two of the checks are the instrument's, read as this command was invoked — every snapshot against its ceiling, and both directions of the links; where a policy notice shows instead, run it before reporting:

```!
python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py snapshots
python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py links
```

- **`.genius/DECIDED.md`** — does each decision's constraint still exist in the code, and does its link still reach the fight that settled it?
- **`CONTEXT.md`** — does the code still call each term what the glossary says? A rename that never reached the glossary is the collision that skill exists to prevent, arriving late.
- **`ARCHITECTURE.md` and `DESIGN.md`** — does the code still respect each boundary and contract, do the fitness functions still exist and run, do the shipped screens still use the token roles, and do the recorded contrast ratios still hold for the values now in the code?
- **`.genius/BACKLOG.md`** — has the repo since satisfied a line, and do its anchors still resolve: the `From` one into a work's log, the `[detail]` one into `BACKLOG.log.md`, the `[retired]` links at the foot? Both can be shown. **Whether a line is still worth doing cannot**, so it belongs to `/triage`. A line the user retires leaves by the format's route for seeds, not by deletion.
- **In-flight work** — the contract at its current version: seams, pinned numbers, conventions; and the snapshot's Open section, holding `assumed:` lines nobody came back to. A snapshot over its ceiling or carrying history is drift too, and so is a work file writing paths from the repo root instead of its own folder. ⚠ The compaction one is handed to `/compact`, not `errata`: nothing in it is wrong, only misfiled. The two link directions go there too — a link into a log whose anchor no longer exists, and a log entry no section links any more. ⚠ **They do not come back the same way**: an entry nothing links is repaired there, in the snapshot section it backs; a link whose target is genuinely not in the log **comes back reported, not fixed**, because the repair would mean writing the log, which nothing in this flow does — whether the entry went missing or the link was always wrong is the user's call.
- **The `## Working Genius` section** — run the verify commands. A typecheck command that no longer exists is discovered here or at the worst moment of a close-out.
- **The links** — every log entry linked from the snapshot section it backs, every done slice pointing at an anchor that exists. The block above is this check, taken mechanically; what remains is routing each line it lists — a missing anchor reported, an unlinked entry to `/compact`, a key with prose after it to the format's repair.

## How it runs

Read-only until the user has seen the findings. **Each finding carries what produced it** — the command and its output, the file and its place. A drift you can't show is not reported; a document that looks stale and reads fine is left alone. Say plainly what you could not check and why, because an unchecked line counted as verified is exactly the failure this skill exists to catch.

Then the user calls each one, and the calls apply through the `errata` skill's three moves — corrected, superseded, or retired, each landing in the binding copy and in the record behind it. Two things never get settled here: **a decision that now looks wrong goes back to `/discern`** with the drift as ammunition, and **a term with two live meanings goes to the `domain-glossary` skill's collision**. Both are fights, and a scan does not get to win a fight it started.

Done when every binding line has been checked against the repo or reported as uncheckable, and every accepted finding is written through `errata` — nothing rewritten on a hunch, nothing quietly tidied on the way past.
