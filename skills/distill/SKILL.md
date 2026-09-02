---
name: distill
description: Retroactively distill the logs of finished work — delete what the repo now answers, keep what code cannot say. Done work only; in-flight logs are never touched.
disable-model-invocation: true
argument-hint: "optional: a work slug, or nothing to sweep all undistilled done work"
---

# Distill

Tenacity distills a log at close-out. Work that finished before that rule existed — or closed without it — still carries everything: per-criterion evidence for tests that live in the tree, full bodies of contracts the final version replaced, an interview whose confirmed problem has lived in the snapshot ever since. This command runs the same move, later, on the logs that never got their pass.

The concept: **close-out's one rule — does the repo answer this now? — applied where close-out never was, with the check close-out didn't need.** At close-out the verification is minutes old; here it may be months, so the rule is a live question per item, not an assumption:

- **Scope: done, has a log, undistilled.** Only works at `stage: done` that have a `<slug>.log.md` beside the snapshot whose first line is not `distilled`. In-flight logs are never touched, whatever the argument says. A done work with no log at all has nothing to distill: skip it and say so.
- **An item leaves only if the repo still answers it.** Per-criterion evidence goes where the test it names is still in the tree; a test the repo has since dropped makes that line possibly the last record standing — it stays. Superseded contract bodies go (each keeps its one-line why); the interview's play-by-play goes where the snapshot carries the confirmed problem; a close-out review report shrinks to its one-line stub where the snapshot carries its findings and resolutions. What code can never answer always stays: decisions and kill-reasons, corrections and what overturned them, the user's words as they said them.
- **A pointed-at entry stays, whatever its category.** Before an entry leaves, check nothing still links to it — ⚠ **`.genius/BACKLOG.log.md` first** — a retired seed's body went in carrying its `From` link, and unlike every other pointer here that one can never be repaired, because the file it sits in is append-only. Then `.genius/DECIDED.md`, `.genius/BACKLOG.md`, whose every line carries a `From [<slug>](…#<anchor>)` back into some log, and ⚠ **the work's own `CONTRACT.md`**, whose established layer names its source entry per block. That last one is inside the folder and easy to read past, and it is the one that outlives the rest: the contract is never drained, not at a bump and not at done, so its `[source]` links are still live when this pass runs months later — and per-criterion evidence is exactly what a block established by a slice points at. An anchor something points at is load-bearing; deleting it breaks the door that pointer exists to be.
- **Propose, then delete — never the other way.** Read-only until the user has seen, per log, what leaves and what stays (categories and counts, not a line-by-line ballot); one confirmation covers the batch. A deletion the user hasn't seen is a silent one, and this flow doesn't do silent removal (`errata` skill).
- **Mark the pass.** The log's first line becomes `distilled retroactively, <date>`. Links that pointed at removed entries leave with them — a slice line keeps its check and its words, never a dead anchor — so `/reconcile` finds no holes.

Done when every targeted log is distilled, or named as skipped with its reason. Run it once per backlog of old work; after that, close-out keeps every new log distilled on its way out.
