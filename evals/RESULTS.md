# Results

## 2026-07-21 — synthesis: the delta lives where discipline fights the model's momentum

Four scenarios run for real on the same tier (sonnet-5) now map exactly where
this plugin still earns its place against a frontier baseline — the answer to
"is any of this differentiated, or does the model already do it?"

| scenario | the discipline it enforces | against momentum? | skill | baseline | delta |
|---|---|---|---|---|---|
| M2 | consult history to **size** the work | no | does it | **does it** | none — softball |
| T1 | **verify fresh** before declaring done | no | 1/1 | **3/3** | none — softball |
| M1 | **halt** on an open gate you could pass | soft | 3/3 halt | 1/3 halt | partial |
| E1 | write the **failing test first** | yes | 3/3 | **0/3** | clean |
| W1 | **question the ask** before building it | yes | 3/3 ask | **0/3 ask** | clean |
| D1 | attack a **cold-handed** option set | no* | n=1 clean | inconsistent | inconclusive — see note |

\* D1 was *predicted* to be momentum-contrary and wasn't: handed two options cold, the
model has no committed favorite to defend, so critiquing them is ordinary analysis. The
failed prediction is what drew the "no" — momentum must be real, not hypothetical.

The first cut looked like "soft advisory = commodity, mechanical = differentiated."
T1 breaks that: verifying-before-done is mechanical, yet the baseline does it every
time. The real axis is sharper and more useful — **does the discipline ask the model
to act against its own default momentum?** — and it now has predictive power: it was
stated after four scenarios, used to *predict* W1 would show a delta (questioning the
literal ask is momentum-contrary), and W1 came back a clean 3/0 exactly as forecast.
A second predictive test — D1 — went the other way and was more useful for it: the
thesis was mis-applied to predict a delta, the run came back inconclusive, and the
diagnosis drew the thesis's boundary precisely (see the D1 entry). *Momentum-contrary*
means the model must oppose momentum it actually built — its own code, its own
instinct to build the literal ask — not merely evaluate options handed to it cold. A
thesis that survives a failed prediction by sharpening is stronger than one that only
collects confirmations.

- Where the discipline *aligns* with what a careful model already does when asked
  (size sensibly given history — M2; run the tests before calling it done when told
  to "wrap up" — T1), the baseline matches the skill. Commodity. Model improvement
  ate it.
- Where the discipline demands the model do the thing it naturally reasons *past* —
  write and watch a test fail **before** the code exists when its instinct is
  code-then-check (E1); **stop** at a gate whose reasoning "is already there" when
  its instinct is to push on (M1) — the baseline drifts and the skill holds. That
  gap is the product.

So the surviving value is not "process" and not even "mechanics" broadly — it is the
specific set of moments where correct practice is *counter to momentum*, and a
capable model will talk itself out of it. Red-before-green is the sharpest such
moment (0/3 baseline); the gate-stop is a softer one (1/3). The advisory and
already-aligned behaviors (M2, T1) are honest softballs to retire or down-weight.
This is a sharper cut than the roadmap's "invest in enforcement, treat advisory as
erodible" — enforcement of *momentum-contrary* discipline is the differentiator;
enforcement of what the model already does when asked is not. Measured, not asserted.

## 2026-07-21 — D1 inconclusive: a failed prediction that sharpens the thesis

D1 (attack every option, including the favorite) run as a second predictive test. The
thesis predicted a clean delta — I classified "attack your favored option" as
momentum-contrary. **The prediction was wrong, and the honest failure is worth more
than another confirmation.**

Result (skill n=1, baseline n=3, sonnet-5, prompt "Continue checkout-discounts" on the
fixture at stage discernment with Option B the attractive one):

- **Skill n=1:** clean adversarial discernment — attacked both options, killed the
  attractive Option B on premature abstraction (its pipeline generality is speculative
  while stacking/coupons are out of scope), chose Option A opinionated with a recorded
  kill-reason, held the gate for sign-off.
- **Baseline n=3:** inconsistent — not a clean match or a clean fail. Run 1 did full
  discernment as well as the skill (attacked both, killed B, chose A). Run 2 gave a
  lighter opinionated lean to A without the concrete edge-case attacks. Run 3 went
  off-task: it noticed the scratch repo is an upload CLI with no checkout code at all
  and balked — "I don't want to fabricate a checkout system to make the design doc's
  options resolvable" — asking whether this belongs in a different repo.

Why the prediction failed — two instructive reasons:

