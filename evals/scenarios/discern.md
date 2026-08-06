# Eval — discern

**Failure mode under test:** the plausible-but-wrong design ships because nobody tried to kill it.

All scenarios: scratch project; copy `fixtures/checkout-discounts.md` to `.genius/` (it arrives at `stage: discernment` with two options, Option B visibly more attractive).

## D1 — attack everything, including the favorite *(run 2026-07-21, inconclusive — needs fixture work: the model is handed two options cold (no committed favorite to defend, so not momentum-contrary), and the work-file scaffold + upload-CLI repo mismatch confound the baseline. See RESULTS)*

**Prompt:** "Continue checkout-discounts."

With the skill:
- [ ] Every option — including the one it ends up choosing — is genuinely attacked: it carries either concrete wounds or a record of *which attacks it survived* (a bare unexamined option fails; so does a filler wound invented to satisfy a quota)
- [ ] Wounds are concrete scenarios ("what happens when X and then Y"), not abstract doubt
- [ ] Chooses opinionated — a recommendation with reasons, not a menu handed to the user
- [ ] Every rejected option gets a one-line kill-reason in the file
- [ ] User asked to confirm before the gate is checked

Baseline: the attractive option praised and picked; rejection reasons vague or absent.

## D2 — the imported plan *(not yet run)*

**Setup:** [bare] — no work file.
**Prompt:** "A coworker left this plan for the exports feature — attack it before we build it: *stream orders as CSV straight from the DB cursor to the HTTP response; add a `?format=csv` param to GET /orders; no pagination needed since it streams.*"

- [ ] Plan recorded as an imported option; Invention skipped **with the skip recorded**
- [ ] The attack surfaces questions the plan never answered (auth on the new param? column contract? what happens mid-stream on DB error?) — and routes them to a backfilled Wonder, not silence
- [ ] No slices, no code, until the attack and the backfill land in a work file

Baseline: the plan is accepted as given and implementation starts.

## D3 — ADR only when warranted *(not yet run)*

**Setup:** fixture as in D1, but replace Option B's "Makes hard" with: "trivially reversible — the pipeline is one private function away from Option A".
**Prompt:** "Continue checkout-discounts."

- [ ] No ADR offered — the choice fails the first bar (undoing it costs no real work)
- [ ] "not warranted" recorded in the Discernment section instead
- [ ] The decision and kill-reasons still land in the work file (skipping the ADR never means skipping the record)

Fail: an ADR written for an easily reversed choice — ceremony as a reflex. The negative case is the test.

## D4 — the kill outside the axes *(red-to-green, not yet run)*

**Failure mode (design change, 2026-08-06):** the attack walked the four listed angles and stopped — a fatal wound at an angle no axis names survived to ship. The attack now opens free-form from the option's own shape; the four axes are the floor it must still have visited before concluding.

**Setup:** fixture as in D1, plus: rewrite Option B so its core mechanism is a nightly precomputation job, and add `scripts/README.md` to the scratch repo noting the deploy box runs no scheduler and a past cron proposal was rejected (one line, matter-of-fact). The wound — B's mechanism has nowhere to run — is operational: not a success-criterion miss, not an input edge case, not a convention/ADR conflict, not a future-change cost.
**Prompt:** "Continue checkout-discounts."

Red arm is the pre-edit skill (four axes as the attack's whole structure); green opens free-form:
- [ ] The no-scheduler wound is found and recorded against B — the kill living outside every listed angle
- [ ] The attack on each option visibly starts from the option's own shape, not from reciting the axes as headings
- [ ] The four floor angles are still covered before the attack concludes
- [ ] Wounds remain found, never manufactured — no filler wound appears to balance the record

Fail (red): four tidy axis-labeled attacks, all survivable; B chosen; the scheduler wound surfaces in Enablement or never.
