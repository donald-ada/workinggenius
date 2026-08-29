---
name: triage
description: Put the backlog's own rules to the backlog — seeds a work already answered, pairs that are one discovery, seeds that outgrew a line, and the order nobody has stated. Judged one at a time, landed only by the user's call.
disable-model-invocation: true
argument-hint: "optional: one seed's subject, to rule on that line alone"
---

# Triage

`.genius/BACKLOG.md` is paid for on every `/genius`: it is read whole, every time, and it grows by how many discoveries the flow made. The rules that bound it are already written — one line and 300 characters (`record-prose`), a started item's line goes (`genius-file`), what leaves goes to `BACKLOG.log.md` ([FILE-FORMAT.md](../genius-file/FILE-FORMAT.md)). Each fires in its own moment and nothing goes back to check. `/compact` fixes a snapshot that drifted, `/distill` a done work's log, `/reconcile` the binding docs against the repo — and `/reconcile` reaches this file too, from the repo's side: whether the code has since satisfied a line, and whether its anchor still resolves. What no pass asks is what the flow's own records say about these lines.

The concept: **the rules exist; this is the pass that enforces them, one line at a time, and the user rules on each.**

## When to run it

The user types it — after a stretch of slices that each dropped a seed, when `/genius` shows a backlog nobody can scan, or when a work closes and its leftovers land here. Not on a schedule: a pass sent looking will find something, and a seed argued out of existence on a manufactured reason is worse than a long file.

With an argument, only the line whose subject it names — for the first two questions. The last two are about a line's relation to its neighbours, so they need the file; say plainly that they were not asked rather than answering them from one line.

## What gets asked

Four questions, **the two that remove a line before the two that adjust one** — shortening a line that is about to merge away is work thrown out, and merging after a promotion has already taken one of the pair away is a discovery split in half.

- **Has a work already answered it?** Not "has the repo satisfied it" — that one is asked against the code and belongs to `/reconcile`. This is asked against the flow's own state: does a work name this seed's subject in its Problem, its Slices or its contract, and is that slice closed? Which move that earns turns on which came first, and the format holds the line and its why — read it there. Check the other direction first: a work whose own snapshot says the thing is *still* not done is evidence to keep the seed, not to cut it.
- **Are two of them one discovery?** Propose the pair, both texts, never the merge. Three mechanical signals — a shared log anchor, a shared symbol, a seed calling itself the same illness as its neighbour — were all false positives on the one real file this was tried against, which is why nothing here merges on a signal, and why the reason offered must be one a reader can check in the two texts. The format's veto and the mechanics of the move are there; this pass only brings the pair.
- **Has it outgrown a line?** Over 300 characters `record-prose` names two cases, and this is what tells them apart: **a seed still holding an undecided choice** — two live routes, or a line saying someone must rule — is a seed carrying detail that belongs elsewhere, so route the detail out and trim. **A seed that is one chosen route plus its steps** is a plan, and it gets offered as work — one at a time, never as a batch: a work file is larger than the line it replaces and every full status pass reads it, so promoting four at once buys a smaller backlog and a bigger read.
- **What does the order say?** Top to bottom is the file's statement of what to do next (the format says why it may not also live in the prose). What this pass adds is the proposal: the position, and the seed's own sentence it was read from, with the text itself left to the user.

## How it runs

**Read `.genius/` and nothing else**, and inside it only what the questions need: the backlog, `HISTORY.md`, the work snapshots — in flight and done alike, since the work that answered a year-old seed is usually a finished one — and a log entry only where one seed's link is followed for one specific question. Not the code, and not a done work's log, which is the expensive read `HISTORY.md` exists to spare. That bound is what separates this pass from a session that reads the whole project to answer the same four questions: measured against one such run, the unbounded version opened over forty files across two repositories to reach the same rulings. A judgment this pass cannot reach inside `.genius/` is reported as unreached, never guessed — "the repo may have satisfied this one" is exactly such a judgment, and it goes to `/reconcile`.

**Read-only until the user has ruled, and ruled one line at a time.** Each proposal carries the seed's own words, which question it answers, what it wants done, and where the text goes. Categories and counts are the other retroactive passes' form and wrong here: every one of these is "is this still worth doing", which is the user's alone. Where nothing is found, say so plainly — an honest zero is what proves the pass was not manufacturing work.

Then the calls land, each through the discipline that owns it: a retirement or a correction through `errata`'s moves into `BACKLOG.log.md`, a merge by the format's own mechanics, a promotion through `/genius` as a new work, a reorder as a write of the lines themselves.

Done when every line has been through all four questions and carries a ruling or an explicit no-change, and everything undecidable inside `.genius/` has been named — a report that says which lines were looked at cannot be told apart from one that says which lines were left alone.
