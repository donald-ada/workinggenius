---
name: genius-file
description: Read and update Working Genius work files. Use when a stage skill needs the work-file discipline, when the user asks what work is in flight or where a piece of work left off, or before resuming any work tracked under .genius/.
---

# The Work File

One piece of work = one markdown file under `.genius/` (a `## Working Genius` section in `CLAUDE.md`/`AGENTS.md` may pin a different directory). A loose sketch of the shape lives in [FILE-FORMAT.md](FILE-FORMAT.md).

The concept: **the file, not conversation memory, carries the work** — the confirmed problem, the options and their kill-reasons, the slices, the evidence, the post-mortem. Any fresh session picks up exactly where the last one stopped.

What that takes:

- **Read before acting; write the moment a decision lands.** The file outranks whatever you remember about the work. `stage:` names where the work currently is.
- **Skips are explicit.** Any stage may be skipped, never silently: `> ⚠ Skipped — <reason>` in its section. When work goes wrong later, recorded skips are the first suspects.
- **Assumptions are visible.** A decision made without the user is an `assumed: <question> → <answer>` line, surfaced at next contact — an honest assumption beats a hollow confirmation.
- **Checkpoints are live.** The flow has no hands-off mode: each checkpoint is a real exchange with the user, and the Wonder interview above all — a model answering its own interview confirms nothing, and a model approving its own plan finds nothing.

Done files stay in place — they're decision history, and their post-mortem lines calibrate the next run. Abandoning honestly (`stage: done`, post-mortem `abandoned — <reason>`) beats a zombie file.
