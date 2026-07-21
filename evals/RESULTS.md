# Results

## 2026-07-21 — synthesis: three runs draw the commodity/differentiated line

Three scenarios run for real on the same tier (sonnet-5) now map exactly where
this plugin still earns its place against a frontier baseline — the answer to
"is any of this differentiated, or does the model already do it?"

| scenario | what it tests | skill | baseline | delta |
|---|---|---|---|---|
| M2 | post-mortem-informed **sizing** (soft, advisory) | does it | **does it** | none — softball |
| M1 | treat an open gate as a **stop** (discipline) | 3/3 halt | 1/3 halt | partial — enforcement only |
| E1 | **red-before-green** at the seam (structural) | 3/3 | **0/3** | clean |

The gradient is the finding. The advisory behavior (M2) is fully absorbed — a
capable model sizes work from history unaided. The perception underneath the
discipline (M1) is absorbed too — the baseline *sees* the bypassed gate every
time. What is **not** absorbed is the mechanical commitment: halting on the gate
(M1: baseline builds through 2/3) and writing-and-failing the test before the
code (E1: baseline 0/3). The plugin's real, surviving value is the part that
makes the model do the disciplined thing it otherwise reasons its way *past* —
not the part that tells it something it already knows. That is precisely the
case the README's mechanical claims (the hook gate, red-before-green) rest on,
and the case the advisory prose cannot make. The roadmap's bet — invest in
enforcement, treat advisory prose as erodible — is now measured, not asserted.

## 2026-07-21 — E1 flagship: red-before-green is a clean delta (3/0)

E1 (red-before-green at the agreed seam) run 3× per arm, sonnet-5, graded
**programmatically** from the event stream — the objective signal is the order
of operations: was a test written and run and seen *failing* before the
implementation file existed? No model judgment needed, so no grader to bias.

- **Skill: 3/3 red-before-green.** Every run: write `test/pricing.test.js` →
  `npm test` (red — `applyAdjustments` not defined yet) → write `src/pricing.js`
  → `npm test` (green) → update work file → commit the slice.
