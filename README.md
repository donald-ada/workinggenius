# Working Genius

[![gates](https://github.com/donald-ada/workinggenius/actions/workflows/gates.yml/badge.svg)](https://github.com/donald-ada/workinggenius/actions/workflows/gates.yml)

A development workflow plugin for Claude Code, built on one observation:

> **Work doesn't fail at random. It fails at whichever stage got skipped.**

Patrick Lencioni's *Six Types of Working Genius* names the six stages every piece of work must pass through — **W**onder, **I**nvention, **D**iscernment, **G**alvanizing, **E**nablement, **T**enacity. Human teams fail when they jump from idea straight to implementation. Coding agents fail exactly the same way, just faster:

| Skipped genius | What it looks like in an agent session |
|---|---|
| **Wonder** — questioning the work | It built exactly what you asked. What you asked wasn't what you wanted. |
| **Invention** — generating options | The first plausible design became the only design. |
| **Discernment** — judging and choosing | A plausible-but-wrong approach shipped because nobody tried to kill it. |
| **Galvanizing** — mobilizing the plan | A decision everyone liked and no fresh session could start from. |
| **Enablement** — building with feedback | A huge diff, no tests, revealed big-bang at the end. |
| **Tenacity** — finishing with evidence | "Done!" — on stale evidence, or none. It was "done" three times. |

This plugin walks every piece of work through all six — and when you *do* skip one (allowed! not everything deserves six stages), the skip is recorded where the next session can see it. Gaps stay visible instead of becoming mysteries.

The six-stage shape is not the differentiator — every workflow tool ships phases, and phase names are free. What separates this plugin is a second commitment:

> **A rule that can't show its evidence doesn't ship.**

Workflow plugins are easy to write and hard to trust: prose the model can ignore, ceremony nobody priced, claims nobody measured. So this one keeps receipts, and they're checkable right now:

| Claim | Evidence |
|---|---|
| The gate rule is **code**, not prose — bypasses are detected mechanically and block the session | `hooks/scripts/genius-gates.sh` + Stop hook; 53 deterministic tests: `bash evals/gates.test.sh` |
| The prose is **tested** against a no-plugin baseline — and the tests are honest about what they find: of the first three run for real (blind- or programmatically graded), one is a clean win (red-before-green, skill 3/3 vs baseline 0/3), one a partial win (gate-as-stop, skill 3/3 vs baseline 1/3), one a **softball the baseline already passes** (advisory sizing) | `evals/RESULTS.md` (2026-07-21 synthesis); 31 scenarios, graded coverage tracked by *(not yet run)* markers — the rest is [ROADMAP](ROADMAP.md) Phase 1 |
| The cost guidance is **measured**, not vibes — model-tiering rules trace to instrumented runs | `evals/RESULTS.md`, including the tiering rule we *reversed* when a full-flow run refuted it, kill-reason recorded |
| The ceremony is **priced** — a measured full six-stage run cost 11× its no-plugin baseline (n=1, single task), which is why sizing is a recorded, priced decision and the express path exists | `evals/RESULTS.md` (full-flow run); sizing rules in `/genius` |

Anything in this README that sounds like a measurement should trace to a line in `evals/RESULTS.md`; if it doesn't, file an issue — that's a bug in the README.

## Quickstart

```
/plugin marketplace add donald-ada/workinggenius
```

Then, in any project:

```
/genius add per-user rate limiting        # start a piece of work
/wonder                                   # get interviewed until the problem is sharp
/invent                                   # put 2–4 structurally different options on the table
/discern                                  # attack the options, choose one, record the kill-reasons
/galvanize                                # slice into fresh-session-ready vertical slices
/enable                                   # build one slice, red-before-green, tight loops
/tenacity                                 # verify everything fresh, review, clean up, commit
```

`/genius` at any time shows where every piece of work stands and what to run next. Optional: `/setup-working-genius` pins your verify commands per repo.

Not everything needs the full six — and not everyone wants to babysit them:

- **`/genius express <idea>`** — small work: Wonder in one paragraph, Invention/Discernment skipped (recorded), straight to slices.
- **Modes** — `guided` (default: checkpoints as written), `delegated` (runs on its own recommendations, records every assumption, stops once — at the plan review), `auto` (no stops; for when you said "run it all"). Pick when work starts; recorded in the work file.

## How it works

**One piece of work = one markdown file** under `.genius/`. The file — not conversation memory — carries the work: the confirmed problem, the options and their kill-reasons, the slices and their acceptance criteria, the build log, the close-out evidence. Any fresh session picks up exactly where the last one stopped.

**Every stage ends in a gate** — a checklist of criteria that must be checked against reality before the next stage will start. Gates are how "the agent rushed ahead" stops happening. And the gate rule is code, not just prose: a shared parser (`hooks/scripts/genius-gates.sh`) mechanically detects any stage that ran past an earlier gate that's neither checked nor skipped; a **Stop hook** refuses to end a session while one exists, and the SessionStart hook hands the same warning to the next session. Enforcement is per-repo: `warn` (default) blocks once per distinct bypass, always naming the repair; `Gate enforcement: block` (pinned by `/setup-working-genius`) re-blocks every stop attempt until the bypass is repaired.

**Skips are explicit.** A small fix doesn't need six stages; the express path fills Wonder in one paragraph and marks Invention/Discernment skipped *with a reason*. When work goes wrong later, recorded skips are the first suspects — `/genius` reads them to diagnose the gap.

**A SessionStart hook** injects a two-line map plus your in-flight work into every session, so both you and the model always know what's mid-flight and what's next.

**Post-mortems compound.** Every close-out writes one line — which genius was weakest this run. That line has readers: `/tenacity` reads the earlier ones before writing (a repeat weakness must name its adjustment, not just the diagnosis), `/genius` reports the pattern across finished work and lets it bend sizing and mode for new work, and a lesson that keeps recurring gets promoted — sparingly, by a three-condition test — into `CLAUDE.md`, where every future session reads it. The workflow's weakest stage is data, not a mystery.

**Fresh context per slice.** Galvanizing produces slices a cold session can grab; running each slice in a new session keeps every context window sharp instead of degraded.

## Built for codebases with history

Every workflow tool demos greenfield. This one's sharpest moves feed on mess, and get better the older the repo:

- **Wonder's prior-art pass** shrinks the ask to the genuine gap — in a mature codebase the request is often half-built, and "build much less than asked" is the interview's best outcome.
- **The blindspot territory pass** mines `git log` and `git blame`: reverted commits, bug-fix clusters, FIXME middens. Where the code bit last time is the best predictor of where it bites next — evidence a greenfield project simply doesn't have yet.
- **Discernment attacks options against the record** — existing conventions, `docs/adr/` decisions, the codebase's grain — not against a blank slate.
- **The domain glossary** exists precisely because ten-year-old repos speak three dialects; it makes the collision explicit instead of letting new work pick a fourth.

A fresh repo gives these moves nothing to grip. A legacy system is where they earn their keep.

## Skills

**The map** (user-invoked only — the flow never hijacks work you didn't put in it):

- **/genius** — status of all work, sizing (express vs full flow), mode choice, genius-gap diagnosis, post-mortem patterns across finished work, mid-flow entry points

**The six stages** (type them as commands, or let the flow carry itself forward in delegated/auto mode):

- **/wonder** — the interview: one question at a time, a recommended answer with each, codebase-answerable questions never asked, depth matched to stakes — and "enough, go with your recommendations" always works
- **/invent** — divergence with rules: structurally different options, no judging yet, parallel subagents for big designs, throwaway prototypes for questions paper can't settle
- **/discern** — adversarial judgment: try to kill every option, choose opinionated, record kill-reasons, offer ADRs sparingly
- **/galvanize** — the brief, agreed test seams, tracer-bullet vertical slices with verifiable acceptance criteria, the `base:` commit Tenacity will diff against
- **/enable** — red-before-green at the agreed seams, one slice at a time, each slice committed as it closes, plan deviations surfaced instead of improvised. Given just the work slug it coordinates: one fresh subagent per slice, verified on return — no new session needed
- **/tenacity** — no completion claim without fresh evidence: line-by-line verification, one context-isolated reviewer returning both axes (spec + standards), cleanup, commit, and a post-mortem written against the previous ones — recurring lessons promoted (sparingly) to `CLAUDE.md`

**Support:**

- **/blindspot** — the unknowns layer, built on one truth: the map (your prompt, the work file, the glossary) is not the territory (the codebase and its real constraints), and the gap between them is where work fails. Three moves at the three moments the gap is widest: a read-only **territory pass** before unfamiliar work (the questions you didn't know to ask, what "good" looks like here, the potholes, a sharper ask), **teach-before-judging** when the user is confirming a choice they can't evaluate, and a **pre-acceptance quiz** that catches the user's map up with what actually changed. Driven by `/wonder`, `/discern`, and `/tenacity`; callable directly on any area
- **/setup-working-genius** — optional per-repo pinning of the work-file directory and verify commands (which `/enable` and `/tenacity` then use)
- **genius-file** (model-invoked) — the work-file discipline: format, read/write rules, the gate rule, the skip protocol, modes, the express path
- **domain-glossary** (model-invoked) — the project's shared language in `CONTEXT.md`: challenge conflicting terms, sharpen fuzzy ones, record resolutions inline. Driven by `/wonder` and `/discern`; spoken by every other stage. Work files are per-work memory; the glossary is project memory — it compounds across all work

## Token economics

The flow's structure is also its cost model: stages differ in how much intelligence they need, so they shouldn't all run on the same model. Three tiering rules are now built into the skills, derived from measured runs (see `evals/RESULTS.md`). Every number in this section is a single metered run — **n=1 per cell**, output-token pricing only — so read them as directional, not statistical; the run log states each caveat, and closing that gap is [ROADMAP](ROADMAP.md) Phase 1:

- **Exploration is frontier-model work.** The blindspot territory pass hunts unknown unknowns — judgment, not reading. A cheap-model pass scores well on potholes that are already written down, then mis-calls the ones that aren't: in a measured greenfield run it recommended the exact render path the project's fixed constraint forbade, and two later frontier stages paid to correct it. Run the pass on the session's main model or better; the saving is in the *shape* — a fresh subagent explores, the main session consumes the report and never re-walks the files (findings carry their evidence for exactly this reason).
- **Review is mid-model work, and scoped.** Tenacity's reviewer judges a diff against a brief — hand it the diff and the work file, not the repo. An unscoped frontier-model reviewer was the most expensive single step in measured runs ($6.55 of a $20 session) at no gain over a scoped mid-tier one.
- **Building is where the frontier model earns its rate; divergence is not building.** Invention's parallel option drafts are sketches for Discernment to attack — mid-tier models draft them fine, because Discernment's attack is where quality gets enforced, and *that* runs on the main model.

The macro lever remains sizing: the express path exists because six stages on small work is the most expensive mistake available. The cost levers are the scoped mid-tier reviewer, mid-tier divergence drafts, no-re-exploration handoffs, and sizing — not the pass. An earlier revision tiered the pass down to the cheapest model on the strength of a checklist score; a full-flow run showed the cheap pass mis-calling the load-bearing constraint, and the guidance was reversed (see `evals/RESULTS.md`). Quality of the pass is upstream of every stage that follows it; pay for it.

## Iterating on the plugin

Where this is heading — and what it deliberately won't become — lives in
[`ROADMAP.md`](ROADMAP.md): phased, each item with acceptance criteria, each
phase with the evidence that would kill it.

Skills are programs written in prose, and [`evals/`](evals/) holds their tests: behavior scenarios for every working skill (three or more each), each named for the failure mode it must prevent and graded against a fresh-session baseline *without* the plugin — plus should/shouldn't-trigger prompt sets for every model-invoked skill. The rule the plugin enforces on your work applies to itself: **red before green** — an edit to a skill earns its place through a scenario that failed before it and passes after it.

## Lineage

The stage model is Patrick Lencioni's *[The 6 Types of Working Genius](https://www.workinggenius.com/)*, applied to agentic development. The skill design borrows deliberately from two excellent projects:

- [mattpocock/skills](https://github.com/mattpocock/skills) — small composable skills, user- vs model-invocation, the router pattern, grilling, vertical slices, gates as checkable completion criteria
- [obra/superpowers](https://github.com/obra/superpowers) — the SessionStart injection, evidence-before-claims verification, workflow-as-discipline
- Thariq Shihipar's [A Field Guide to Fable: Finding Your Unknowns](https://x.com/trq212/article/2073100352921215386) — the map/territory framing, the four kinds of unknowns, the blindspot pass, teach-before-judging, and the pre-acceptance quiz (`/blindspot`)

Both are worth studying in full.

## License

MIT
