# workinggenius

This repo *is* the plugin: the skills are prose, and the evals are their tests
(`evals/README.md` holds the whole method).

## Working Genius

Work files: `.genius/` (committed)

Before changing any skill, read `.genius/DECIDED.md` — the index of this
repo's settled decisions, each line pointing at the fight that settled it. A
change that contradicts one either dies of the record or names the decision it
overturns and why — then the line moves, and the old record stays as written.

The contribution discipline, in the imperative:

- Red before green, for prose: a skill edit earns its place through a scenario
  that fails before it and passes after it — plus the skill's trigger rows in
  `evals/triggers.md`, rerun after any edit to its description.
- No number ships ahead of its `evals/RESULTS.md` entry.
- Deletion is a feature: a line no scenario can distinguish is decoration.
- The voice is part of the design: sentences survive because they change
  behavior, not because they sound right.

No verify commands — the plugin is prose-only; its tests are headless eval
runs, priced in tokens, run when a claim needs evidence.