- **Baseline: 0/3.** Every run: write `src/pricing.js` **first** → write the test
  → `npm test` once (green on arrival). The test was never seen red — it proves
  the code matches itself, not that it matches the spec. Exactly the failure the
  scenario names ("implementation first, tests after, green on arrival, proving
  nothing").

This is the cleanest delta of the three scenarios and it sits on the plugin's
core identity. A frontier model, told to build a slice with a named test command,
does not write the failing test first on its own — it writes the code and
confirms it. The skill's insistence on red-first is doing real work the baseline
does not do. Caveats: n=3 per arm, sonnet-5, single scenario; the programmatic
grader scored the load-bearing red-before-green item (items on minimal
implementation, independent expected values, and the build log were spot-checked
by inspection, not scored across all six).

M1 sharpened along the way: see its entry below.

## 2026-07-21 — M1 has a real delta: the skill enforces the stop a capable model skips

M1 (the unrecorded bypass) run for real, 3 runs per arm, sonnet-5, **blind-graded
by a subagent** that never saw which arm produced which transcript. Result on the
three checklist items (A: bypass flagged as the top issue; B: next step is repair,
not build; C: unchecked items named specifically):

| arm | A | B | C |
|---|---|---|---|
| skill    | 3/3 | 3/3 | 3/3 |
| baseline | 1/3 | **1/3** | 3/3 |

The load-bearing item is B, and this is where the plugin earns its place. Two
things are true at once:

1. **The scenario's stated baseline is outdated.** It predicted the baseline would
   "parrot `stage:` frontmatter — at enablement, next `/enable`". It never did.
   All three baseline runs *noticed* the unchecked Discernment gate and named the
   exact open boxes (C: 3/3) — a frontier model reads the gate state fine. Model
   improvement erased the naive failure the scenario was written against.
2. **The discipline delta survived anyway.** Given the identical observation, the
   baseline built straight through the open gate 2 of 3 times ("Next step:
   implement Slice 1…"), treating the unchecked gate as a cosmetic note. The skill
   treated it as a stop every time ("repair the Discernment gate before continuing
   Enablement"). The plugin's surviving value is not *noticing* — models notice —
   it's converting the observation into a **halt**. That is exactly the mechanical/
   structural value M2's softball pointed at, now measured on the other side.

Verdict: M1 passes by the house rule (skill clears the checklist; baseline exhibits
the failure — build-through — in the majority). But the scenario's baseline note is
sharpened to the real failure ("notices, builds through") rather than the extinct
one ("parrots frontmatter"), so the next runner tests against what actually happens.

Caveats: n=3 per arm, sonnet-5 only, single scenario; the baseline is not
*reliably* wrong (1/3 repaired first), so the delta is a majority tendency, not a
law — a weaker tier would likely widen it, a stronger one might narrow it. Blind
grading (subagent, key withheld) is the one methodological step up from M2's
author-grading.

## 2026-07-21 — headless harness lands; M2 baseline is a softball on frontier tier

First real use of `run-scenario.sh`: the eval loop now runs end-to-end headless
(`claude -p`, read-only allowlist, transcript captured). Running M2 (post-mortem-
informed sizing) for real surfaced two things worth more than a green checkmark.

**A fixture leak, found and fixed.** `fixtures/scratch.sh` writes a `CLAUDE.md`
that documents the whole Working Genius flow. That section was reaching the
*baseline* arm too — so the no-plugin control was being handed the plugin's own
methodology. With it intact, the M2 baseline (sonnet-5) reproduced the skill's
recommendation nearly verbatim. The runner now strips the `## Working Genius`
section for the baseline arm, and `evals/README.md` step 6 documents it as a
standing rule. Every earlier baseline assumption in the scenario files predates
this fix and is suspect until re-run on a clean control.

**M2 has no delta on this tier — three ways.** Against a clean baseline
(sonnet-5, section stripped), the base model still: explored `.genius/`, found
the "Wonder weakest in 3 of 5" post-mortem pattern, cited a specific prior
post-mortem, and sized the work proportionally ("small CLI, doesn't need
heavyweight process; confirm the CSV contract first"). It did this under a
process-inviting prompt, a neutral prompt, and the de-leaked fixture — the
target behavior every time, unaided. So M2's baseline does **not** exhibit the
failure mode it names ("five done files of history left unread"); the assumption
is a casualty of model improvement. Per the house rule, that makes M2 a softball
on frontier tier: the skill line it tests is, for elicitation, a no-op there.
This is direct evidence for the market-research thesis (frontier baselines
absorb the soft, advisory behaviors) — and a pointer at where the real,
non-commodity value must live: the *mechanical* parts (hook-enforced gates,
red-before-green in `/enable`, fresh-evidence verification in `/tenacity`),
not the advisory-prose parts a strong model now supplies on its own.

Caveats bounding this: n=1 run per arm (not the 3-run majority — this was a
harness-validation pass, not a graded verdict); one scenario of eleven; grading
by the author, not a blinded subagent; sonnet-5 only — the delta may well exist
on a weaker tier, which is the next thing to check before concluding the line is
dead rather than tier-dependent. M2's marker stays, re-annotated to "softball on
frontier tier" rather than cleared — it was run, and it did not pass.

**What this buys the roadmap.** Phase 1.1's real job just got sharper: running
the scenarios is not box-ticking, it's a hunt for exactly this — soft behaviors
that a current baseline already does. Some scenarios will pass (the mechanical
ones should), some will expose no-ops to cut. Both outcomes are the eval working.

## 2026-07-10 — tiering reversal: the territory pass runs frontier-tier (user ruling)

The cost run's "pass on cheapest capable tier" rule is reversed. The 9/10 haiku score that justified it came from a fixture whose potholes were all *written down* — a reading test. Two judgment failures say otherwise: the rocket-run haiku pass recommended the exact render path the fixed constraint forbade (corrected only by two later opus stages, one prototype), and the billing-run haiku pass recommended disabling the safety net it had just reported. Move 1 now mandates the session's main model or better; the subagent shape (fresh context, consume-don't-re-explore) stays. Cost levers move to the scoped mid-tier reviewer, mid-tier divergence drafts, and sizing. Kill-reason for the old rule recorded here so it doesn't get re-proposed: checklist scores measure recall of documented territory, not judgment of undocumented territory — and the pass exists for the second thing.

## 2026-07-10 — full-flow rocket-sim run (stall post-mortem)

Full six-stage flow vs a no-plugin baseline (both opus) on a greenfield 3D rocket-recovery web sim, each stage metered as its own subagent. Three stalls, one signature: an agent that had to *wait on its own subagent* ended its turn and was never woken — in this harness, child-completion notifications reach only the top-level session, not a stopped intermediate agent. Every single-shot stage agent (wonder/invent/discern/galvanize, the three slice builders) ran clean; both waiters (the /enable coordinator twice, tenacity once) stalled. Stall #1 was also the known announce-instead-of-do failure: the coordinator declared "next I'll dispatch slice 2" and ended its turn. Root cause split: harness wake semantics + nested-coordinator test topology (dominant; normal usage — coordinator = the user's live session — is woken normally), model early-stopping (contributing), and a real skill gap (enable's "when a subagent returns" assumed being woken). Fixed red-to-green: enable gains "coordinating means staying awake" (foreground dispatch when wake semantics are uncertain; dispatching is doing), tenacity's reviewer spawn gets the same line. Flow outcome vs baseline, for the record: plugin 1.58M tok / $37.6 / 11× baseline cost, contract met by construction (baseline black-screens under the agreed judging command); baseline richer visuals under its own flags at 141k tok. n=1, single task, visual verdict left to the user.

| date | model | scenario | runs | with-skill | baseline-shows-failure | notes |
|---|---|---|---|---|---|---|
| 2026-07-10 | haiku-4.5 | blindspot B1-variant (ad-hoc) | 1 | 9/10 | yes — 3/10 | baseline never read git history, contradicted ADR it cited (refund advice); with-skill run still contained one damaging recommendation (skip reconciler) — drove the self-consistency line in Move 1 and the new B1 item |
| 2026-07-10 | sonnet-5 | blindspot B1-variant (ad-hoc) | 1 | 10/10 | no — 8/10 | baseline mined the territory fine; failed only questions-with-recommendations + sharper-ask |
| 2026-07-10 | fable-5 | blindspot B1-variant (ad-hoc) | 1 | 10/10 | no — 8/10 | same pattern as sonnet |
| 2026-07-10 | opus-4.8 | blindspot B1-variant (ad-hoc) | 1 | 10/10 | (no baseline run) | strongest output: routing section + single-most-missed synthesis |

**What "B1-variant (ad-hoc)" was:** not the canonical scratch project — a purpose-built billing-service fixture (integer-cents ADR, binding no-partial-refunds ADR, reverted float commit with incident number, anchor-day FIXME, append-only ledger, out-of-order webhooks), task "add mid-cycle proration, I've never touched the billing code — what am I missing?". Skill text injected into the subagent prompt (trigger untested); 10-item binary checklist; grades independently reproduced by a blinded opus grader (identical totals) plus a damage assessment.

**Caveats that bound these numbers:** one run per cell (house rule is three, majority); two checklist items restate the skill's own output format, so with-skill runs earn them nearly for free — on frontier models the entire delta (8→10) sits in those items; every planted pothole was *written down* in the repo, so the run tests reading-the-territory, not unknowns that live outside it; the ask itself invited discovery ("what am I missing?"), which flattered baselines; Moves 2 and 3 were not exercised.

## 2026-07-10 — greenfield build run (skill-only, no gates)

Three builders (sonnet-5, opus-4.8, fable-5), same vague product ask ("开发一个有趣的卡路里健康管理助手。不要做成玩具"), each with the blindspot skill injected, each required to write the Move 1 pass to UNKNOWNS.md before building, then build and verify offline. A blinded fable reviewer ran all three test suites, drove all three apps adversarially, and audited each build against its own UNKNOWNS.md. Ranking: fable (adaptive engine verifiably drives the budget; shallow local wounds) > opus (best hygiene and honesty UI, but one critical persist-before-validate bug and a decorative flagship feature) > sonnet (best-narrated engine, systemic validation gaps).

**The finding that matters for the plugin:** the skill homogenized problem framing across models — all three independently identified the same toy-tells (bare-number TDEE, no safety clamps, midnight day boundary, mutable history) and all shipped those guards. But the worst defects in two of three builds were *contradictions of their own UNKNOWNS.md* ("bad input should never corrupt stats" → accepts `logw -5`; "never a 500, negative weights handled" → persists an invalid profile and bricks the app). Move 1 surfaces unknowns; nothing in a skill-only run makes the build honor them. That loop is exactly what the stage gates (Galvanizing's acceptance criteria, Tenacity's line-by-line verify against the work file) exist to close — this run is evidence for the architecture, not for a skill edit. Caveats: n=1 per model, no baseline arm, single blinded reviewer.

## 2026-07-10 — cost run (model tiering)

Filled the missing base-opus cell on the billing fixture and priced every measured run at current output rates (Opus $25, Sonnet $15, Haiku $5, Fable $50 per MTok). Discovery stage, all measured: base-opus 26.5k tok / $0.66 / 8-of-10; skill-opus 27.9k / $0.70 / 10-of-10; **skill-haiku 29.6k / $0.15 / 9-of-10** — the tiered pass beats the no-skill opus baseline on quality at 78% lower cost. Where spend actually concentrated across both test days: verification agents (an unscoped fable reviewer hit 131k tok = $6.55, the most expensive single step of everything run), then builders (74–95k), then passes (27–36k). The redundant spend on frontier models is the pass itself — baseline opus mines the territory anyway (8/10); what it lacks is format, which a cheap model following the skill supplies.

Encoded as tiering rules: blindspot Move 1 runs as a cheapest-capable-tier subagent *(reversed the same day — see the tiering-reversal entry above; the 9/10 measured recall of documented potholes, not judgment)* whose findings carry evidence so nothing re-explores; Tenacity's reviewer is mid-tier and scoped to the diff + work file; Invention's parallel drafts are mid-tier. Full-workflow arithmetic vs no-skill opus (discovery + build, review excluded from both sides): $2.51 baseline vs $1.99 tiered with the build stage assumed unchanged — a 21% saving at higher measured quality; any builder saving from consuming the pass instead of re-deriving it widens the gap. Caveats: n=1 per cell; output-token pricing only (input is cache-dominated); builder-side saving unmeasured.

**The two load-bearing findings (from the billing-fixture run):** (1) on the smallest model the skill moved discovery itself, 3→9, and eliminated the baseline's self-contradiction; (2) format compliance can mask bad judgment — the 9/10 with-skill haiku run recommended disabling the very safety net it had just reported, caught only by the blinded damage assessment. Both are now encoded: the self-consistency line in the skill's Move 1, and B1's self-consistency checklist item.
