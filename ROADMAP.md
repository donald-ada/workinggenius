# Roadmap

The pre-redesign roadmap — five phases built around the gate engine, the eval
inventory, and the receipts pitch — lived until `275ed4f`; git history keeps
it. This one is re-derived against the bet the 2026-08-06 concept-first
redesign placed (`evals/RESULTS.md`):

> **The bet:** a strong model handed the concept — each stage's purpose, its
> failure mode, one threshold — does what the detailed prose and mechanical
> enforcement used to make it do, without the ceremony or the token weight.
> Model capability keeps rising; constraints depreciate, concepts hold.

## Phase 1 — Measure the bet

The July 2026 runs located real deltas at momentum-contrary action points —
red-before-green (baseline 0/3), question-the-ask (0/3), the gate-stop (1/3)
— measured against the *detailed* prose. Whether a concept line holds the
same behavior is the open question, and it's testable with the method that
found the deltas (`evals/README.md`: baseline arm, three runs, majority):

- Re-derive a handful of scenarios fresh from the concept skills, sharpest
  historical deltas first (test-first, question-the-ask).
- Three honest outcomes per scenario, each with its action: the concept
  **holds** — record the vindication; the concept **fails** where the
  checklist held — restore that one constraint narrowly, or accept the loss
  knowingly, recording which; the **baseline passes too** — the model
  absorbed it, delete the concept line as well.

*Kill-criterion:* concept lines failing where checklists held, beyond
isolated cases, kills the bet's strong form — the redesign gets revised from
evidence, not defended.

## Phase 2 — Dogfood

Use the flow on this repo's own work, issue tracking on. Post-mortems
accumulate and calibrate sizing; a concept line that never visibly changes
behavior in real use is decoration — cut it. Deletion stays a feature.

## Phase 3 — The brownfield demo

The unclaimed opening survives the redesign: one reproducible session on a
real, old repo — the territory pass with commit evidence, Wonder shrinking
the ask against prior art, Discernment attacking against the record. The
concepts either feed on the mess or they don't; publish what actually
happened, claims shrunk to what the session showed.

## Standing constraints

- No number ships ahead of its `RESULTS.md` row.
- Single-maintainer honesty: prose-only, no state a fork can't carry.
- No new stages; the pressure stays toward less, via sizing.
- The mechanical layer returns only if Phase 1's evidence demands it — and
  then narrowly, as the smallest constraint that restores the failing
  behavior, never the old layer whole.
