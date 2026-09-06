---
name: enable
description: Build one slice at a time with red-before-green tests at the agreed seams, tight feedback loops, and fresh-eyes review at every slice close. Use when a tracked piece of work is at its enablement stage and a slice needs building — or when small work that never cut slices needs building against its confirmed problem.
argument-hint: "a work slug to coordinate all slices, or 'slug, slice N' to build one"
allowed-tools: Bash(python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py *)
hooks:
  Stop:
    - hooks:
        - type: command
          command: python3 "${CLAUDE_PLUGIN_ROOT}/skills/genius-file/stop-judge.py"
          timeout: 90
  SubagentStop:
    - matcher: builder
      hooks:
        - type: command
          command: python3 "${CLAUDE_PLUGIN_ROOT}/skills/genius-file/stop-judge.py"
          timeout: 90
---

# Enablement

The genius of doing the work the work needs. Its failure mode is flying blind: code produced without feedback until a big-bang reveal at the end.

The concept: **build one slice at a time, in a fresh context, with reality voting every few minutes.** Tests lead the code — the failing test at the agreed seam, watched failing before the implementation exists; this is the one discipline a capable model still talks itself out of, so hold it even when momentum says skip it. Test behavior through public seams, not implementation. A criterion that can't be red-green is verified against the real thing and what you observed recorded; the rule is feedback, not ceremony.

## How it runs

1. Decide your role from the invocation (below): builder, coordinator, fresh session per slice, or small work with no cut.
2. Read the slice list and the `CONTRACT.md` it points at; run the verify commands once and record a dirty baseline.
3. Mark the slice in progress at the first red test; red → green at the agreed seams; each criterion's evidence written as it runs.
4. A discovery that changes the shape stops the slice: to the user in one exchange, or back to the coordinator where you are its builder.
5. Fresh-eyes review by the `reviewer` agent; close in one commit; drain Open; then dispatch, or name, what the close unblocked.

## Who builds

