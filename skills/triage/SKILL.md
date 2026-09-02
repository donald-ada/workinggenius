---
name: triage
description: Put the backlog's own rules to the backlog — seeds that should no longer be there, pairs that are one discovery, seeds that outgrew a line, and the order nobody has stated. Judged one at a time, landed only by the user's call.
disable-model-invocation: true
argument-hint: "optional: one seed's subject, to rule on that line alone"
---

# Triage

`.genius/BACKLOG.md` is read whole on every `/genius`, and grows by how many discoveries the flow made. The rules bounding it are written already — the seed's shape and its 300 characters (`record-prose`), where a line goes when it leaves ([BACKLOG-FORMAT.md](../genius-file/BACKLOG-FORMAT.md)) — each firing in its own moment, with nothing going back to check. `/reconcile` reaches the file from the repo's side. What no pass asks is what the flow's own records, and the user, say about these lines.

The concept: **the rules exist; this is the pass that enforces them, one line at a time, and the user rules on each.**

## When to run it

The user types it — after a stretch of slices that each dropped one, when `/genius` shows a backlog nobody can scan, or when a work's leftovers land. Not on a schedule: a pass sent looking finds something, and a seed argued away on a made-up reason is worse than a long file.

With an argument, only the line whose subject it names, and only the two questions one line can answer — should it be here, has it outgrown a line. Pairing needs candidates and order needs the file: say those went unasked rather than answering them from one line.

## What gets asked

Four questions in this order, because each earlier one can take away what a later one would have worked on: shortening a line about to leave is work thrown out, pairing after a promotion removed one of the pair is a discovery split in half, and order alone reads the file as it will finally stand.

- **Should it still be here at all?** Two ways it should not. **A work already answered it** — asked against the flow's own state, not the code: does a work name this seed's subject in its Problem, Slices or contract, with that slice closed? Which move that earns turns on which came first — the format holds that line. Check the other direction first: a work whose snapshot says the thing is *still* not done is evidence to keep the seed. **Or its reason stopped holding** — what it protects against stopped mattering. No file holds that answer, which is why a pass that must show its evidence cannot ask it: the seed's own stated why is quoted back, and the user says whether it stands.
- **Are two of them one discovery?** Propose the pair, both texts, never the merge. Three mechanical signals — a shared log anchor, a shared symbol, a seed calling itself its neighbour's illness — were all false positives on the one real file tried, so nothing merges on a signal and the reason must be checkable in the two texts. The format holds the veto and the mechanics; this pass brings the pair.
- **Has it outgrown a line?** Over 300 characters, counted the way the format's measure counts — a byte count called five compliant lines over the bound on one real Chinese backlog, and that error runs toward manufacturing work. `record-prose` names two cases; this tells them apart: **a seed still holding an undecided choice** — two live routes, or a line saying someone must rule — is a seed carrying detail that belongs elsewhere: route it out — to the log its link names where that entry holds it, to `BACKLOG.log.md` otherwise — and trim. **A seed that is one chosen route plus its steps** is a plan, and it gets offered as work — one at a time, never as a batch: a work file is larger than the line it replaces and every full status pass reads it, so four at once buys a smaller backlog and a bigger read.
- **What does the order say?** Top to bottom is the file's statement of what to do next; the format says why it may not also live in the prose. What this pass adds is the proposal: the position, and the sentence it was read from, the text itself left to the user.

## How it runs

**Read `.genius/` and nothing else**, and inside it only what the questions need: the backlog, `HISTORY.md`, the work snapshots, in flight and done alike since the work that answered an old seed is usually finished, and one log entry, by the anchor a seed's link names — that entry often sits in a done work's log and following it there is the point; what is barred is reading such a log whole, the sweep `HISTORY.md` exists to spare. Not the code. That bound separates this pass from a session reading the whole project: one such run reached the same rulings after opening over forty files across two repositories. A judgment it cannot reach inside `.genius/` is reported as unreached, never guessed — "the repo may have satisfied this one" is that, and goes to `/reconcile`.

**Read-only until the user has ruled, one line at a time.** Each proposal carries the seed's own words, which question it answers, what it wants done, and where the text goes. Categories and counts are the other retroactive passes' form and wrong here: every one of these is "is this still worth doing", the user's alone. An honest zero proves nothing was manufactured, so say it when there is nothing.

Then the calls land, each through the discipline that owns it: a retirement or a correction through `errata`'s moves into `BACKLOG.log.md`, a merge by the format's own mechanics, a promotion through `/genius` as a new work, a reorder as a write of the lines. ⚠ One lands as a bare deletion: a seed that *became* its work writes no entry (the format says why), and filing it as a retirement puts a body in the log nothing was displaced into.

Done when every line in scope — the file, or the one line an argument named — has been through the questions that scope allows and carries a ruling or an explicit no-change, and everything undecidable inside `.genius/` is named: a report of what was looked at reads exactly like one of what was left alone.
