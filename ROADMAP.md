# Roadmap

The plan for making this plugin worth choosing in a market of 200k-star workflow
frameworks — derived from a July 2026 competitive analysis of the high-star field
(superpowers, ECC, spec-kit, BMAD, gstack, tdd-guard, et al.), the documented
reasons users abandon workflow plugins, and an honest audit of what here is
commodity versus rare.

This roadmap obeys the discipline it ships: every item has acceptance criteria a
cold reader can verify, non-goals are explicit, and each phase names the evidence
that would kill it. Items are vertical slices — each lands on its own.

## The verdict this roadmap acts on

**Commodity (stop competing here):** the six-stage pipeline, work-state files,
interview-style clarification, multi-option divergence, TDD instruction, dual-axis
diff review. Every serious framework ships these; the harness itself keeps
absorbing them (plan mode, /code-review, adversarial subagents are native now).
Phase names are free. Prose is free. Neither is a moat.

**Rare (the openings, verified against the field):**

1. *No workflow plugin tests its own prose.* The ecosystem's stated gap: no
   benchmark layer proves any skill improves outcomes. Our `evals/` discipline —
   red-before-green scenarios, no-plugin baseline arms, 3-run majority — is alone
   in the category.
2. *Almost nobody enforces mechanically.* "Gates" everywhere else are markdown the
   model can ignore; only tdd-guard (2.3k stars, outsized citations) actually
   blocks. Our gate parser + Stop hook with `warn|block` levels is in that rare
   class — and generalizes.
3. *Competing cost guidance ships unmeasured.* The field's tiering (wshobson's
   five tiers, gstack routing) is judgment without instrumentation, and the only
   in-loop budgeting found is ruflo's alerts. Our `RESULTS.md` runs — including
   one recorded reversal of our own rule — are the only instrumented cost model
   found.
4. *Every tool demos greenfield.* Blindspot's git-archaeology (reverted commits,
   bug-fix clusters, FIXME middens) has no material in a fresh repo and gets
   better with age — the brownfield opening is unclaimed.

**The two abandonment killers to design against:** fixed ceremony on
variable-sized work, and token burn. Our own full-flow measurement (11× baseline,
`RESULTS.md` 2026-07-10) sits squarely in the blast radius. Every phase below
either sharpens a rare asset or bends one of those two curves.

## Already landed (July 2026)

- Gate enforcement levels: `warn` (default) / `block`, pinned per repo, resolved
  by the shared parser; 53 deterministic tests.
- Sizing as a priced, recorded decision: `/genius` announces path + reason + the
  measured cost asymmetry, records a `**Sizing:**` line; "just do it" maps to
  delegated mode, never silent express.
- README leads with the claims-to-evidence table; brownfield section names where
  the sharp moves feed.

## Phase 1 — Prove what's claimed (the receipts get teeth)

The claims table is only as good as its weakest row. Close the gap between
"authored" and "measured."

- **1.1 Sync the markers, then run down the debt.** Step zero (done 2026-07-21):
  every scenario without a graded `RESULTS.md` row carries the *(not yet run)*
  marker — 31 of 31 at the time of writing; that number is the honest baseline,
  not an embarrassment to hide. Then the runs, in priority order: first the
  scenarios that back README claims-table rows, then the highest-stakes scenario
  per skill; each at the house rule (three runs, majority, baseline arm).
  *Accept:* markers mechanically match RESULTS (no unmarked-unrun scenario
  exists); the priority subset has RESULTS rows; every remaining marker is
  acknowledged inventory — and the README's "prose is tested" row states actual
  graded coverage instead of implying totality.
- **1.2 Bound every public number.** Each measured claim cited in README or a
  skill states its n and what it does *not* show (the RESULTS caveat style,
  promoted to policy).
  *Accept:* grep README + skills for token/cost/multiple claims → every one
  traces to a RESULTS row that states n; the 11× claim carries its n=1 bound
  wherever it appears.
- **1.3 CI for the deterministic layer.** `gates.test.sh` runs on every push.
  *Accept:* the workflow file exists; one deliberately-broken branch run shows
  red (linked from the PR or RESULTS, then reverted); README badge reflects
  main's state.
