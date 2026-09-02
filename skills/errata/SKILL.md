---
name: errata
description: "Correct what was written wrong — the binding line rewritten in place, the record it came from appended to and never touched, both carrying the evidence that overturned it. Use when a run, a file, or the user contradicts something already written in a work file, a plan's contract, the glossary, or the decision index; when a pinned value or a stated fact turns out not to hold; or when another skill needs the correction discipline."
---

# Errata

Every stage writes at the moment of action — the interview as it ran, the criterion while the output is still on screen. That is the only way a record is ever honest, and it is also why some of what gets written is wrong. A fact gets reported that its instrument could not actually see. A number gets pinned on a machine that later changes. An option gets killed for a reason that does not hold. None of that is the discipline failing; it is what writing at the moment of action costs.

What it cannot be allowed to do is compound. A wrong line in a work file is read by every session after it, believed because the file outranks memory, and built on — and by the third session nobody can tell it apart from the lines that were right.

The concept: **the layer that binds gets corrected; the layer that records gets appended to.**

## The test

One question sorts any line into its layer: **would a cold session act differently because of this line?**

- **Yes — it binds.** The snapshot — its slice list, its Open section — the work's `CONTRACT.md` with the seams and pinned values, `.genius/DECIDED.md`, `CONTEXT.md`, `DESIGN.md`, `ARCHITECTURE.md`, `.genius/BACKLOG.md`'s seeds, the `## Working Genius` section wherever the project keeps it. A wrong line here is an instruction, and it gets rewritten in place.
- **No — it records.** Everything in the log (`<slug>.log.md`, `.genius/BACKLOG.log.md`), and every file at `stage: done`. It is what was written then, which is its whole worth. Append the correction; never edit the line. ⚠ **This layer is a rule about correcting, not a freeze on routing.** A done snapshot still gets compacted — `/compact` may move one of its lines to the file that line belongs in, because nothing there is wrong, it is only misfiled, and the format's compaction license is not one of the three moves below. What stays forbidden at done is the thing this test is for: rewriting a line because it turned out to be false.

The two are not alternatives. A fact that was wrong is usually in both, and both get handled — the binding copy rewritten, the record it came from annotated.

## The three moves

**Correct — it was wrong when it was written.** Rewrite the binding copy. Append to the record: what was written, what is true, what overturned it, and what made it wrong.

```markdown
> **Corrected 2026-08-17** — "no headless browser in this project" was wrong:
> Chromium is installed at `/opt/pw-browsers/chromium`, off `PATH`. Slice 3's
> `npx playwright --version` found it. The check was `which chromium`, which
> reads `PATH` and nothing else.
```

**Supersede — it was right, and the world moved.** The binding copy takes the new value. The record keeps the old one and gains a pointer to what replaced it.

```markdown
> **Superseded 2026-08-17** — the 200ms budget held until the batch endpoint
> existed; slice 5 measured 340ms and the contract now pins 400ms. This number
> is what was true before that endpoint.
```

Supersede is for a single fact or value. When what moved is the work's *shape* — criteria, scope, slices, seams — that is a requirement change, and it goes through a contract version bump (`genius-file` skill): the new version replaces the old whole, the old version's log entry is where this move's annotation then lands. Correcting a reshaped plan line by line builds exactly the scar tissue versioning exists to prevent.

**Retire — it is neither wrong nor stale; it has no reader left.** An acceptance criterion whose slice was reshaped away, a convention for a seam that no longer exists. Remove it from the binding copy, and say in the record why it left.

```markdown
> **Retired 2026-08-17** — criterion 3 went with the slice it belonged to when
> slice 4 was reshaped (slice 4's entry has the reshape). Nothing replaced it.
```

## The discipline

- **Only evidence overturns what is written.** A command's output read in this session, a file read at a named place, a sentence the user said. A re-read that merely feels wrong is a second unexamined judgement, and writing it down turns one bad call into two — the second one wearing a correction's clothes and outranking the first. Where the suspicion is real and the evidence is not in yet, go get it: run the command, open the file. Where it can't be got, write a question, not a correction.
- **The correction lands where the reader already looks.** The next slice reads the plan's contract; a fresh session judging a design reads the index line. An erratum that exists only in the record is an erratum nobody reads, and the wrong line goes on being obeyed.
- **Every correction carries its source.** Which run, which slice, which file, which words from the user. A correction that can't be traced is not a correction, it is a new claim — and it will be the next thing someone has to overturn.
- **A corrected fact carries the scope it should have had.** Most wrong facts are not wrong about the world: they are true of an instrument and were written as true of the project. Restate them with the instrument inside — `nothing named chromium on PATH`, not `no headless browser` — or the same wrong line comes back next month from the same blind check. That is also what makes a correction worth a post-mortem line: the failure is rarely the fact, it is the instrument nobody named.
- **Inline, at the moment the contradiction lands.** Not swept up later — later is a chore someone has to remember, and this one never gets remembered. A slice's corrections ride the commit that closes it, alongside the record it already writes.
- **A decision is not corrected here.** A settled decision that now looks wrong goes back to `/discern` with the drift as ammunition; overturning it is a fight, and this skill has no standing to win one. What moves here is what a finished fight settled — the index line following its new record, under the `decision-record` skill's rule.

## What this skill is not

Not a cleanup pass on the log. Nothing there is compressed, summarised or tidied, because the losses are silent and permanent: a kill-reason shortened to a verdict has been destroyed, not maintained, and the file will look better for it. The snapshot is different ground — its compaction at slice and stage closes is the `genius-file` skill's own discipline, lossless under its invariant: displacement into an anchored log entry is not deletion.

Not a second home for corrections. No `ERRATA.md`, no corrections section, nothing a reader has to know to go and check — every correction lives in the two places the wrong line already lived.

Not a deletion tool. A line removed without its retirement note leaves a hole that reads exactly like a stage that never ran, and in this flow absence is a record with a meaning of its own. Nothing is removed silently, including something you wrote yourself an hour ago. Tenacity's close-out distillation of a done work's log — and `/distill`, its retroactive form — is the one carve-out: a single announced move under its own rule, on work that is finished and verified, and it licenses nothing here: while work is in flight, nothing is removed, ever.
