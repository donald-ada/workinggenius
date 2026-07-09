# Evals

Skills are programs written in prose; these are their tests. The rule this plugin enforces on your work applies to the plugin itself: **red before green**. An edit to a skill earns its place through a scenario that fails before the edit and passes after it. A line no scenario can distinguish is decoration — cut it, or find the scenario that shows what it does.

This is also what keeps the plugin's voice its own: lines survive because they change behavior, not because they sound right.

## Layout

- `triggers.md` — should-trigger / should-not-trigger prompt sets for every model-invoked skill; the near-misses are the valuable rows
- `scenarios/<skill>.md` — three behavior scenarios for each of the nine working skills (the setup wizard has none yet — an honest gap, not an oversight), each named for the failure mode it tests, each with a graded checklist
- `fixtures/` — `scratch.sh` builds the scratch project the scenarios run in; canonical work files (`checkout-discounts.md`, `done/`) the setups reference
- `gates.test.sh` — deterministic suite for the gate parser and Stop hook, the one part of the plugin that is code rather than prose; no model involved, run it directly: `bash evals/gates.test.sh`
- `RESULTS.md` — the run log; created lazily on the first recorded run

## Running a scenario

1. Build a scratch project: `bash fixtures/scratch.sh /tmp/wg-eval && cd /tmp/wg-eval`
2. Install the skills: `mkdir -p .claude/skills && cp -r <plugin-repo>/skills/* .claude/skills/`. This exercises the skills, not the hooks — and `${CLAUDE_PLUGIN_ROOT}` is unset in this mode, so the mechanical scan `/genius` and `genius-file` reach for isn't on disk; the skills' hand-scan fallback is what runs (and is what those scenarios grade). To exercise the script path and the SessionStart/Stop hooks, install the plugin for real instead.
3. Apply the scenario's **Setup** (copy fixture work files, adjust `stage:`, make the described commits).
4. Run the **Prompt** in a **fresh session** — never the session you edited skills in; leftover authoring context masks exactly the gaps you're hunting. Headless works for single-turn scenarios: `claude -p "<prompt>"` from inside the scratch project. Scenarios marked *(interactive)* need a live session.
5. Grade every checklist item against the transcript — binary, no partial credit.
6. **Baseline**: repeat in a scratch project *without* step 2. The scenario passes only when the with-skill run clears the checklist **and** the baseline exhibits the failure mode the scenario names. A baseline that behaves fine anyway is a softball — sharpen the scenario until the difference shows, or accept that the skill line it tests is a no-op.
7. **Three runs per scenario, majority rules.** Prose skills are nondeterministic; one run proves nothing in either direction.

A few scenarios test the plugin against its *own* overreach (ceremony where none is due — see `wonder.md` W3). There the baseline is the skill applied at fixed depth, and the pass is the skill scaling down.

## Trigger evals

For model-invoked skills, discovery is half the behavior: a skill that never fires is dead weight, one that fires on adjacent asks hijacks work. Run each prompt in `triggers.md` headless in the prepared scratch project and check whether the skill loaded (the transcript names a skill when it fires). Grade should-trigger and should-not-trigger rows separately — a description edit that fixes one row often breaks the other, which is the point of keeping both.

## Recording

Append one row per graded scenario to `RESULTS.md` (create the file on first use):

```markdown
| date | model | scenario | runs | with-skill | baseline-shows-failure | notes |
```

Honest grading only: a checklist item you didn't verify against the transcript is unchecked.

## When to run what

- **Editing one skill** → its scenario file plus its trigger rows, before and after the edit. Red first: confirm the current skill fails the new scenario before trusting that your edit is what fixes it.
- **Adding a scenario** → confirm the baseline failure first; a scenario born green tests nothing.
- **Full sweep** → rarely — before a release. Headless runs cost real tokens; that's why scenarios stay small and per-skill.
