# Working Genius — repository instructions

This repository is the Working Genius plugin itself: the Agent Skills under `skills/`, distributed through the Claude Code plugin marketplace and the skills CLI.

## Releasing

Any change under `skills/` or `.claude-plugin/` that merges to `main` bumps `version` in `.claude-plugin/plugin.json` in the same PR. Marketplace clients detect updates only through that version — a merge without a bump ships behavior no installer can pull. If `skills/` gained or lost a skill, the count in README.md's install line moves with it.

## Conventions

- Skills are prose, and the repo stays that way: no runtime, no scripts, no state a fork can't carry.
- Every rule a skill states carries its why; a constraint that can't name its reason doesn't land.
- Killed designs stay killed unless new evidence reopens them. Before proposing express paths, sizing calls, autonomy modes, gate checklists, or skip bookkeeping, read the git history — each was removed by a recorded ruling that names its kill-reason.
- **One of those rulings was partly overturned, and this is the whole account of it.** `854261c` retired migration on three legs, and only the third fell:
  1. *An older file keeps its history inline to the end* — because a half-split monolith breaks the invariant that makes the split legible: nobody can tell a section that is missing, which is the record, from a section whose record nobody linked. **Still holds.** `/migrate` never touches an older format, and the reason does not reach two-file work, whose sections already carry their links. `19ac3c0` drew that line in the format; it should have said here that it was drawing it.
  2. *Finished files are never converted at all* — assembling a record afterwards destroys the thing that makes a kill-reason worth reading. **Still holds**, and `stage: done` is `/migrate`'s hard stop.
  3. *No migration path ships: nobody's existing file is hurting them, and a command to rewrite one is mechanism bought with churn.* **Overturned by measurement.** On one real work file the snapshot's character count across its own commits ran 1514 → 3444 (Wonder through Discernment) → **8320 at contract v1** → 25621 at the sixth slice, whole-file counts, past the 6000 ceiling from the commit after the plan and never back under it, with every close in between nominally compacting and none pushing it back; its owner reported it had become unreadable. Reproduce with `for c in $(git log --reverse --format=%h -- .genius/<slug>.md); do git show $c:.genius/<slug>.md | LC_ALL=C.UTF-8 wc -m; done` — the locale prefix matters, a bare `wc -m` counts bytes. Existing files were hurting someone.

  What reopening cost here is what it costs anywhere: a counter-example somebody measured, named against the leg it actually breaks. A leg nobody measured against stays standing.
