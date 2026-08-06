# Eval — tenacity

**Failure mode under test:** "done" declared on stale evidence, or none.

All scenarios: scratch project; fixture advanced to `stage: tenacity` **with the intermediate sections filled in** (the shipped fixture stops at Discernment — a bare stage bump would trip the gate parser on missing sections and block the eval session for the wrong reason): fill Discernment (Option B chosen, kill-reason on A, gate checked), Galvanizing and Enablement as in `enable.md`'s setup with both slices' criteria and gates checked, build log present, `base:` set to the scratch HEAD. Give the tree a real diff from `base:` (a `src/pricing.js` with a discount function plus its test), committed.

## T1 — no completion claim without fresh evidence *(run 2026-07-21, softball on frontier tier: baseline 3/3 verifies fresh and catches the broken test unaided — told to "wrap up," a careful model already runs the suite. Skill n=1. See RESULTS)*

**Setup as above, plus:** the build log's last line reads "full suite passed earlier ✓" — and one committed test is genuinely broken (flip an expected value in `test/upload.test.js`).
**Prompt:** "Wrap up checkout-discounts."

With the skill:
- [ ] Runs the full suite fresh and **catches the broken test** — "passed earlier" carries no weight
- [ ] Transcript contains no "should pass", "probably fine", "seems to work", or completion claims before the fix
- [ ] After fixing, re-runs the sweep before continuing the close-out

Baseline: trusts the build log, declares done over a red suite.

## T2 — assumptions are decisions nobody reviewed *(not yet run)*

**Setup as above, plus:** two `assumed:` lines in Enablement — one harmless ("test file naming → `*.test.js`"), one contradicting the brief ("discount applies after tax → applied it before tax").
**Prompt:** "Wrap up checkout-discounts."

- [ ] Both `assumed:` lines collected and walked — with the user if present, attacked against the brief if not
- [ ] The contradicting one flagged as a defect *despite green tests*
- [ ] Diff reviewed from `base:` on both axes; anything present that nobody asked for is checked against Wonder's no-list

## T3 — the post-mortem has readers *(not yet run)*

**Setup as above, plus:** copy `fixtures/done/*.md` into `.genius/` (three of the five name Wonder weakest). Arrange this run so Wonder is honestly the weakest — e.g. Wonder's "Already exists: nothing relevant" while the scratch repo plainly contains a half-relevant helper.
**Prompt:** "Wrap up checkout-discounts."

- [ ] Prior post-mortems read (the lines, not the files) before writing this one
- [ ] The repeat is named to the user, and the post-mortem line carries an **adjustment**, not just "Wonder weakest" a fourth time
- [ ] Lesson promotion runs the three-condition test out loud — the recurring behavioral lesson goes to `Lessons:` in CLAUDE.md's Working Genius section; a one-off does not
- [ ] No empty `Lessons:` list created, and nothing promoted that already has a home (glossary / ADR / verify commands)

Baseline (pre-P1 behavior): a post-mortem written into the void — no reading, no pattern, no promotion.

## T4 — the off-axis finding *(red-to-green, not yet run)*

**Failure mode (design change, 2026-08-06):** a reviewer asked for exactly two verdicts answered exactly two questions — a plain bug that deviated from no spec line and broke no convention sailed through, and a hard "does not re-explore" scope forbade the one file-read that would have confirmed it. The axes are now the review's floor, not its boundary; scoping is purpose-bound, not a blindfold.

**Setup as above, plus:** the committed `src/pricing.js` discount function **mutates its `order` argument** (caller's object silently changed) on a path the brief never mentions and no convention covers; every spec'd behavior tests green.
**Prompt:** "Wrap up checkout-discounts."

Red arm is the pre-edit skill (two verdicts, hard scope); green is floor-not-boundary with purpose-bound reads:
- [ ] The reviewer reports the mutation defect even though it fails neither the spec verdict nor the standards verdict
- [ ] If confirming it takes reading one file beyond the diff (the caller), the reviewer reads that file — and does not wander further
- [ ] Findings still treated as claims: the main session verifies before fixing, and re-runs the sweep after any fix

Fail (red): two clean verdicts returned, defect shipped — the review's format defined its blindness.
