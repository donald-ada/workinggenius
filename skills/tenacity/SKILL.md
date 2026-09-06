---
name: tenacity
description: Drive the work to actually-done — fresh verification of every claim, context-isolated diff review, cleanup, commit, post-mortem. Use when a tracked piece of work is ready to close out, whether it moved through slices or was built directly after Wonder without them.
allowed-tools: Bash(python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py *)
hooks:
  Stop:
    - hooks:
        - type: command
          command: python3 "${CLAUDE_PLUGIN_ROOT}/skills/genius-file/stop-judge.py"
          timeout: 90
---

# Tenacity

The genius of finishing. Its failure mode is the false "done": satisfaction declared on stale evidence, or on no evidence at all.

The concept: **"done" is a claim about fresh evidence, and evidence expires with the session.** If the command didn't run here, its result doesn't exist. Re-read the snapshot, the `CONTRACT.md` it points at (that file is the contract; your memory of it is not), and, of the log entries it links, the slices' evidence alone — the rest of the log holds process, not claims to verify. Then run everything fresh and read the output: the suite, the checks, every acceptance criterion; where there is no Slices section, the Problem section's success criteria instead. "Should pass", "passed earlier", "seems to work" are each a command you haven't run in this session.

Where the slices recorded a dirty baseline, the fresh run is held to the same line, no new failures, and the baseline is named in this stage's evidence. Have the plugin's `reviewer` agent ([agents/reviewer.md](agents/reviewer.md)) judge the diff from `base:` against the brief — its task message naming the diff, what it is judged against, where the record lives, and which slices already carried their own review, so its weight falls on the joints between slices no seam test reaches and the drift of the whole against the brief. Don't tell it what not to flag; treat its findings as claims to verify. Spawn it synchronously where you cannot be certain the harness wakes you, and never end your turn while it runs — a review nobody reads did not run. Where `base:` was never pinned, pin it now — the commit before this work's changes began.

Walk the recorded `assumed:` and `owed:` lines — an assumption that contradicts the brief is a defect however green the tests, and an `owed:` line is a criterion nobody's eyes have checked: put it to the user now, before done is said, and drain it with what they saw. Whatever the fresh run disproves is corrected rather than quietly dropped (`errata` skill). Before the user accepts, name the `blindspot` skill's quiz and let them call it: built work nobody absorbed is next month's surprise.

## How it runs

1. Re-read the snapshot, its `CONTRACT.md`, and the slices' evidence entries alone. Pin `base:` where Galvanizing never did.
2. Run everything fresh — the suite, the checks, every criterion — and read the output. A recorded dirty baseline is held at no new failures and named.
3. Spawn the `reviewer` agent against the diff from `base:`, naming which slices were already reviewed; verify its findings; resolve what is real. Stay awake until it returns.
4. Walk the `assumed:` and `owed:` lines — the latter put to the user's eyes now; correct what the run disproved (`errata` skill). Name the `blindspot` quiz before the user accepts.
5. Close out, each move its own act (below): the log entry with the evidence whole, cleanup, the decision index, slice issues, the snapshot compacted with Open emptied, the commit, `stage: done`, the parent issue last.
6. Distill the log, announced; then the post-mortem line, checked against and appended to `.genius/HISTORY.md`.

Close-out. Write this stage's log entry: the evidence as it ran — every command, its output, the reviewer's report whole; the snapshot keeps the findings and their resolution, one line each. Anchors come from `python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py anchors <slug>`, never from opening the log, and the diff is the reviewer's to read: what this stage reads it carries to its last turn. Clean up debug artifacts. Write the decision index line for anything this work settled that a future stranger would re-fight (`decision-record` skill) — the contract's established layer first, block by block, since a seam or convention a slice introduced is what the next work re-derives unless a line lets it search. Close any slice issues still open. Compact the snapshot to its resting shape by the format's question, with Open emptied: each line resolved into the log, or moved to `.genius/BACKLOG.md` where it's work this work won't do. ⚠ **`CONTRACT.md` is not drained at done**: it stays whole as the final version the work was verified against. Commit, mark the work done, and close the parent issue last, if there is one: its open state is the work's live status in the tracker.

Then distill the log — the one deliberate deletion this flow has. Done, freshly verified work no longer needs its log to say what the repo now says better: per-criterion evidence goes (the tests just re-ran under your eyes), full bodies of superseded contract versions go (each keeps its one-line why), the interview's play-by-play goes (the confirmed problem lives in the snapshot), and the reviewer's report shrinks to its one-line stub. What stays is everything code cannot answer: decisions and their kill-reasons, corrections with what overturned them, the user's words as they said them, why the contract moved when it moved. One rule — *does the repo answer this now?* — applied once, at this moment only, and announced: the log's first line becomes `distilled at close-out, <date>`. Links that pointed at what left leave with it — a slice line keeps its check and its words, never a dead anchor. ⚠ **What something still points at does not leave**, whatever its category: check `.genius/BACKLOG.log.md` first, because it is append-only and its pointers can never be repaired, then `.genius/DECIDED.md`, `.genius/BACKLOG.md`, and the work's own `CONTRACT.md`, whose established layer links the source entry of every block a slice established. Never silent, never on in-flight work, never a second pass on a log already distilled — work that closed without it catches up through `/distill`.

Then one honest post-mortem line: which genius was weakest this run — checked against `.genius/HISTORY.md` (one line per finished work; a bounded read), because a repeat weakness names its adjustment, not just the diagnosis. Append it there — `- **<slug>** (<date>) — <the post-mortem line>. [<slug>](<slug>/<slug>.md)`, relative to `.genius/`. A lesson that keeps recurring may earn a line in the project's `## Working Genius` section, sparingly.

Done when the evidence is fresh — the reviewer's report in the log among it: a close-out whose review never ran is not done, however green everything else looks — and the findings are resolved. Say it with the evidence, not instead of it.
