# Eval — galvanize

**Failure mode under test:** a decision everyone agrees with and no fresh session can start from.

All scenarios: scratch project; copy `fixtures/checkout-discounts.md` to `.genius/`, set `stage: galvanizing`, and fill Discernment: chosen Option B (pipeline), kill-reason on A ("every future adjustment reopens the checkout path"), gate checked, ADR "not warranted".

## G1 — vertical slices *(not yet run)*

**Prompt:** "Continue checkout-discounts."

With the skill:
- [ ] Each slice cuts through every layer the change touches (config, pipeline logic, checkout wiring, tests together) — never "slice 1: all the schema, slice 2: all the logic"
- [ ] Each slice demoable on its own — a person could see it work
- [ ] Acceptance criteria independently verifiable ("running X shows Y"), none reading "works correctly"
- [ ] Blockers declared per slice (`blocked by: N` or `none`)
- [ ] Brief is behavioral — interfaces and contracts, zero file paths or line numbers

Baseline: horizontal layers, or one slice called "implement it", or criteria that can't be checked without judgment.

## G2 — every value pinned *(not yet run)*

**Setup as above, plus:** amend Discernment's chosen shape to mention "a sensible cap on stacked adjustments and a reasonable default rounding mode".
**Prompt:** "Continue checkout-discounts."

- [ ] The cap is a written number in a slice, not "a sensible cap"
- [ ] The rounding mode is named, not "reasonable"
- [ ] Any value it can't fix alone is put to the user as a question with a recommendation — never silently deferred to whichever fresh session can't ask

Fail: a slice hands a "sensible default" to a builder with no one to ask. That deferred decision is this stage's whole reason to exist.

## G3 — the mechanics of mobilization *(interactive)* *(not yet run)*

**Prompt:** "Continue checkout-discounts." — approve the breakdown when quizzed.

- [ ] Quizzed before finalizing: granularity, dependencies, merge-or-split — and iterated on the answer
- [ ] Test seams confirmed with the user as contracts (outcomes, side-effect ownership), not bare signatures
- [ ] `base:` set to the sha of HEAD as it stands, then the plan committed once
- [ ] Gate checked only after the approval; ends by naming `/enable` and the fresh-context advice

Baseline failure this guards: a plan that was never put back to the user, or `base:` recorded after the plan commit — which would leave the plan itself outside the diff Tenacity reviews (the contract is `base:` first, plan commit after, so the plan is part of the reviewed work).
