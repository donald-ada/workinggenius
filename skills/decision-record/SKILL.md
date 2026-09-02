---
name: decision-record
description: "Keep the index of the project's settled decisions in .genius/DECIDED.md — one line per decision, pointing at the fight that settled it, earned by one test: would a future stranger re-fight this? Use when such a decision lands, when a design might contradict a settled one, or when another skill needs the index discipline."
---

# The Decision Index

A decision is never written twice. The flow already writes every decision at full strength — the kill-reasons, the survivor's fight, the user's confirmation — into the work file where it was made. What those records lack is a door: a fresh session judging a new design cannot trawl every done file for the one decision it is about to contradict. The door is `.genius/DECIDED.md`, beside the work files wherever the project pins them — one line per settled decision, each pointing at the fight that settled it. The verdict is the index line; the fight stays where it was written.

## The line

```markdown
- **Raw SQL over any ORM** — schema drift burned v1; queries are few and
  hand-debugged. [The fight](checkout-rework/checkout-rework.log.md#discernment)
```

Verdict in bold, the why in one line, the link to the record that holds the whole battle. The link is relative to `.genius/`, where `DECIDED.md` sits, so it carries the work's folder, as above. A decision that landed outside the flow — no work file, no battlefield — carries its why in the line itself: there the line *is* the record, so give the why one honest sentence rather than a verdict alone.

## The test

An index line is earned by one question: **would a future stranger re-fight this?** — propose the killed thing again, redo the settled study, "fix" the deliberate deviation. It is the same re-litigation test the kill-reason already answers inside one piece of work, asked across all future work. Most decisions fail it — they bind only their own work, and their work file holds them fine. The ones that pass: architectural shape, boundary no-s, deliberate deviations from the obvious path, constraints invisible in the code, rejections that will be re-proposed by someone who wasn't there.

## The discipline

- **Written when the record is finished** — Tenacity's close-out asks the test of everything the work settled; a standalone `/architect` study writes its line when the design is confirmed. Never a second write-up: the line points, the record carries.
- **Read before contradicting.** The index is the ammunition `/discern` and `/architect` load: a design that touches a settled decision either dies of the fight on record or names the decision it overturns and why.
- **Overturning moves the line.** A new fight that beats a settled decision rewrites its line — new verdict, new link — and the old record stays exactly as written, because a record's worth is that it is what was written then. The index carries what the project believes now; the files carry how it came to believe it, including everything it used to.

## What this skill is not

Not a second place decisions get written — a line that restates the fight instead of pointing at it will drift from it. And not a diary: a decision that fails the stranger test gets no line, and that is the discipline working.
