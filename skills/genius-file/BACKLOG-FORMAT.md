# The Backlog and Its Log

The cross-work files at `.genius/` — `BACKLOG.md` with `BACKLOG.log.md` behind it — have a format of their own, split out of [FILE-FORMAT.md](FILE-FORMAT.md) because a slice close never needs it: it is read by `/genius`, `/triage`, `/reconcile` and `/distill`, and by whichever stage is about to route an Open line out as a seed.

**The seed's shape:** `- **<what>** — <why it matters>. From [<slug>](<slug>/<slug>.log.md#<anchor>), <date>.` One physical line, 300 characters at most (`record-prose` holds why); the `From` link is relative to `.genius/` (FILE-FORMAT's link rule).

`BACKLOG.md` grows by how many discoveries the flow made, and the per-line bound was never a bound on the file: measured on one real project, sixteen commits took it from 748 to 10062 characters without one leaving it smaller. So it gets the same two-file shape a work gets, and the same invariant: **nothing leaves `BACKLOG.md` except into `BACKLOG.log.md` or into the work file it became, and a link is left behind wherever there is still a line to carry it.** `BACKLOG.log.md` sits beside it, is append-only, and is created at its first entry, not before. An entry's key is a short descriptive slug plus the date, `<slug>-<date>` — `stale-vpp-tooltip-2026-08-29` is one whole key — because a seed can be corrected, merged and retired across months and those are the same seed, so the key cannot be unique by construction the way a numbered slice is. The seed points at one with `[detail](BACKLOG.log.md#<slug>-<date>)`.

That turns three moves that were deletions into routing:

- **Retire** — a seed whose work is done, or whose reason stopped holding. The body goes to the log with what retired it; the line goes.
- **Merge** — two seeds that are one discovery. Both bodies go to the log verbatim; one seed remains, carrying both links. ⚠ A seed that says *why it must stay separate* is not a merge candidate, and the surviving seed still obeys the per-line bound: **two seeds that cannot say their one discovery inside one line were not one discovery**, or they are a piece of work.
- **Correct** — the seed is rewritten in place; the old wording and what overturned it are appended (`errata`'s move, applied here).

Retire, like the snapshot's Open drain, is the case where the line itself leaves, so no link can survive in its place: **`BACKLOG.md` carries `[retired](BACKLOG.log.md#<slug>-<date>)` at its foot, one per retirement, never one accumulating them** — the log is append-only, so no later retirement can be filed under an earlier anchor, and an overwritten link is text nobody can reach.

**Starting the work is the fourth way a line leaves, and the one that writes no log entry**: the new work file is its home now (`genius-file` skill). Nothing is lost *if the work really took the seed's content up* — measured once and found false, where a seed's stated rule reached no section of the work that absorbed it — so check that before the line goes, and land whatever the work missed where the builder reads. ⚠ **The line between this and Retire is which came first.** A seed that *became* the work leaves this way. A seed an already-running work absorbed on its way past is retired, with the absorbing work named, because there the work file was never that seed's home and without the entry nothing records that the seed was answered rather than forgotten.

⚠ **Trimming a seed displaces text even though the line stays**: it lands here like anything else that leaves the file — unless the seed's own link already names a log entry that holds the detail, in which case it goes there. Text follows the pointer that will be looked for.

⚠ **`BACKLOG.log.md` is not a third exit from the snapshot.** An Open item that is work in its own right routes through *its own work's* log, with the seed pointing there. This log takes only what leaves `BACKLOG.md` itself.

**Order is the file's own statement of what to do next** — top to bottom. A new seed is appended at the bottom, where "not yet placed" is what its position honestly says; reordering is a deliberate write, never a pass that silently re-sorts. Order stated in the prose of the seeds as well drifts from the one the positions say, and the reader cannot tell which is current.

⚠ **The cross-work files are not a piece of work, whatever their shape.** `BACKLOG.md` with its log looks like a snapshot with its log, and it is no *work's* log: a pass that sweeps works' logs does not reach it, though `errata` treats it as record layer. A folder would say it belongs to one work, and a sweep that deletes by work would delete what every work still points through.
