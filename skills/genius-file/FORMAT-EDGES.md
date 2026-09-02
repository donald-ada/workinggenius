# Format Edges

What [FILE-FORMAT.md](FILE-FORMAT.md) leaves out on purpose: the one repair a session meets rarely, and the measurements behind rules that would otherwise read as arbitrary. Read it when you meet the case, or before disagreeing with a rule. `/compact`, `/distill` and `/reconcile` read it as a matter of course; a slice close never does.

## A heading that broke its own anchor

A log heading that appends prose after its key (`## s4-board 配置状态牌四件`) is a different anchor from the key, so every link to it is already broken. **The repair is the link, never the heading** — and every link to it, not the first one you saw. The heading records and the snapshot binds; fixing the heading edits a record to spare a binding file an edit, which is the layering exactly backwards (`errata` skill). This is the case that most tempts a retroactive pass into editing a log, and the one `/compact` checks for before calling a link's target missing: it looks missing and is not.

## What was measured

The rules are what they are because of these, and a rule reopens the way every ruling here reopens — a counter-example somebody measured, named against the leg it breaks.

- **Characters, not lines.** At 90 columns on one real Chinese work file, a 305-line snapshot displayed as 595 lines (1.95×) and a 17-line backlog as 82 (4.82×); one entry ran to 842 columns on a single physical line. A line budget rewards not pressing return; characters cannot be reflowed away. (`5a5f6de`)
- **Not bytes.** `wc -m` under an unset or `C` locale reported 9596 on a compliant 4939-character CJK snapshot. A ceiling defended by an instrument that silently doubles on the writing system that motivated it is worse than no ceiling. (`5a5f6de`)
- **A ceiling without an object does not hold.** One real snapshot's character count across its own commits ran 1514 → 3444 through Discernment, 8320 at contract v1, 25621 at the sixth slice — over the ceiling from the commit after the plan and never back under, with every close nominally compacting. That is why compaction has a question, and why the contract has its own file. (`76fd725`)
- **The log does not already hold what a collapse displaces.** On a real work file the log carried every distinctive token of the later slices' paragraphs and only 57–78% of the first two slices', because early entries are thinner than the summaries written above them. That is why a collapse appends verbatim and never reads the log to decide what is redundant. (`5a5f6de`)
- **Provenance is not a removal trigger.** Block titles in the contract's established layer are written as "who established this", not "who still needs it"; an eviction pass keyed on those titles threw away the newest rule in the file. That is why the established layer is never drained.
- **A seed that became its work can still lose content.** Measured once: a backlog seed's stated rule reached no section of the work that absorbed it. That is why the line leaves only after checking the work took the seed's content up. (`84f227b`)