- **1.4 Re-measure the full flow post-tiering.** The 11× number predates the
  encoded tiering rules (mid-tier divergence drafts, the scoped mid-tier
  reviewer) — those are the levers that can bend a full-flow-warranted task's
  cost, and the hypothesis under test. Sizing cannot move this number and isn't
  claimed to: its effect is portfolio-level, and 2.3's express:full ratio is its
  instrument.
  *Accept:* a new RESULTS entry, same metering discipline, hypothesis stated
  up front; README cites the newer number (or honestly reports it didn't move).

*Kill-criterion for the phase:* if scenario runs show the baselines passing
(skills changing nothing), the affected skill lines get cut — that is the evals
doing their job, and cheaper than marketing them.

## Phase 2 — Cost inside the loop (bend the token curve)

Essentially nobody ships in-loop budgeting — ruflo's budget alerts are the
closest, and they're alerts, not stage-level trade-offs — and we have the
measurements to. Sizing priced the *entry*; this phase prices the *journey*.

- **2.1 Stage budgets in the work file.** Galvanizing records an expected token
  order-of-magnitude per remaining stage (from RESULTS-derived ranges);
  Tenacity's close-out records actual-vs-expected where the harness exposes
  usage, and the post-mortem gains a cost sentence.
  *Accept:* FILE-FORMAT shows the fields; a dogfooded work file shows expected
  always recorded, and actual either recorded from real harness output or
  explicitly marked unavailable — never estimated after the fact; a scenario
  grades the behavior.
- **2.2 The overrun conversation.** When a stage blows its recorded budget, the
  stage skill says so *mid-flight* and offers the trade (continue / narrow /
  stop), recording the choice.
  *Accept:* scenario where a padded fixture triggers the offer; baseline shows
  silent burn.
- **2.3 Express-share telemetry.** `/genius` status reports the express:full
  ratio across done files — the observable proxy for "ceremony matches work."
  *Accept:* status output shows the ratio when ≥3 done files exist; a scenario
  (done-files fixture, ≥3 done) fails before the skill edit and passes after —
  same red-before-green rule as 2.1 and 2.2.

*Kill-criterion:* if two consecutive dogfooded projects show budgets recorded
but never consulted (no overrun conversation ever fires, no sizing bends), the
fields are ceremony — remove them and record the reversal in RESULTS.

## Phase 3 — The gate engine stands alone (the tdd-guard-shaped prize)

"Configurable multi-stage gate enforcement" is requested often and built nowhere.
Our parser already does the hard part; the six-stage vocabulary is the only thing
binding it to this plugin.

- **3.1 Extract.** The parser reads its stage list and gate grammar from
  configuration (defaulting to the Working Genius six), keeping the current CLI
  contract. Workinggenius becomes consumer #1; every one of the 53 tests still
  passes unmodified.
  *Accept:* a config fixture with three custom stages passes an equivalent test
  matrix; zero behavior change for defaults.
- **3.2 Harder than Stop.** Optional PreToolUse enforcement: edits to product
  code blocked while a named gate is open (tdd-guard's proof, generalized beyond
  TDD).
  *Accept:* deterministic tests for allow/block paths; off by default;
  documented escape hatch.
- **3.3 Ship it separately.** Own repo/marketplace entry, its own README in the
  receipts style, this plugin listed as first consumer.
  *Accept:* installable standalone with its own deterministic test suite — that
  much the maintainer can land alone. External adoption (a project that is not
  workinggenius using it in anger) is the phase's *success metric*: tracked,
  reported, and honest about being outside our control — never a box we check
  ourselves.

*Kill-criterion:* if 3.1's extraction bloats the parser beyond what its test
matrix can hold deterministic (flaky or unfalsifiable behavior), stop at
"configurable within workinggenius" and record why.

## Phase 4 — The eval harness becomes the product (own the trust layer)

The ecosystem's discovery problem — star counts gamed, no outcome proof — is our
home turf. The discipline in `evals/README.md` generalizes.

- **4.1 Extract the runner.** Scenario format, baseline arm, 3-run majority,
  RESULTS append — packaged so it can point at *any* skill directory, not ours.
  *Accept:* the runner executes one of our scenarios and one scenario written
  for a third-party skill, unmodified core.
- **4.2 Publish our own scorecard.** The with-skill vs baseline table for this
  plugin, regenerated by the runner, linked from the README claims table.
  Regeneration cadence is per release, not per push — full sweeps cost real
  tokens, and `evals/README.md` already says so.
  *Accept:* scorecard artifact reproducible from a clean checkout + documented
  commands.
- **4.3 Invite falsification.** README asks readers to run the baseline arm
  themselves; issues template for "a claim that didn't reproduce."
  *Accept:* the template and the README invitation exist — that lands alone.
  The first external reproduction or refutation (equally a win) is the success
  metric, recorded in RESULTS when it arrives.

*Kill-criterion:* if the runner needs model-judged grading to be usable (binary
checklists don't transfer beyond our scenarios), scope back to "our harness,
documented for forkers" — a graded-by-model leaderboard is a different product
with different failure modes, and out of scope.

## Phase 5 — Brownfield flagship (claim the unclaimed demo)

- **5.1 The walkthrough.** One reproducible session on a real, old, public repo:
  blindspot pass with commit-hash evidence, Wonder shrinking the ask against
  prior art, Discernment attacking against recorded ADRs. Published as the
  quickstart's second act.
  *Accept:* a reader can replay it from the README; every finding cites a real
  commit/test/file.
- **5.2 Greenfield honesty.** README states plainly what a fresh repo does *not*
  give these tools — and that express-path-heavy usage is the expected shape
  there.
  *Accept:* the section exists; no greenfield capability is implied that
  RESULTS can't back.

*Kill-criterion:* if the walkthrough on a real aged repo surfaces no finding a
maintainer of that repo would confirm as real — blindspot passes returning
trivia, Wonder finding no prior art to shrink against — the brownfield
positioning gets rewritten *before* the demo ships: the README section's claims
shrink to what the session actually showed, and the reversal lands in RESULTS.

## Standing constraints (every phase, no exceptions)

- **Deletion is a feature.** Any skill line the harness or model absorbs gets
  cut when its scenario stops distinguishing — the evals make deletion safe.
  Rechecked against each Claude Code release.
- **Single-maintainer honesty** (the GSD/spec-kit lesson): no server components,
  no state a fork can't carry, deterministic tests over process documentation —
  the project must survive its maintainer losing interest.
- **No number ships ahead of its RESULTS row.** Marketing follows measurement,
  never leads it.
- **Context frugality:** injected context (SessionStart, skill bodies) is
  audited when the ecosystem's stacking complaint applies to us too — being
  right is no defense against being heavy.

## Non-goals

- No agent-persona collections, no memory subsystem, no swarm orchestration —
  occupied categories, and spread is what killed the frameworks we studied.
- No new stages. Six is the ceiling; the pressure is toward fewer, via sizing.
- No multi-harness port before Phases 3–4 land: porting prose is cheap, porting
  enforcement and evals is the actual product, and a premature port ships the
  commodity part.
- No further investment in the Working Genius metaphor: attribution and taxonomy
  stay, the sales pitch is the receipts.
- No cross-model adversarial review, for now — the field's other rare opening
  (gstack's `/codex`), deliberately declined: it adds a second-vendor dependency
  a single-maintainer project can't carry, and Tenacity's context-isolated
  reviewer already buys most of the decorrelation. Revisit only if Phase 1
  scenario runs show the isolated reviewer repeatedly missing what a different
  model catches — that evidence would reopen this.
- No expansion of the post-mortem loop toward ECC-style auto-extracted
  "instincts": the lesson-accumulation category has four serious incumbents,
  and our three-condition promotion test is the deliberate opposite bet —
  fewer, human-legible lessons over automatic accretion. It stays as designed.
- No artifact-drift synchronization (the field's abandonment cause #4 and a
  stated unmet need), declined with its reason: work files close out at
  Tenacity and stop drifting by construction; the artifacts that *can* drift —
  the glossary and promoted `CLAUDE.md` lessons — already have their own decay
  valves (glossary collisions resolve on contact; Tenacity re-reads and prunes
  lessons at every promotion). Drift-sync becomes a phase only if dogfooding
  shows those valves failing — that evidence, not the gap's existence, is the
  entry ticket.

## Sequencing and review

Phases 1–2 are sequential (2's budgets consume 1.4's re-measurement). Phases
3–5 are independent of each other in content — but not in capacity: **at most
one extraction (Phase 3 or Phase 4) may be in flight at a time**, and starting
the second requires evidence the first is being maintained without starving the
plugin (releases still landing, issues still answered — the observable pulse
GSD and spec-kit lost before they died). Phase 5 may interleave with either;
it grows no new product. Each item is express-sized or gets its own work file
under this repo's own flow. This roadmap is a Galvanizing artifact: it gets the
same treatment as any plan — attacked before trusted, revised when reality
wins, its deviations recorded rather than improvised.
