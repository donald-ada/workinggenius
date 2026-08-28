---
name: reconcile
description: Check the project's binding documents against the repo they describe — settled decisions, glossary terms, pinned commands, in-flight plan contracts, the links between file and record — and route every drift to its correction.
disable-model-invocation: true
argument-hint: "optional: a work slug, or one doc to check"
---

# Reconcile

The `errata` skill catches what a session trips over. Nobody trips over the rest: `.genius/DECIDED.md`, `CONTEXT.md`, `DESIGN.md`, the pinned verify commands, the contracts of work still in flight. Those are read as authoritative by every fresh session precisely because nothing in the flow reads them adversarially — a decision's constraint the code stopped having, a term the code renamed, a command that no longer exists. Each one keeps being obeyed until something expensive happens.

The concept: **the binding documents are claims about a repo that has moved. Go check them against it.**

## When to run it

The user types it, and the moments worth typing it are the moments the answer changes something: before designing against settled ground in unfamiliar territory, after a refactor or dependency change large enough to have moved the ground, when a session has just cited a doc that turned out to be wrong, or when work resumes after weeks away.

Not on a schedule. **A scan with nothing to find will find something** — sent looking, a model produces findings, and a manufactured drift correcting a document that was right is worse than the drift it invented.

## What gets checked

Every line, against the repo — never against what you remember of it. With an argument, only that slug or that doc.

- **`.genius/DECIDED.md`** — does each decision's constraint still exist in the code, and does its link still reach the fight that settled it?
- **`CONTEXT.md`** — does the code still call each term what the glossary says it calls it? A rename that never reached the glossary is the collision that skill exists to prevent, arriving late.
- **`.genius/BACKLOG.md`** — is each line still worth doing, and does its source anchor still resolve? A line the repo has since satisfied, or whose reason no longer holds, is a finding for the user to call like any other.
- **In-flight work** — the contract at its current version, in the work's own `CONTRACT.md`: its seams, its pinned numbers, its conventions; and the snapshot's Open section, holding `assumed:` lines nobody has come back to. A snapshot over its ceiling, or carrying history that belongs in the log, is drift too — state that stopped being compacted stops being read. ⚠ That one does not leave through `errata`'s three moves: nothing in it is wrong, it is only in the wrong file, so it is handed to `/compact` instead. So is a link into a log whose anchor no longer exists — and so is the reverse, a log entry no section links any more, which is the direction nothing else checks and the one the invariant actually promises. A work file writing paths from the repository root instead of from its own folder is drift too.
- **The `## Working Genius` section** — run the verify commands. A typecheck command that no longer exists is discovered here or at the worst moment of a close-out.
- **The links** — every log entry linked from the snapshot section it backs, every done slice pointing at an anchor that exists. A broken link is a record a cold session cannot find, which is the same as one that was never written.

## How it runs

Read-only, and it stays that way until the user has seen the findings. **Each finding carries what produced it** — the command and its output, the file and its place. A drift you can't show is not reported; a document that looks stale and reads fine is left alone. Say plainly what you could not check and why, because an unchecked line quietly counted as verified is exactly the failure this skill exists to catch.

Then the user calls each one, and the calls apply through the `errata` skill's three moves — corrected, superseded, or retired, each landing in the binding copy and in the record behind it. Two things never get settled here: **a decision that now looks wrong goes back to `/discern`** with the drift as ammunition, and **a term with two live meanings goes to the `domain-glossary` skill's collision**, held up side by side for the user. Both are fights, and a scan does not get to win a fight it started.

Done when every binding line has been checked against the repo or reported as uncheckable, and every accepted finding is written through `errata` — nothing rewritten on a hunch, and nothing quietly tidied on the way past.
