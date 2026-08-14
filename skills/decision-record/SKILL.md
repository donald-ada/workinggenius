---
name: decision-record
description: Keep the project's settled decisions as numbered records in docs/adr/ — record one only when it clears the bar, load them before judging a design that touches settled ground, supersede rather than rewrite. Use when a decision worth keeping beyond its work lands, when a design might contradict a recorded decision, or when another skill needs the decision-record discipline.
---

# Decision Records

Work files are per-work memory; the glossary is project memory for language. This is project memory for **decisions**: the choices that outlive the work that made them, living in `docs/adr/` as numbered records — `0001-short-slug.md`, the next number found by scanning for the highest, the directory created lazily by the first decision that qualifies. A kill-reason in a done work file guards one piece of work against re-litigation; a decision record guards all future work — it is the ammunition `/discern` and `/architect` load before they judge, and the reason a killed idea stays killed instead of returning as a fresh proposal in six weeks. (The bar and the form follow [mattpocock/skills](https://github.com/mattpocock/skills)' ADR discipline.)

## The bar

Record a decision only when all three hold:

1. **Hard to reverse** — changing it later costs something real.
2. **Surprising without context** — a future reader would ask "why on earth?".
3. **A real trade-off** — genuine alternatives existed and one won for reasons.

Miss any one and the record is noise: an easily-reversed decision just gets reversed, an unsurprising one nobody looks up, a no-alternative one records "we did the obvious thing". Most decisions miss one, and stay in their work file — that is the discipline working. What tends to qualify: architectural shape, integration patterns, technology choices that carry lock-in, boundary no-s, deliberate deviations from the obvious path, constraints invisible in the code, and rejections that will otherwise be re-proposed.

## The format

One to three sentences — context, decision, why:

```markdown
# Orders are event-sourced

We rebuild order state from events instead of storing it, because refund
disputes need the full history and write volume is low. Rejected: mutable rows
with an audit table — the trail drifted from the truth in v1.
```

The value is that the decision and its why are on record, never that sections got filled. A record is **superseded, never rewritten** — a revisited decision adds `superseded by 0007` to the old record and writes a new one carrying the reason, because what the project used to believe is itself part of the record.

## The discipline

- **Write at the moment of decision** — Discernment committing a path, Architect confirming a design, a build discovering a constraint the hard way. A record assembled later records the memory of the decision, not the decision.
- **Read before contradicting.** A design that touches settled ground either dies of the record or names the decision it overturns and why — and then the supersession is written, not implied.
- **A rejection can be a decision.** A "we won't do X, because" that clears the bar gets a record — that is what stops X from being proposed again by someone who wasn't there, including a future session of you.

## What this skill is not

Not the work file: decisions scoped to one piece of work — its slices, its seams, its `assumed:` lines — live and die with it, and its kill-reasons stay with its battlefield. And not a diary: a decision that misses the bar is simply not recorded.