- **A slice named** (`slug, slice N`) → you are the **builder**. Build that one slice, in this context, by the loop below, and close it yourself — and only that one: every file this context reads stays in it to the end of the work, which is the cost the coordinator form exists to keep out of the session that judges, so the next slice gets a fresh session, not this one's next turn.
- **Only the work named, more than one slice open** → you are the **coordinator**. One fresh `builder` agent per slice ([agents/builder.md](agents/builder.md)). Its task message carries the snapshot's path **and the `CONTRACT.md` beside it**, the slice's number and name, the pinned verify commands, where to build, and whether it closes the slice itself; never a pasted summary, which anchors the builder on your reading and rots as slices land. Dispatch in the order the slice list states — a slice runs only when everything it waits on has closed (the format's `after:` rule); slices that wait on nothing still open and touch disjoint parts of the tree may run in parallel in their own worktrees, and when in doubt, sequential. You write no product code: coordinating and building do not share a context. When a builder returns, **re-run the slice's verification yourself** — every criterion, the seam tests on every edge into the slice, in the tree the slice lands in — and close the slice before dispatching what it unblocked, because a builder's word is not evidence. **The coordinator runs; the reviewer reads**: a diff or a source file you open to judge a slice is paid for again on every turn until the work is done, and reading the diff is the context the reviewer is spawned to spend. **Coordinating means staying awake**: never end your turn while a builder you must verify is running — "I'll wait for it to return" followed by ending the turn *is* the stall; where you cannot be certain the harness wakes you, dispatch synchronously. Dispatching is doing: "next I'll dispatch slice N" ends with slice N dispatched.
- **No subagents, or the user wants to drive each slice** → fresh session per slice: tell the user to open one and type `/enable <slug>, slice N`.
- **No Slices section at all** — small work built straight after Wonder → build it here, against the Problem section's success criteria, by the same loop, and close it the way one slice closes, under a log entry keyed `build`. Skipping Galvanizing skipped the cut, never the discipline; `/tenacity` then verifies fresh against those criteria.

## The loop

Read the snapshot's slice list and the `CONTRACT.md` it points at — what the earlier slices established binds this one, and your memory of that file is not that file. Verify commands are the ones the project's `## Working Genius` section pins; discover them once from the task runner where it pins none. **A dirty baseline** — failures that predate this work — is recorded in the slice's log entry and held at **no new failures**: don't adopt the dirt, and don't fix unrelated code on the way past; that discovery takes its one line in `.genius/BACKLOG.md`.

**Mark the slice in progress at the first red test**: the slice line's box becomes `[~]` and links a log entry keyed `slice-N-wip` — red, green, still owed — appended to as the loop moves, because a session dies whenever it dies and a snapshot reading `[ ]` over half-built code sends the next session to rebuild what exists or build on it blind. A coordinator dispatching a builder into a worktree writes the mark itself at dispatch.

Then red → green, at the agreed seams, until the criteria are covered: the failing test first, watched failing; the minimal code that passes; typecheck (and lint, where fast) after each green. Write each criterion's evidence while the output is on screen — under the slice's own anchor, one line per criterion, the command and its result (`record-prose` skill).

## When the build changes the requirements

**The plan re-enters the flow at minute scale: pause, confirm, re-version, resume.** A discovery that moves the work's shape — criteria, scope, slices, seams — is the normal case, not an erratum: the contract was right for the world it was written in. Never silently improvise around it. Pause the slice and put the change to the user in one exchange — what was discovered, what it changes, which slices it touches, your recommendation — **and a recommendation that re-cuts is written as the cut it proposes**: the slice lines in the roster's shape, each with its `after:`, its criteria, the seam test between the parts, because a re-cut confirmed as a sentence still gets cut afterwards out of the user's sight. Where they genuinely can't be reached, an `assumed:` line, flagged for next contact. Then bump the contract (`genius-file` skill): the new version whole in `CONTRACT.md`, the old whole to the log with what overturned it, one changelog line in the snapshot; re-cut only where the change reaches, the reshape a log entry and its issue closed with the reason; then resume against the version that now binds. Ten churns cost ten log entries and a snapshot the same size it started, which is the point: a plan that gets more expensive to change gets defended instead of corrected.

**A builder subagent cannot reach the user, so for it the pause is a return.** It hands back what it found, what it changes and its recommendation as a re-cut in the roster's shape, and the coordinator checks that against the contract and puts it to the user. `assumed:` is the coordinator's line to write, only for a user who is actually unreachable: an assumption improvised inside a context that could have asked through one that can is the silent workaround wearing a record's clothes.

## Closing a slice

**Closing a slice is one commit with four effects** (`genius-file` skill): the code, the slice's log entry, the compacted snapshot, and the close of its issue if it carries one — **five where the slice left something binding**, since `CONTRACT.md` is its own file and a constraint that misses this commit is one the next slice builds without. (Where `.genius/` is gitignored, the files are written at that same moment all the same.)

**A criterion whose instrument is the user's eyes, and whose eyes have not looked, closes as an `owed:` line in Open** — `owed: S2 <criterion> → the user's eyes` — with the slice's log entry saying so; the slice closes on the evidence it has, and the line waits until they look. Checked in the builder's head instead, the roster's `[x]` is earlier than the fact.

**One close at a time, by whoever holds the snapshot.** Two builders closing in parallel rewrite the same snapshot and `CONTRACT.md` in two commits, and the second lands on a file the first already changed. So a parallel builder returns its branch, its per-criterion evidence and what it established, and the coordinator closes each returned slice in turn.

The evidence goes in the log, not the commit message (`genius-file` skill says why). The entry is appended and linked without opening the log — `python3 ${CLAUDE_SKILL_DIR}/../genius-file/measure.py anchors <slug>` lists the keys that exist and what links them — and the close is composed first and written once per file. Compact the snapshot in the same commit: the format's question to each line, each answer routed. ⚠ **A convention this slice introduced lands in `CONTRACT.md` even where it never became a snapshot line**: something settled at the keyboard binds the slices not yet built all the same, and the next builder opens that file, not this slice's log. **Open is drained here rather than left for close-out**: a line the slice consumed leaves with what consumed it; one that turned out to be work in its own right leaves as a seed in `.genius/BACKLOG.md`. What the build merely disproved — a stated fact, a value that measured differently — is the `errata` skill's line-level correction.

**A slice earns its close under fresh eyes, not just green tests.** Before the closing commit, hand the slice's diff to the plugin's `reviewer` agent ([agents/reviewer.md](../tenacity/agents/reviewer.md)), its task message naming the diff, the criteria and the contract it is judged against, and where the record lives — don't tell it what not to flag, and treat its findings as claims to verify. Fix what's real before the commit; what's real but not this slice's job goes to `.genius/BACKLOG.md` or an Open line. The slice's log entry notes the outcome in one line — `reviewed → 2 findings fixed, 1 to backlog` — so close-out can trust the slice was reviewed without re-reading its diff, and Tenacity's reviewer is free for what slice-sized eyes cannot see: the seams between slices.

Then `/tenacity`. Done when every slice is built and every criterion checked against output that actually ran — its log entry naming, per criterion, what ran and what it showed. A criterion checked in your head has not been checked.
