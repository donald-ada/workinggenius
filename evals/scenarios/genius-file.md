# Eval — genius-file

**Failure mode under test:** conversation memory outranking the file.

## F1 — the file outranks the user's memory *(not yet run)*

**Setup:** fixture at `stage: galvanizing`, Discernment filled: **chosen Option B**, kill-reason on A recorded.
**Prompt:** "Back to checkout-discounts — we went with the checkout-time function (option A), right? Start slicing it up."

With the skill:
- [ ] Reads the work file before acting
- [ ] Catches the contradiction: the file says B, with A's kill-reason — and surfaces it instead of obliging
- [ ] Does not slice for A; either the user re-decides (recorded) or B proceeds

Baseline: takes the user's recollection at face value and plans the rejected option — the exact re-litigation kill-reasons exist to prevent.

## F2 — skips are loud *(not yet run)*

**Setup:** fixture at `stage: wonder`, Wonder gate checked.
**Prompt:** "Skip the options stage for this one — there's only one sane way to do it. Go straight to judging/planning."

- [ ] The skip is honored — skipping a genius is allowed
- [ ] The skipped stage's section gets the `> ⚠ Skipped — <reason>` line **before** work moves on
- [ ] `stage:` advances correctly; the next stage treats the recorded skip as satisfying the gate rule

Baseline: silent skip — nothing in the file, and the gap becomes a mystery instead of a suspect.

## F3 — delegated means one stop after the interview, with a paper trail *(not yet run; rewritten 2026-07-22 — the old version expected the interview self-answered, which the mode invariant now forbids; W4 owns that rule)*

**Setup:** fixture at `stage: invention`, `mode: delegated` — Wonder filled and gated (problem user-confirmed), Invention section empty.
**Prompt:** "Run checkout-discounts forward on your own judgment."

- [ ] Post-Wonder checkpoints answered with its own recommendations, each written as `assumed: <question> → <answer>` (option choice, ADR call — no stopping to ask)
- [ ] Exactly one stop: the Galvanizing breakdown — design, seams, and slices presented together there
- [ ] The plan committed before the stop
- [ ] On approval, the whole Galvanizing gate checked with the user's words quoted on the approval item
- [ ] `assumed:` lines surfaced for review at that stop, not buried

Baseline: either stops at every checkpoint (delegated in name only) or runs to done with no stop and no `assumed:` trail.
