---
name: tenacity
description: Drive the work to actually-done — fresh verification of every claim, two-axis diff review, cleanup, commit, post-mortem.
disable-model-invocation: true
---

# Tenacity

The genius of finishing. Its failure mode is the false "done": satisfaction declared on stale evidence, or on no evidence at all. Tenacity's one law: **no completion claim without fresh evidence** — if the command didn't run in this session, its result doesn't exist.

Run the `genius-file` skill: read the work file. Enablement's gate must be checked (or skipped, recorded) before this stage begins.

## Process

### 1. Re-read the contract

Read the **entire** work file top to bottom — the problem, the scope edges, the chosen design, every slice's acceptance criteria. The file is the contract; your memory of it is not.

### 2. Verify line by line

For every acceptance criterion in every slice:

1. Name the command that proves it.
2. Run it, fresh, in full.
3. Read the output — exit code, failure count, the actual numbers.
4. Only then check it off, noting the evidence.

Then the project-wide sweep, each run fresh, each output read: **full test suite**, **typecheck**, **lint/format** — using the commands pinned in the `## Working Genius` section of `CLAUDE.md`/`AGENTS.md` if present, else whatever the project has. "It passed earlier" is not a pass. "Should pass" is not a pass.

### 3. Review the diff on two axes

Review the full diff of the work — from the `base:` commit recorded in the work file's frontmatter to the current tree (fall back to asking the user for the baseline if `base:` is missing). Spawn a subagent per axis for anything sizable, so neither review pollutes the other:

- **Spec** — does the diff faithfully implement the brief? Anything asked-for missing? Anything present that nobody asked for (scope creep — check it against Wonder's no-list)?
- **Standards** — does the diff follow this repo's conventions and documented standards? Skip anything tooling already enforces.

Report the two axes separately; fix what's real; re-run step 2's sweep after any fix.

### 4. Clean up

- Debug logs, tracing prints, commented-out experiments — grep and remove.
- Prototypes and scratch files — deleted or absorbed.
- The work file — every gate section reflects reality.

### 5. Commit and close

- Commit anything not yet committed, with a message that states the problem and the chosen approach (the Discernment one-liner is usually the perfect body). Slices were committed as they closed; if the history would read better squashed or reworded, offer it — don't just do it.
- Set `stage: done` in the work file.
- Write the post-mortem line: **which genius was weakest this run?** (Wonder that missed a requirement? Discernment that let a wounded option through? Enablement that drifted from the seams?) One honest sentence — it's the input that improves the next run.

## Gate — Tenacity

- [ ] Full test suite run fresh; output read; zero failures
- [ ] Typecheck/lint run fresh; clean
- [ ] Every acceptance criterion re-verified line by line, with evidence
- [ ] Diff reviewed on both axes; findings resolved
- [ ] Debug artifacts removed; prototypes deleted or absorbed
- [ ] Committed; work file marked done, post-mortem written

Only when every box is checked may you tell the user the work is done — and say it with the evidence, not instead of it.
