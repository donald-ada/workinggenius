---
name: compact
description: Put the compaction question to a snapshot that drifted — route what no longer constrains unfinished work, and say what moves before moving it. In flight or done; the log is appended to, never edited or trimmed.
disable-model-invocation: true
argument-hint: "optional: a work slug, or nothing to put the question to every in-flight snapshot"
---

# Compact

Every close is supposed to compact — the question in [genius-file's format](../genius-file/FILE-FORMAT.md) asked of each line, the answers routed. Snapshots drift anyway: a close that ran before the question existed, a session that read "compact to current truth" as satisfied by changing nothing, a stretch of slices closed in a hurry. `/reconcile` is what finds a snapshot over its ceiling or carrying history; **this is what fixes one** — `errata`'s three moves cannot, because nothing here is wrong, it is only in the wrong file.

The concept: **the same question, the same destinations, applied where a close did not — and nothing moves before the user has seen what moves.** The rule is not this command's to invent: that format owns the question, its three destinations and its two tie-breaks, and reading it there is the first step, not a formality. What this command adds is the retroactive pass, the proposal, and the checks below.

- **Scope: a snapshot with a log beside it, in flight or done.** Unlike `/distill`, being finished is no bar. **The log is appended to and never otherwise touched** — not edited, not trimmed, not tidied. A heading whose key is followed by prose (`## s4-board 配置状态牌四件`) has a slug that is not its key, so links to it are already broken; the fix is to correct the *link*, in the snapshot, where things bind — never the heading, which records (`errata` skill).
- **Two shapes are out of scope, and each gets its own true reason.** An older format — history inline in one file, or a `<slug>/` of per-stage records — has no second file to route into. A brand-new work whose log has no first entry yet is *not* an older format; it simply has nothing to route into either, and saying "skipped, older format" about it is a false reason for a true skip.
- **Read before proposing.** The snapshot, the `CONTRACT.md` beside it where Galvanizing wrote one, and the log's headings. Destinations are decided against the Slices list, which is in the snapshot, so a full log read is never the price of this pass.
- **Propose, then move.** Read-only until the user has seen, per section, what leaves and where to (categories and counts, not a line-by-line ballot), the character count now and after, and every line you were unsure about. Three things make a line unsure, and each has to be said rather than quietly decided: it answers two branches at once (the tie-break covers it, say which way it went), its owning slice is not obvious, or its log entry's heading carries prose after the key so the link cannot be written. One confirmation covers the batch; a move the user has not seen is a silent one.
- **Count the way the format counts.** Characters, not lines and not bytes (`LC_ALL=C.UTF-8 wc -m`, or Python) — and **with the Slices roster excluded**, since the roster does not count against the ceiling. A full-text count reads a thirty-slice migration as bloated when its prose is half the ceiling, and the three remedies you would then reach for are all wrong.
- **Under-ceiling is not the same as compacted, and this pass says which it found.** A snapshot under its ceiling can still be carrying a closed slice's paragraph; one over it can be a large roster that is exactly right. Report the two separately, and where the question moves nothing, say "nothing to route" — finding a snapshot already in shape is a result, not a failure to find work.
- **Where the count stays over after routing, say so and stop.** The remedies from there are not this command's: a Problem section carrying design, an Open section nobody drained, or a cut that is really two pieces of work. Name which it looks like; never shorten a kill-reason to make a number.

## Where the branches land

- **Into `CONTRACT.md`, in the right layer.** The brief, the test seams and the pinned values belong to the plan layer; a convention a slice established belongs to the established layer with its source link. Putting them in the wrong layer costs nothing today and everything at the next version bump, which replaces the plan layer whole: seams filed as "established" survive a replacement they should not have, and anything filed as "plan" that a slice established is deleted while it still binds.
- **Into the log, in the shape the format names** — verbatim, keyed off the anchor its line already links.
- **Open drains by its own rule** (the format's fourth law): a consumed `assumed:` to the log, an item that is its own work to the log verbatim first, with `.genius/BACKLOG.md` taking a one-line seed pointing at that anchor. `BACKLOG.md` sits at `.genius/`, so its links start with the slug's folder — and before adding one, look at what basis that file's existing lines use. Leaving a file half on each basis is worse than leaving it wholly on the old one, because nobody can then tell which links were meant to work.
- **`stage: done` changes three things.** The roster stays whole, whatever a literal reading of the question says about it. `CONTRACT.md` is not drained — Tenacity's close-out settled that. And a log already carrying `distilled at close-out` will not be distilled again, so anything appended after that line stays forever: append it only where it is worth keeping on those terms, and say in the pass entry that content follows the distillation.

## Finishing

- **Mark the pass** — `## compacted-<date>` in the log, naming what moved and where, with a link to it left in the snapshot beside the drained-from section, so it is reachable like everything else.
- **Check both directions before reporting done.** Every link in the snapshot resolves to a heading that exists, and every `##` entry in the log is linked from the snapshot or named in the report as one that should not be. The second direction is the one this pass can break, and the one the invariant actually promises.
- **Check that nothing binding left the binding layer**: every line that was in the contract section is now in `CONTRACT.md` or the snapshot. A contract line that reached only the log has been silently demoted from binding to history, which is the one failure this pass could cause that nobody would notice.

Done when every targeted snapshot has been routed and reported, or named as skipped with the reason that is actually true of it — and when what the pass could not fix is stated rather than trimmed around.
