---
name: genius-file
description: Read and update Working Genius work files. Use when a stage skill needs the work-file discipline, when the user asks what work is in flight or where a piece of work left off, or before resuming any work tracked under .genius/.
---

# The Work File

One piece of work = one markdown file under `.genius/` (a `## Working Genius` section in `CLAUDE.md`/`AGENTS.md` may pin a different directory). A loose sketch of the shape lives in [FILE-FORMAT.md](FILE-FORMAT.md).

The concept: **the file, not conversation memory, carries the work** — the confirmed problem, the options and their kill-reasons, the slices, the evidence, the post-mortem. Any fresh session picks up exactly where the last one stopped.

What that takes:

- **Read before acting; write the moment a decision lands.** The file outranks whatever you remember about the work. `stage:` names where the work currently is.
- **Write it for someone who wasn't there.** Every stage's close-out re-reads this file whole, and the reader is usually a session with no memory of the conversation that produced it — so short sentences carrying one fact each, the actor named rather than implied, one term per concept held constant, and paragraphs that fit on a screen. Two things the form never touches. **Reasoning stays where it is load-bearing**: a kill-reason still names the attack that broke the option, a repeat weakness still names its adjustment, a technology still names what selected it — written plainly, never compressed to a verdict. And **quoted words are a record, not prose to conform** — the user's confirmation goes in as they said it, however loose; the form binds your sentences, never theirs. The discipline borrows the form of [Simplified Technical English](https://asd-ste100.org/) (ASD-STE100), which controls vocabulary, sentence length and one-instruction-per-sentence for readers executing procedures; its restrictions are written for documents that carry no reasoning, and this file carries reasoning on purpose.
- **Absence is the record.** Every stage is a command the user types; one they didn't type simply has no section — the file shows what ran and what didn't, and when work goes wrong later, the missing section is the first suspect. No skip bookkeeping: not typing a stage *is* the decision.
- **Assumptions are visible.** A decision made without the user is an `assumed: <question> → <answer>` line, surfaced at next contact — an honest assumption beats a hollow confirmation.
- **A checked fact carries its scope.** A later session inherits it as a constraint and designs around it, so write what you checked and where — `no headless browser installed in this project`, not `no headless browser`. An over-broad fact costs more than a missing one: the missing one gets looked up, the over-broad one becomes a seam nobody questions.
- **Checkpoints are live.** Each checkpoint is a real exchange with the user, the Wonder interview above all — a model answering its own interview confirms nothing, and a model approving its own plan finds nothing.
- **A checkpoint the user can't parse is a worse checkpoint.** Where you are asking for a decision, lead with it and keep the sentences short, so someone who has already made up their mind can skip the rest. Know what the ask actually is before demoting anything below it: at Wonder the story you offer for correction *is* the ask, and at Discernment the consequences played back *are* the ask — neither is background a reader may skip. A dense report buys agreement rather than judgement, which is the thing checkpoints exist to collect.

Done files stay in place — they're decision history, and their post-mortem lines calibrate the next run. Abandoning honestly (`stage: done`, post-mortem `abandoned — <reason>`) beats a zombie file.
