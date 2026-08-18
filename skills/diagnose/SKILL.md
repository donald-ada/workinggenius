---
name: diagnose
description: Debugging as the six geniuses at minute scale — the bug confirmed by a red reproduction before any theory, hypotheses plural with kill-reasons before any fix, the fix proven by a fresh green rerun. Use when something is broken, throwing, failing, flaky, or slow, or when the user asks to debug or diagnose.
---

# Diagnose

A bug is a piece of work whose problem statement nobody confirmed — and debugging fails the way all work fails: at whichever stage got skipped. Read code until a cause feels plausible, fix that, call it done when nothing visibly objects — that is idea straight to implementation with everything between skipped, at minute scale.

The concept: **the six geniuses, run at minute scale — no ceremony, no work file, the same order.**

- **Wonder — the code confirms the problem.** A bug's confirmation line is a red reproduction: one command, run here, that shows the symptom the user reported — red while the bug lives, green when it dies. That command is the code saying "yes, that's it," and until it exists nothing is confirmed and no theory has standing; catching yourself building one first is the stop. A flaky symptom is confirmed by rate — raise the reproduction until signal beats noise. Then shrink the statement: cut inputs, config, and callers one at a time, re-running after each cut, until everything left is load-bearing. The wrong bug reproduced is the wrong problem confirmed.
- **Invention and Discernment — hypotheses are options, and options earn survival.** More than one before testing any: a single hypothesis explored is anchoring with extra steps. Each names its prediction — "if this is the cause, that change turns the reproduction green" — because a hypothesis that predicts nothing can only be believed, never attacked. Attack in rank order, one variable at a time; a dead hypothesis gets its one-line kill-reason, so nobody — including you, an hour from now — walks that path twice.
- **Enablement and Tenacity — red to green, and green is fresh.** The surviving hypothesis becomes a fix proven by the reproduction it was born from, and a regression test at a real seam where one exists — where none does, that absence is a finding about the design, recorded, never a license to skip. Close out clean: the rerun fresh, the debug scaffolding gone, the cause stated where the fix is recorded — a fix whose cause is unstated gets un-fixed by the next confident refactor. And what the hunt disproved on the way is corrected where it was written (`errata` skill) — the stated fact the reproduction contradicted, the pinned value that measured differently here; left standing, it is what sends the next session down the path this one just cleared.

Three failed fixes are not a third of the way to nine: they impeach the problem statement. Back to Wonder — question the reproduction, and what it silently assumes.
