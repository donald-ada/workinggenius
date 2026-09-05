---
name: reconcile
description: Check the project's binding documents against the repo they describe — settled decisions, glossary terms, pinned commands, in-flight plan contracts, the links between file and record — and route every drift to its correction.
disable-model-invocation: true
argument-hint: "optional: a work slug, or one doc to check"
allowed-tools: Bash(python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py *)
---

# Reconcile

The `errata` skill catches what a session trips over. Nobody trips over the rest: `.genius/DECIDED.md`, `CONTEXT.md`, `DESIGN.md`, `ARCHITECTURE.md`, the pinned verify commands, the contracts of work still in flight. Those are read as authoritative by every fresh session precisely because nothing in the flow reads them adversarially — a decision's constraint the code stopped having, a term the code renamed, a command that no longer exists. Each one keeps being obeyed until something expensive happens.

The concept: **the binding documents are claims about a repo that has moved. Go check them against it.**

## When to run it

The user types it, and the moments worth typing it are the moments the answer changes something: before designing against settled ground in unfamiliar territory, after a refactor or dependency change large enough to have moved the ground, when a session has just cited a doc that turned out to be wrong, or when work resumes after weeks away.

Not on a schedule. **A scan with nothing to find will find something** — sent looking, a model produces findings, and a manufactured drift correcting a document that was right is worse than the drift it invented.

## What gets checked

Every line, against the repo — never against what you remember of it. With an argument, only that slug or that doc.

Two of the checks below are the instrument's, read as this command was invoked: every snapshot against its ceiling, and both directions of the links — a target or anchor that is missing, a log entry nothing links, a key with prose after it. Where a policy notice shows instead (shell injection disabled for this session), run it before reporting:

```!
python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py snapshots
python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py links
```

- **`.genius/DECIDED.md`** — does each decision's constraint still exist in the code, and does its link still reach the fight that settled it?
- **`CONTEXT.md`** — does the code still call each term what the glossary says it calls it? A rename that never reached the glossary is the collision that skill exists to prevent, arriving late.
- **`ARCHITECTURE.md` and `DESIGN.md`** — does the code still respect each boundary and contract the architecture names, and do the fitness functions it lists still exist and run? Do the shipped screens still use the design's token roles, and do the contrast ratios it records still hold for the values now in the code? A boundary the code reaches around, or a raw value where a role should be, is drift a reviewer can show.
- **`.genius/BACKLOG.md`** — has the repo since satisfied a line, and do its anchors still resolve: the `From` one back into a work's log, the `[detail]` one into `BACKLOG.log.md`, and the `[retired]` links at the file's foot? Both questions can be shown — a place in the code, or a check that resolves or doesn't. **Whether a line is still worth doing cannot**, so it belongs to `/triage`, which asks it line by line with the user answering. A pass that owns a question it cannot show evidence for reports it anyway, which is what the evidence rule under *How it runs* exists to prevent. A line the user then retires leaves by the format's route for seeds, not by deletion.
- **In-flight work** — the contract at its current version, in the work's own `CONTRACT.md`: its seams, its pinned numbers, its conventions; and the snapshot's Open section, holding `assumed:` lines nobody has come back to. A snapshot over its ceiling, or carrying history that belongs in the log, is drift too — state that stopped being compacted stops being read — and so is a work file writing paths from the repository root instead of from its own folder. ⚠ The compaction one does not leave through `errata`'s three moves: nothing in it is wrong, it is only in the wrong file, so it is handed to `/compact` instead, which is what fixes it. The two link directions go there too — a link into a log whose anchor no longer exists, and the reverse, a log entry no section links any more (the direction the invariant actually promises), swept here across every work while `/compact` checks the one it touches. ⚠ **The two directions do not come back the same way.** An entry nothing links is repaired there — the link goes in the snapshot section it backs, which is a file `/compact` writes. A link whose target is genuinely not in the log **comes back reported, not fixed**, and that is the correct outcome: the repair would mean writing the log, which nothing in this flow does, so the call is the user's — whether the entry went missing or the link was always wrong is a thing only they know.
- **The `## Working Genius` section** — run the verify commands. A typecheck command that no longer exists is discovered here or at the worst moment of a close-out.
- **The links** — every log entry linked from the snapshot section it backs, every done slice pointing at an anchor that exists. A broken link is a record a cold session cannot find, which is the same as one that was never written. The block above is this check, taken mechanically; what remains is routing each line it lists — a missing anchor reported to the user, an unlinked entry to `/compact`, a key with prose after it to the format's repair.

## How it runs

Read-only, and it stays that way until the user has seen the findings. **Each finding carries what produced it** — the command and its output, the file and its place. A drift you can't show is not reported; a document that looks stale and reads fine is left alone. Say plainly what you could not check and why, because an unchecked line quietly counted as verified is exactly the failure this skill exists to catch.

Then the user calls each one, and the calls apply through the `errata` skill's three moves — corrected, superseded, or retired, each landing in the binding copy and in the record behind it. Two things never get settled here: **a decision that now looks wrong goes back to `/discern`** with the drift as ammunition, and **a term with two live meanings goes to the `domain-glossary` skill's collision**, held up side by side for the user. Both are fights, and a scan does not get to win a fight it started.

Done when every binding line has been checked against the repo or reported as uncheckable, and every accepted finding is written through `errata` — nothing rewritten on a hunch, and nothing quietly tidied on the way past.
