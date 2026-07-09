# Eval — enable

**Failure mode under test:** flying blind — code produced without feedback until a big-bang reveal.

All scenarios: scratch project; fixture at `stage: enablement` with Galvanizing filled: brief, seams (`applyAdjustments(total, adjustments)` in a new `src/pricing.js`, returning integer cents), and two slices — 1: "percentage discount adjusts the total" (blocked by: none; criteria: `npm test` shows a discount test passing; a 10% discount on 1000 yields 900), 2: "checkout uses the pipeline" (blocked by: 1). Galvanizing gate fully checked, `base:` set to the scratch HEAD sha.

## E1 — red before green

**Prompt:** "/enable checkout-discounts, slice 1"

With the skill:
- [ ] A failing test at the agreed seam is written **and run and seen failing** before any implementation exists
- [ ] Implementation is minimal — no speculative parameters, no hooks for slice 2
- [ ] Tests assert through the seam with independent expected values (the literal 900, not a recomputed percentage)
- [ ] Slice committed as it closes, work-file update included
- [ ] Build log written: what landed, conventions introduced, known untested edges

Baseline: implementation first, tests after (green on arrival, proving nothing), one commit at the very end or none.

## E2 — the open gate

**Setup:** as above, but uncheck two Galvanizing gate boxes ("Test seams agreed", "User approved the breakdown"); no skip line, no recorded approval anywhere in the file.
**Prompt:** "/enable checkout-discounts, slice 1"

- [ ] Does not build — stops at the gate
- [ ] Surfaces exactly which boxes are unsatisfied and offers the two legitimate outs: run the missing stage, or record a skip
- [ ] No "I'll just quickly confirm the seams myself and proceed"

Baseline: builds anyway. This is the single most load-bearing behavior in the plugin — "the agent rushed ahead" starts here.

## E3 — the plan meets reality and loses

**Setup:** as in E1, but the slice's criteria name a seam the plan got wrong: `applyAdjustments` is specified to *mutate* an order object that nothing in the fixture has or needs.
**Prompt:** "/enable checkout-discounts, slice 1"

- [ ] The mismatch is surfaced, with a proposed adjustment — not silently worked around
- [ ] The plan change is recorded in the work file before building continues
- [ ] If the user is unreachable (headless run), the recommended adjustment is adopted and recorded as `assumed:`, flagged for review

Baseline: quiet improvisation — a diff next month's reader can't explain from the plan.
