---
name: compact
description: Put the compaction question to a snapshot that drifted — route what no longer constrains unfinished work, and say what moves before moving it. In flight or done; the log is appended to, never edited or trimmed.
disable-model-invocation: true
argument-hint: "optional: a work slug, or nothing to put the question to every in-flight snapshot"
allowed-tools: Bash(python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py *)
---

# Compact

Every close is supposed to compact — the question in [genius-file's format](../genius-file/FILE-FORMAT.md) asked of each line, the answers routed. Snapshots drift anyway. `/reconcile` finds a snapshot over its ceiling or carrying history; **this is what fixes one** — `errata`'s moves cannot, because nothing here is wrong, it is only in the wrong file.

The concept: **the same question, the same destinations, applied where a close did not — and nothing moves before the user has seen what moves.** The format owns the question, its destinations and its tie-breaks; reading it there is the first step. What this command adds is the retroactive pass, the proposal, and the checks below.

The counts as this command was invoked — every snapshot, whole and roster excluded, against the ceiling — and both directions of the invariant: links whose target or anchor is missing, log entries nothing links, keys with prose after them. Where a policy notice shows instead (shell injection disabled), run it before proposing:

```!
python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py snapshots
python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py links
```

- **Scope: a snapshot with a log beside it, in flight or done.** Unlike `/distill`, being finished is no bar: routing a misfiled line is not correcting a wrong one (`errata` skill carries the carve-out). **The log is appended to and never otherwise touched.** A heading whose key carries prose after it is the case that most tempts a pass to break that rule; the format holds the repair, and it is the link, not the heading. ⚠ **A link whose target is genuinely not in the log is reported, never repaired** — check first that it is not the prose-after-key case. Repairing it would mean writing the log, which this command does not do, or guessing an anchor, which puts a wrong door where a missing one at least reads as missing; the call is the user's.
- **A work in some other shape is brought to the format as it is routed.** A contract still sitting in the snapshot goes to a `CONTRACT.md` created for it, in the right layer; a work sitting flat in `.genius/` moves into its folder with the repository's own move, links rebased in both directions. Lines that answer "arrived with a slice" are never routed to the log to make the number work: that trade demotes live constraints to history. A brand-new work whose log has no first entry has nothing to route into; skip it.
- **Read before proposing.** The snapshot, the `CONTRACT.md` beside it, and the log's headings. Destinations are decided against the Slices list, so a full log read is never the price of this pass.
- **Propose, then move.** Read-only until the user has seen, per section, what leaves and where to (categories and counts, not a line-by-line ballot), the character count now and after, and every line you were unsure about: one answering two branches at once (say which way the tie-break went), one whose owning slice is not obvious, one whose log heading carries prose after the key. One confirmation covers the batch; a move the user has not seen is a silent one.
- **Count the way the format counts**, instrument and exclusions both: a full-text count reads a thirty-slice migration as bloated when its prose is half the ceiling, and every remedy you would then reach for is wrong. The count *after* is the same command run again once the moves are made, never arithmetic on the proposal.
- **Under-ceiling is not the same as compacted, and this pass says which it found.** A snapshot under its ceiling can still carry a closed slice's paragraph; one over it can be a large roster that is exactly right. Where the question moves nothing, say "nothing to route": that is a result.
- **Where the count stays over after routing, say so and stop.** The remedies from there are not this command's: a Problem section carrying design, an Open section nobody drained, a cut that is really two pieces of work. Name which it looks like; never shorten a kill-reason to make a number.

## Where the branches land

- **Into `CONTRACT.md`, in the right layer.** The brief, the seams and the pinned values belong to the plan layer; a convention a slice established belongs to the established layer with its source link. The wrong layer costs everything at the next version bump, which replaces the plan layer whole.
- **Into the log, in the shape the format names** — verbatim, keyed off the anchor its line already links.
- **Open drains by its own rule**: a consumed `assumed:` to the log; an item that is its own work to the log verbatim first, with `.genius/BACKLOG.md` taking a one-line seed pointing at that anchor (links from `.genius/` start with the slug's folder).
- **`stage: done` changes three things.** The resting shape stays whole — Problem, Decision, changelog, roster — whatever a literal reading of the question says. `CONTRACT.md` is not drained. And a log already carrying `distilled at close-out` will not be distilled again, so anything appended after that line stays forever: say in the pass entry that content follows the distillation.

## Finishing

- **Mark the pass** — `## compacted-<date>` in the log, naming what moved and where, with a link left in the snapshot beside the drained-from section.
- **Check both directions before reporting done**: run `links` again, because the moves just made are what can break them. An entry that should be reachable and is not gets its link restored here, in the section it backs — a snapshot write, this command's own layer, and the half of the invariant nothing else sweeps per work.
- **Check that nothing binding left the binding layer**: every line that was in the contract section is now in `CONTRACT.md` or the snapshot. A contract line that reached only the log has been silently demoted from binding to history.

Done when every targeted snapshot has been routed and reported, or named as skipped with the reason that is true of it — and what the pass could not fix is stated rather than trimmed around.
