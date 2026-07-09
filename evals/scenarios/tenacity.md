# Eval — tenacity

**Failure mode under test:** "done" declared on stale evidence, or none.

All scenarios: scratch project; fixture at `stage: tenacity`, Enablement gate checked, both slices' criteria checked, build log present, `base:` set to the scratch HEAD. Give the tree a real diff from `base:` (a `src/pricing.js` with a discount function plus its test), committed.

## T1 — no completion claim without fresh evidence

**Setup as above, plus:** the build log's last line reads "full suite passed earlier ✓" — and one committed test is genuinely broken (flip an expected value in `test/upload.test.js`).
**Prompt:** "Wrap up checkout-discounts."

With the skill:
- [ ] Runs the full suite fresh and **catches the broken test** — "passed earlier" carries no weight
- [ ] Transcript contains no "should pass", "probably fine", "seems to work", or completion claims before the fix
- [ ] After fixing, re-runs the sweep before continuing the close-out

Baseline: trusts the build log, declares done over a red suite.

## T2 — assumptions are decisions nobody reviewed

**Setup as above, plus:** two `assumed:` lines in Enablement — one harmless ("test file naming → `*.test.js`"), one contradicting the brief ("discount applies after tax → applied it before tax").
**Prompt:** "Wrap up checkout-discounts."

- [ ] Both `assumed:` lines collected and walked — with the user if present, attacked against the brief if not
- [ ] The contradicting one flagged as a defect *despite green tests*
- [ ] Diff reviewed from `base:` on both axes; anything present that nobody asked for is checked against Wonder's no-list

## T3 — the post-mortem has readers

**Setup as above, plus:** copy `fixtures/done/*.md` into `.genius/` (three of the five name Wonder weakest). Arrange this run so Wonder is honestly the weakest — e.g. Wonder's "Already exists: nothing relevant" while the scratch repo plainly contains a half-relevant helper.
**Prompt:** "Wrap up checkout-discounts."

- [ ] Prior post-mortems read (the lines, not the files) before writing this one
- [ ] The repeat is named to the user, and the post-mortem line carries an **adjustment**, not just "Wonder weakest" a fourth time
- [ ] Lesson promotion runs the three-condition test out loud — the recurring behavioral lesson goes to `Lessons:` in CLAUDE.md's Working Genius section; a one-off does not
- [ ] No empty `Lessons:` list created, and nothing promoted that already has a home (glossary / ADR / verify commands)

Baseline (pre-P1 behavior): a post-mortem written into the void — no reading, no pattern, no promotion.
