---
name: triage
description: Put the backlog's own rules to the backlog — seeds that should no longer be there, pairs that are one discovery, seeds that outgrew a line, and the order nobody has stated. Judged one at a time, landed only by the user's call.
disable-model-invocation: true
argument-hint: "optional: one seed's subject, to rule on that line alone"
---

# Triage

`.genius/BACKLOG.md` is read whole on every `/genius` and grows by how many discoveries the flow made. The rules that bound it are already written — one line and 300 characters (`record-prose`), a started item's line goes (`genius-file`), what leaves goes to `BACKLOG.log.md` ([FILE-FORMAT.md](../genius-file/FILE-FORMAT.md)). Each fires in its own moment and nothing goes back to check. `/reconcile` reaches the file from the repo's side — has the code satisfied a line, does its anchor resolve. What no pass asks is what the flow's own records, and the user, say about these lines.

The concept: **the rules exist; this is the pass that enforces them, one line at a time, and the user rules on each.**

## When to run it

The user types it — after a stretch of slices that each dropped a seed, when `/genius` shows a backlog nobody can scan, or when a work's leftovers land here. Not on a schedule: a pass sent looking will find something, and a seed argued away on a manufactured reason is worse than a long file.

With an argument, only the line whose subject it names, and only the two questions one line can answer — should it be here, has it outgrown a line. Pairing needs candidates and order needs the file, so say those were not asked rather than answering them from one line.

## What gets asked

Four questions, **the two that remove a line before the two that adjust one** — shortening a line that is about to merge away is work thrown out, and merging after a promotion has already taken one of the pair away is a discovery split in half.

- **Should it still be here at all?** Two ways it should not, both ending in the same move. **A work already answered it** — asked against the flow's own state, not the code ("has the repo satisfied it" is `/reconcile`'s): does a work name this seed's subject in its Problem, its Slices or its contract, and is that slice closed? Which move that earns turns on which came first, and the format holds the line and its why. Check the other direction first: a work whose own snapshot says the thing is *still* not done is evidence to keep the seed. **Or its reason stopped holding** — what it protects against stopped mattering. No file holds that answer, which is why it is asked here and not by a pass that must show its work: the seed's own stated why is quoted back, and the user says whether it still stands.
- **Are two of them one discovery?** Propose the pair, both texts, never the merge. Three mechanical signals — a shared log anchor, a shared symbol, a seed calling itself the same illness as its neighbour — were all false positives on the one real file this was tried against, so nothing merges on a signal and the reason offered must be checkable in the two texts. The format's veto and the mechanics of the move are there; this pass only brings the pair.
- **Has it outgrown a line?** Over 300 characters, counted the way the format's measure section counts — a byte count called five compliant lines over the bound on one real Chinese backlog, and this instrument errs toward manufacturing work. `record-prose` names two cases, and this is what tells them apart: **a seed still holding an undecided choice** — two live routes, or a line saying someone must rule — is a seed carrying detail that belongs elsewhere, so route the detail out and trim. **A seed that is one chosen route plus its steps** is a plan, and it gets offered as work — one at a time, never as a batch: a work file is larger than the line it replaces and every full status pass reads it, so promoting four at once buys a smaller backlog and a bigger read.
- **What does the order say?** Top to bottom is the file's statement of what to do next (the format says why it may not also live in the prose). What this pass adds is the proposal: the position, and the seed's own sentence it was read from, with the text itself left to the user.

## How it runs

**Read `.genius/` and nothing else**, and inside it only what the questions need: the backlog, `HISTORY.md`, the work snapshots — in flight and done alike, since the work that answered a year-old seed is usually a finished one — and a log entry only where a seed's link is followed for one specific question. Not the code, and not a done work's log — the expensive read `HISTORY.md` exists to spare. That bound is what separates this pass from a session reading the whole project: measured against one such run reaching the same rulings, the unbounded version opened over forty files across two repositories. A judgment it cannot reach inside `.genius/` is reported as unreached, never guessed — "the repo may have satisfied this one" is exactly that, and it goes to `/reconcile`.

**Read-only until the user has ruled, and ruled one line at a time.** Each proposal carries the seed's own words, which question it answers, what it wants done, and where the text goes. Categories and counts are the other retroactive passes' form and wrong here: every one of these is "is this still worth doing", the user's alone. Where nothing is found, say so — an honest zero is what proves the pass was not manufacturing work.

Then the calls land, each through the discipline that owns it: a retirement or a correction through `errata`'s moves into `BACKLOG.log.md`, a merge by the format's own mechanics, a promotion through `/genius` as a new work, a reorder as a write of the lines themselves.

Done when every line has been through all four questions and carries a ruling or an explicit no-change, and everything undecidable inside `.genius/` is named — a report of what was looked at reads exactly like one of what was left alone.
