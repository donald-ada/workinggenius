---
name: errata
description: "Correct what was written wrong — the binding line rewritten in place, the record it came from appended to and never touched, both carrying the evidence that overturned it. Use when a run, a file, or the user contradicts something already written in a work file, a plan's contract, the glossary, or the decision index; when a pinned value or a stated fact turns out not to hold; or when another skill needs the correction discipline."
---

# Errata

Every stage writes at the moment of action, which is the only way a record is honest and also why some of what gets written is wrong: a fact its instrument could not see, a number pinned on a machine that later changes. What it cannot be allowed to do is compound: a wrong line in a work file is read by every session after it, believed because the file outranks memory, and built on.

The concept: **the layer that binds gets corrected; the layer that records gets appended to.**

## The test

One question sorts any line into its layer: **would a cold session act differently because of this line?**

- **Yes — it binds.** The snapshot, the work's `CONTRACT.md`, `.genius/DECIDED.md`, `CONTEXT.md`, `DESIGN.md`, `ARCHITECTURE.md`, `.genius/BACKLOG.md`'s seeds, the `## Working Genius` section. A wrong line here is an instruction, and it gets rewritten in place.
- **No — it records.** Everything in the log (`<slug>.log.md`, `.genius/BACKLOG.log.md`), and every file at `stage: done`. Append the correction; never edit the line. ⚠ A rule about correcting, not a freeze on routing: a done snapshot still gets compacted by `/compact`, because nothing there is wrong, only misfiled. What stays forbidden at done is rewriting a line because it turned out to be false.

A fact that was wrong is usually in both, and both get handled — the binding copy rewritten, the record it came from annotated.

## The three moves

**Correct — it was wrong when it was written.** Rewrite the binding copy. Append to the record: what was written, what is true, what overturned it, and what made it wrong.

```markdown
> **Corrected 2026-08-17** — "no headless browser in this project" was wrong:
> Chromium is installed at `/opt/pw-browsers/chromium`, off `PATH`. Slice 3's
> `npx playwright --version` found it. The check was `which chromium`, which
> reads `PATH` and nothing else.
```

**Supersede — it was right, and the world moved.** The binding copy takes the new value; the record keeps the old one and gains a pointer to what replaced it.

```markdown
> **Superseded 2026-08-17** — the 200ms budget held until the batch endpoint
> existed; slice 5 measured 340ms and the contract now pins 400ms.
```

Supersede is for a single fact or value. When the work's *shape* moved — criteria, scope, slices, seams — that is a contract version bump (`genius-file` skill): the new version replaces the old whole, and the annotation lands in the old version's log entry. Correcting a reshaped plan line by line builds the scar tissue versioning exists to prevent.

**Retire — it is neither wrong nor stale; it has no reader left.** A criterion whose slice was reshaped away, a convention for a seam that no longer exists. Remove it from the binding copy, and say in the record why it left.

```markdown
> **Retired 2026-08-17** — criterion 3 went with the slice it belonged to when
> slice 4 was reshaped (slice 4's entry has the reshape). Nothing replaced it.
```

## The discipline

- **Only evidence overturns what is written.** A command's output read in this session, a file read at a named place, a sentence the user said. A re-read that merely feels wrong is a second unexamined judgement wearing a correction's clothes and outranking the first. Where the evidence is not in yet, go get it; where it can't be got, write a question, not a correction.
- **The correction lands where the reader already looks.** An erratum that exists only in the record is one nobody reads, and the wrong line goes on being obeyed.
- **Every correction carries its source** — which run, which slice, which file, which words from the user. A correction that can't be traced is a new claim.
- **A corrected fact carries the scope it should have had.** Most wrong facts are true of an instrument and were written as true of the project: restate them with the instrument inside — `nothing named chromium on PATH`, not `no headless browser` — or the same wrong line comes back from the same blind check.
- **Inline, at the moment the contradiction lands.** Later is a chore someone has to remember, and this one never gets remembered. A slice's corrections ride the commit that closes it.
- **A decision is not corrected here.** A settled decision that now looks wrong goes back to `/discern` with the drift as ammunition; overturning it is a fight. What moves here is what a finished fight settled — the index line following its new record (`decision-record` skill).

## What this skill is not

Not a cleanup pass on the log: nothing there is compressed or tidied, because a kill-reason shortened to a verdict has been destroyed. The snapshot's compaction at closes is the `genius-file` skill's own discipline, lossless under its invariant.

Not a second home for corrections: no `ERRATA.md`, nothing a reader has to know to go and check — every correction lives in the two places the wrong line already lived.

Not a deletion tool. A line removed without its retirement note leaves a hole that reads exactly like a stage that never ran. Nothing is removed silently, including something you wrote an hour ago. Tenacity's close-out distillation — and `/distill`, its retroactive form — is the one carve-out: a single announced move on work that is finished and verified; while work is in flight, nothing is removed, ever.
