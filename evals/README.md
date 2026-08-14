# Evals

Skills are programs written in prose; these are their tests. The rule this plugin enforces on your work applies to the plugin itself: **red before green**. An edit to a skill earns its place through a scenario that fails before the edit and passes after it. A line no scenario can distinguish is decoration — cut it, or find the scenario that shows what it does.

This is also what keeps the plugin's voice its own: lines survive because they change behavior, not because they sound right.

## Layout

- `triggers.md` — should-trigger / should-not-trigger prompt sets for every model-invoked skill; the near-misses are the valuable rows
- `fixtures/` — `scratch.sh` builds the scratch project scenarios run in; a scenario's work-file fixtures are authored with the scenario, in the current FILE-FORMAT
- `RESULTS.md` — the run log, newest entry first; every measured claim in a skill or the README should trace to an entry here

There is no standing scenario inventory: the pre-redesign one (ten files, thirty-plus scenarios, written against the detailed prose) was deleted with that prose — git history keeps both. A scenario is now written fresh, from the concept skills, at the moment a claim needs evidence: named for the failure mode it tests, graded by checklist, marked *(not yet run)* until its RESULTS entry exists.

## Running a scenario

1. Build a scratch project: `bash fixtures/scratch.sh /tmp/wg-eval && cd /tmp/wg-eval`
2. Install the skills: `mkdir -p .claude/skills && cp -r <plugin-repo>/skills/* .claude/skills/`. The plugin is prose-only since the 2026-08-06 concept-first redesign — installing the skills is installing the plugin.
3. Apply the scenario's **Setup** (write its fixture work files in the current FILE-FORMAT, set `stage:`, make the described commits).
4. Run the **Prompt** in a **fresh session** — never the session you edited skills in; leftover authoring context masks exactly the gaps you're hunting. Headless works for single-turn scenarios: `claude -p "<prompt>"` from inside the scratch project. Scenarios marked *(interactive)* need a live session.
5. Grade every checklist item against the transcript — binary, no partial credit.
6. **Baseline**: repeat in a scratch project *without* step 2 — **and strip the `## Working Genius` section from the fixture's `CLAUDE.md`**. That section documents the whole flow (Wonder → … → Tenacity); leaving it in teaches the baseline the plugin's own methodology and silently turns every scenario into a softball (measured: an M2 baseline with the section intact reproduced the skill's post-mortem-informed sizing verbatim). For slash-command prompts, the baseline uses the same ask in plain English, with **no** added invitation to reflect on process — that flatters the baseline too. The scenario passes only when the with-skill run clears the checklist **and** the clean baseline exhibits the failure mode the scenario names. A baseline that behaves fine anyway is a softball — sharpen the scenario until the difference shows, or accept that the skill line it tests is a no-op on this model tier.
7. **Three runs per scenario, majority rules.** Prose skills are nondeterministic; one run proves nothing in either direction.

Some scenarios test the plugin against its *own* overreach (ceremony where none is due). There the baseline is the skill applied at fixed depth, and the pass is the skill scaling down.

## Trigger evals

For model-invoked skills, discovery is half the behavior: a skill that never fires is dead weight, one that fires on adjacent asks hijacks work. Run each prompt in `triggers.md` headless in the prepared scratch project and check whether the skill loaded (the transcript names a skill when it fires). Grade should-trigger and should-not-trigger rows separately — a description edit that fixes one row often breaks the other, which is the point of keeping both.

## Recording

Append one dated entry to `RESULTS.md`, newest first: `## <date> — <one line: what the run showed>`, then the setup, the grades (a table where it helps), and the caveats as stated facts — run counts, fixture size, anything that bounds the claim. Every measured claim elsewhere traces to its entry here.

Honest grading only: a checklist item you didn't verify against the transcript is unchecked.

## When to run what

- **Editing one skill** → write the scenario that shows the edit's claim, plus the skill's trigger rows, before and after the edit. Red first: confirm the current skill fails the new scenario before trusting that your edit is what fixes it.
- **Adding a scenario** → confirm the baseline failure first; a scenario born green tests nothing.
- **Full sweep** → rarely — before a release. Headless runs cost real tokens; that's why scenarios stay small and per-skill.
