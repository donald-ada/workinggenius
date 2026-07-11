---
name: tenacity
description: Drive the work to actually-done — fresh verification of every claim, two-axis diff review, cleanup, commit, post-mortem. Use when a tracked piece of work has all slices built and is at its tenacity stage.
---

# Tenacity

The genius of finishing. Its failure mode is the false "done": satisfaction declared on stale evidence, or on no evidence at all. Tenacity's one law: **"done" is a claim about evidence, and evidence expires with the session** — if the command didn't run here, its result doesn't exist.

Run the `genius-file` skill: read the work file. Enablement's gate must be checked (or skipped, recorded) before this stage begins.

## Process

### 1. Re-read the contract

Read the **entire** work file top to bottom — the problem, the scope edges, the chosen design, every slice's acceptance criteria. The file is the contract; your memory of it is not.

Collect every `assumed:` line while reading: each is a decision nobody reviewed. Walk them with the user if present; otherwise attack each one yourself against the brief and the success criteria, exactly as Discernment would. An assumption that contradicts the brief is a defect, however green the tests.

### 2. Verify line by line

For every acceptance criterion in every slice:

1. Name the command that proves it.
2. Run it, fresh, in full.
3. Read the output — exit code, failure count, the actual numbers.
4. Only then check it off, noting the evidence.

Then the project-wide sweep, each run fresh, each output read: **full test suite**, **typecheck**, **lint/format** — using the commands pinned in the `## Working Genius` section of `CLAUDE.md`/`AGENTS.md` if present, else whatever the project has. "It passed earlier" is not a pass. "Should pass" is not a pass.

### 3. Review the diff on two axes

Review the full diff of the work — from the `base:` commit recorded in the work file's frontmatter to the current tree (fall back to asking the user for the baseline if `base:` is missing). For anything sizable, spawn **one fresh reviewer subagent**, isolated from this session's history so it judges the work, not your reasoning about the work. A mid-tier model reads a diff as well as a frontier one — reserve the expensive model for building, not reviewing. Hand it the diff and the work file *as files*, never pasted summaries, and scope it to them: the reviewer judges the diff against the brief, it does not re-drive the app or re-explore the repo — an unscoped reviewer was the most expensive single step in measured runs, at no gain over a scoped one. Spawn it so its result reaches you — synchronously (foreground) unless you are certain the harness re-wakes you when it finishes; ending your turn to "await the reviewer" in a context that won't be woken is a stall, not a wait. Ask for both verdicts:

- **Spec** — does the diff faithfully implement the brief? Anything asked-for missing? Anything present that nobody asked for (scope creep — check it against Wonder's no-list)?
- **Standards** — does the diff follow this repo's conventions and documented standards? Skip anything tooling already enforces.

Don't tell the reviewer what not to flag. When findings come back: verify before implementing, push back with reasons where a finding is wrong — findings are claims to evaluate, not orders. Fix what's real; re-run step 2's sweep after any fix.

### 4. Clean up

- Debug logs, tracing prints, commented-out experiments — grep and remove.
- Prototypes and scratch files — deleted or absorbed.
- The work file — every gate section reflects reality.

### 5. Commit and close

- Before the user accepts, offer the `blindspot` skill's quiz — a behavior-level summary of what changed, then a few consequence questions. In delegated or auto mode this is the returning user's catch-up: they watched none of the build; don't let them accept a map they don't hold.
- Commit anything not yet committed, with a message that states the problem and the chosen approach (the Discernment one-liner is usually the perfect body). Slices were committed as they closed; if the history would read better squashed or reworded, offer it — don't just do it.
- Set `stage: done` in the work file.
- Write the post-mortem line: **which genius was weakest this run?** (Wonder that missed a requirement? Discernment that let a wounded option through? Enablement that drifted from the seams?) One honest sentence — but written against the record, not in a vacuum: first grep `**Post-mortem:**` across the done files in the work dir (the lines, not the files). Only lines that name a genius vote in the tally — template placeholders and `abandoned — <reason>` lines don't count toward "weakest". If this run's weakest genius has been weakest before, say so to the user and put the **adjustment** in the line, not just the diagnosis: "Wonder weakest again; next interview walks scope edges before offering express" teaches the next run something.

### 6. Promote a lesson — sparingly

Post-mortems live in their work files; `/genius` reads them as a set. Promote a lesson up into a `Lessons:` list in the `## Working Genius` section of `CLAUDE.md`/`AGENTS.md` — where every future session sees it without asking — only when all three hold:

1. **It recurred** — the same weakness or surprise across two or more pieces of work
2. **It changes behavior** — a future run acting on it would concretely act differently
3. **It has no better home** — not a term (glossary), not a decision (ADR or work file), not a command (verify commands)

Any of the three missing → the post-mortem line already carries it; don't promote. One line per lesson, created lazily (no empty `Lessons:` list, and no section at all if setup never ran — offer `/setup-working-genius` instead). When adding one, reread the ones already there: a lesson that stopped changing behavior gets pruned — the list only compounds if every future session actually reads all of it.

## Gate — Tenacity

- [ ] Full test suite run fresh; output read; zero failures
- [ ] Typecheck/lint run fresh; clean
- [ ] Every acceptance criterion re-verified line by line, with evidence
- [ ] Diff reviewed on both axes; findings resolved
- [ ] Debug artifacts removed; prototypes deleted or absorbed
- [ ] Committed; work file marked done, post-mortem written against the prior post-mortems (recurring lesson promoted, or not warranted)

Only when every box is checked may you tell the user the work is done — and say it with the evidence, not instead of it.

If you catch yourself writing "should pass", "probably fine", "seems to work", or "passed earlier" — that's the tell. Each of those words means a command you haven't run in this session. Run it.
