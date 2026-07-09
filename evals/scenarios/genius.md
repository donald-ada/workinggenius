# Eval — genius

**Failure mode under test:** the map lies — wrong next command, invisible gaps, recommendations the record contradicts.

User-invoked only, so no trigger rows; these are behavior scenarios.

## M1 — the unrecorded bypass outranks everything

**Setup:** fixture at `stage: enablement`, with Galvanizing filled and gated as in `enable.md`'s setup — but add the template's Discernment gate block with two boxes left unchecked and no skip line: someone rushed past it. (The shipped fixture has no Discernment gate at all; without adding one, the parser reports it as `nogate:` — suspicious but non-blocking — and the scenario grades the wrong thing.)
**Prompt:** `/genius`

With the skill:
- [ ] The bypass is flagged as the loudest smell — stage sits ahead of an unsatisfied gate
- [ ] The next command is **repairing that gate**, not `/enable`
- [ ] Unchecked items listed specifically, not "some gates look incomplete"

Baseline: status parroted from `stage:` frontmatter — "at enablement, next `/enable`" — the exact lie the map exists to prevent.

## M2 — the record bends the recommendation

**Setup:** copy `fixtures/done/*.md` into `.genius/` (Wonder weakest in 3 of 5).
**Prompt:** `/genius add bulk order import — merchants upload a CSV of orders`

- [ ] Recent post-mortems checked before sizing
- [ ] The Wonder pattern is named, and the recommendation leans away from express / toward a deeper interview **because of it**
- [ ] Says explicitly that the record changed the recommendation
- [ ] Mode question still asked (guided / delegated / auto) — the record informs it, doesn't replace it

Baseline (pre-P1): sizing from the idea alone; five done files of history left unread.

## M3 — diagnosis names the most upstream gap

**Setup:** fixture marked done, but its Wonder section shows the express path was taken ("small work — single obvious approach") on what became a multi-slice feature; Enablement's build log notes two plan deviations.
**Prompt:** `/genius checkout-discounts — we shipped it and merchants say it's not what they asked for`

- [ ] Reads the file and matches the symptom to skipped/rushed Wonder — the recorded skip is the first suspect
- [ ] Names *every* gap the file shows, then recommends repairing the **most upstream** one first
- [ ] Does not prescribe re-running the whole flow
- [ ] Post-mortems of other done files consulted as prior evidence

Baseline: a generic retrospective, or a recommendation to redo everything.
