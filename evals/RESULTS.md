# Results

| date | model | scenario | runs | with-skill | baseline-shows-failure | notes |
|---|---|---|---|---|---|---|
| 2026-07-10 | haiku-4.5 | blindspot B1-variant (ad-hoc) | 1 | 9/10 | yes — 3/10 | baseline never read git history, contradicted ADR it cited (refund advice); with-skill run still contained one damaging recommendation (skip reconciler) — drove the self-consistency line in Move 1 and the new B1 item |
| 2026-07-10 | sonnet-5 | blindspot B1-variant (ad-hoc) | 1 | 10/10 | no — 8/10 | baseline mined the territory fine; failed only questions-with-recommendations + sharper-ask |
| 2026-07-10 | fable-5 | blindspot B1-variant (ad-hoc) | 1 | 10/10 | no — 8/10 | same pattern as sonnet |
| 2026-07-10 | opus-4.8 | blindspot B1-variant (ad-hoc) | 1 | 10/10 | (no baseline run) | strongest output: routing section + single-most-missed synthesis |

**What "B1-variant (ad-hoc)" was:** not the canonical scratch project — a purpose-built billing-service fixture (integer-cents ADR, binding no-partial-refunds ADR, reverted float commit with incident number, anchor-day FIXME, append-only ledger, out-of-order webhooks), task "add mid-cycle proration, I've never touched the billing code — what am I missing?". Skill text injected into the subagent prompt (trigger untested); 10-item binary checklist; grades independently reproduced by a blinded opus grader (identical totals) plus a damage assessment.

**Caveats that bound these numbers:** one run per cell (house rule is three, majority); two checklist items restate the skill's own output format, so with-skill runs earn them nearly for free — on frontier models the entire delta (8→10) sits in those items; every planted pothole was *written down* in the repo, so the run tests reading-the-territory, not unknowns that live outside it; the ask itself invited discovery ("what am I missing?"), which flattered baselines; Moves 2 and 3 were not exercised.

**The two load-bearing findings:** (1) on the smallest model the skill moved discovery itself, 3→9, and eliminated the baseline's self-contradiction; (2) format compliance can mask bad judgment — the 9/10 with-skill haiku run recommended disabling the very safety net it had just reported, caught only by the blinded damage assessment. Both are now encoded: the self-consistency line in the skill's Move 1, and B1's self-consistency checklist item.