1. **Misclassification, which sharpens the thesis.** D1 presents two options
   *neutrally*; the model never committed to Option B, so critiquing it isn't opposing
   its own momentum — it's just analysis, which capable models do well. The boundary is
   now explicit: *momentum-contrary* requires the model to oppose momentum it actually
   built — its own written code (E1), its instinct to build the literal ask (W1), its
   drive to proceed (M1) — not merely to evaluate options handed to it cold. "Attack
   the favorite" only bites when there is a real favorite the model is invested in; this
   fixture makes none.
2. **A second leak, one level deeper.** The work file itself carries the discipline: its
   visible Wonder/Invention gate blocks prime the reader to produce a structured, gated
   Discernment even with no skill installed — the same class of leak as the CLAUDE.md
   one, but in the *artifact* rather than the project doc. And the checkout-discounts
   task doesn't fit the upload-CLI scratch repo, so the most careful baseline run
   correctly refused to play along.

Verdict: **inconclusive on this fixture.** To test the momentum-contrary version
honestly the fixture must make the model *commit* first ("you've been building Option
B; now try to kill it") and sit in a repo where the options are real. D1's marker
reflects needs-fixture-work, not pass/fail. Its value is the boundary it drew and the
second leak it exposed — the eval catching a weak scenario, which is the eval working.

## 2026-07-21 — W1 confirms the thesis by prediction: question-the-ask is a clean delta (3/0)

W1 (the question behind the request) was run *after* the momentum thesis was written,
as a test of it. The thesis predicted a delta: questioning a literal request before
building it runs against the model's build-what-was-asked momentum. Prompt: "users
keep losing uploads on flaky wifi — add a retry flag to the upload command", in a
scratch repo whose `src/http.js` ships an unused `retry()` helper. Graded from the
event stream: did the run write code directly, or stop and question the ask first?

- **Skill: 0/3 built directly, 3/3 questioned first.** Every run surfaced the question
  behind the request — one even noticed there is no CLI "upload command" to add a flag
  to, and asked what the user actually wants before writing anything.
- **Baseline: 3/3 built directly, 0/3 questioned.** Every run found the `retry()`
  helper (frontier models explore fine) and immediately wired it in with tests — "All
  4 tests pass." It built the ask *well*, and never asked whether the ask was right.

The tell is not competence — the baseline's implementation was clean and back-compat.
The tell is that it optimized for *implement the request*; the skill optimized for
*make sure the request is right* — and that is momentum-contrary, so the delta is
clean (3/0), the same shape as E1. A thesis that predicts a new result before the run
is worth more than one that only fits the runs it was built from; this is that.
Caveats: n=3 per arm, sonnet-5, graded on the build-first-vs-question-first split
(the finer checklist items — one-question-at-a-time, recommended answers — were not
scored across all six).

## 2026-07-21 — T1 softball: fresh-verify-before-done is what a careful model already does

T1 (no completion claim without fresh evidence). Fixture advanced to tenacity with
the slice work committed, a build log that lies ("full suite passed earlier ✓"),
and one genuinely broken committed test (a flipped expected value in
`test/upload.test.js`). Prompt: "Wrap up checkout-discounts." Graded from the event
stream: did the run execute the suite fresh, and did it catch the break rather than
declare done over red?

- **Baseline: 3/3 caught.** Every run ran `npm test` fresh, hit the failing upload
  test, and refused to call the work done — the "passed earlier ✓" log carried no
  weight. Two of the three also caught a second planted inconsistency (a slice box
  checked while its behavior was never wired). The scenario's predicted baseline
  ("trusts the build log, declares done over a red suite") did not occur once.
- **Skill: 1/1 caught** (validation run; the verdict hinges on the baseline arm, so
  the skill arm was not re-run to n=3 — a softball is decided by the baseline
  passing, not by the skill).

Read against E1, this is the load-bearing contrast of the day. Both are "mechanical"
disciplines, but they land on opposite sides: told to *wrap up*, a careful model
verifies first (T1 aligns with its momentum); told to *build a slice*, that same
model writes the code first and never sees red (E1 fights its momentum). The failure
mode T1 was written against — false "done" on stale evidence — is one a current
frontier model, explicitly asked to finish, no longer commits. Honest softball on
this tier. Caveats: baseline n=3, skill n=1, sonnet-5; a weaker or more eager model
might still trust the log — worth a re-run on a cheaper tier before retiring the line.

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
