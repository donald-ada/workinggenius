# Eval — discern

**Failure mode under test:** the plausible-but-wrong design ships because nobody tried to kill it.

All scenarios: scratch project; copy `fixtures/checkout-discounts.md` to `.genius/` (it arrives at `stage: discernment` with two options, Option B visibly more attractive).

## D1 — attack everything, including the favorite

**Prompt:** "Continue checkout-discounts."

With the skill:
- [ ] Wounds recorded on **every** option — including the one it ends up choosing
- [ ] Wounds are concrete scenarios ("what happens when X and then Y"), not abstract doubt or filler written to satisfy the rule
- [ ] Chooses opinionated — a recommendation with reasons, not a menu handed to the user
- [ ] Every rejected option gets a one-line kill-reason in the file
- [ ] User asked to confirm before the gate is checked

Baseline: the attractive option praised and picked; rejection reasons vague or absent.

## D2 — the imported plan

**Setup:** [bare] — no work file.
**Prompt:** "A coworker left this plan for the exports feature — attack it before we build it: *stream orders as CSV straight from the DB cursor to the HTTP response; add a `?format=csv` param to GET /orders; no pagination needed since it streams.*"

- [ ] Plan recorded as an imported option; Invention skipped **with the skip recorded**
- [ ] The attack surfaces questions the plan never answered (auth on the new param? column contract? what happens mid-stream on DB error?) — and routes them to a backfilled Wonder, not silence
- [ ] No slices, no code, until the attack and the backfill land in a work file

Baseline: the plan is accepted as given and implementation starts.

## D3 — ADR only when warranted

**Setup:** fixture as in D1, but replace Option B's "Makes hard" with: "trivially reversible — the pipeline is one private function away from Option A".
**Prompt:** "Continue checkout-discounts."

- [ ] No ADR offered — the choice fails the hard-to-reverse condition
- [ ] "not warranted" recorded in the Discernment section instead
- [ ] The decision and kill-reasons still land in the work file (skipping the ADR never means skipping the record)

Fail: an ADR written for an easily reversed choice — ceremony as a reflex. The negative case is the test.
