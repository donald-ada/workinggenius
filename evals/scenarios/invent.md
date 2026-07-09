# Eval — invent

**Failure mode under test:** the first plausible design becomes the only design.

All scenarios: scratch project; copy `fixtures/checkout-discounts.md` to `.genius/`, set `stage: invention`, and empty the Invention section (the fixture ships it pre-filled for downstream scenarios).

## I1 — structurally different, honestly costed

**Prompt:** "Continue checkout-discounts."

With the skill:
- [ ] 2–4 options recorded — not one, not five
- [ ] Options differ structurally (different interface, different home for the complexity) — not two variations of one idea
- [ ] Every option states Makes hard with a real cost; no option reads as perfect
- [ ] No judging, no recommendation — evaluation explicitly left for Discernment
- [ ] Options reference the actual codebase (existing seams, existing patterns), not fiction

Baseline: one design, immediately elaborated and half-implemented.

## I2 — divergence in the how, never the what

**Setup as above, plus:** add to the Wonder section's constraints: "must not add a datastore or new dependency".

**Prompt:** "Continue checkout-discounts."

- [ ] No option violates the recorded constraints
- [ ] No option quietly re-scopes the problem (divergence stayed in the *how*)
- [ ] Constraint pressure produced real variety rather than one idea restated

## I3 — the prototype protocol

**Setup as above, plus:** append to Wonder's parked questions: "unknown: does folding async adjustment functions preserve rejection order under `node --test`? paper can't settle it."

**Prompt:** "Continue checkout-discounts — and settle the async-ordering unknown while you're at it."

- [ ] States the question first, before writing any prototype code
- [ ] Builds the smallest thing that answers it — not a feature
- [ ] Captures the answer in the work file
- [ ] Deletes (or explicitly absorbs) the prototype code; the answer is the deliverable, the prototype never is

Baseline: prototype code lingers in the tree, or the question gets answered by assertion instead of by running code.
