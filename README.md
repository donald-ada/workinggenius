# Working Genius

A development workflow for coding agents, built on one observation:

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
| The gate rule **was** code, not prose — bypasses detected mechanically. *Retired 2026-08-06, mechanical layer removed with it: each stage now names its threshold and the model is trusted with it (see `evals/RESULTS.md` for the ruling and what it trades away)* | the parser, hooks, and their 53 tests lived until `925accf` — the history is the receipt |
| The prose is **tested** against a no-plugin baseline — and the tests locate the value precisely instead of flattering it. Five scenarios run for real say it's the moments where correct practice runs *against the model's momentum*: writing the failing test first (skill 3/3, baseline **0/3**) and questioning the ask before building it (3/3 vs **0/3**) are clean wins; the gate-as-stop partial (3/3 vs 1/3); while disciplines a careful model already follows when asked — verify-before-done, history-informed sizing — are honest **softballs the baseline passes**. The axis even predicted a result before its run (W1), and bounded itself honestly when later probes (D1, a self-attack test) failed to widen it — sharpening to one sentence: the value is in forcing the *action* at the decision point, never in eliciting *reflection* a capable model already does when asked. | `evals/RESULTS.md` (2026-07-21 synthesis) — measurements of the pre-redesign prose; that scenario inventory was deleted with the prose it graded, and re-deriving the sharpest scenarios against the concept-first skills is [ROADMAP](ROADMAP.md) Phase 1 |
| The cost guidance is **measured**, not vibes — model-tiering rules trace to instrumented runs | `evals/RESULTS.md`, including the tiering rule we *reversed* when a full-flow run refuted it, kill-reason recorded |
| The ceremony is **priced** — a measured full six-stage run cost 11× its no-plugin baseline (n=1, single task). *The sizing machinery that number once justified (the express path, hands-off modes) was retired 2026-08-07 by user ruling: the flow only runs when explicitly invoked, and the invocation commits to the whole flow — cost decides what enters the flow, never how carefully a stage runs* | `evals/RESULTS.md` (full-flow run; 2026-08-07 ruling) |
| The interview is **measured UX**, not ceremony — in an end-to-end persona test the redesigned interview (story-first, question rounds, priced forks) reached a user-**confirmed** problem contract in 3 turns and ~1,000 typed characters; the pre-redesign one-question drip hit a 6-turn cap unconfirmed (n=1 per arm) | `evals/RESULTS.md` (E2E persona UX test, 2026-07-22) |

Anything in this README that sounds like a measurement should trace to a line in `evals/RESULTS.md`; if it doesn't, file an issue — that's a bug in the README.

## Quickstart

```
/plugin marketplace add donald-ada/workinggenius
```

Then, in any project:

```
/genius add per-user rate limiting        # start a piece of work
/wonder                                   # correct its story, answer its questions, confirm the problem
/invent                                   # put 2–4 structurally different options on the table
/discern                                  # attack the options, choose one, record the kill-reasons
/galvanize                                # slice into fresh-session-ready vertical slices
/enable                                   # build one slice, red-before-green, tight loops
/tenacity                                 # verify everything fresh, review, clean up, commit
```

`/genius` at any time shows where every piece of work stands and what to run next. Optional: `/setup-working-genius` pins your verify commands per repo.

The flow is deliberately manual: every stage is a command you type, every checkpoint a live exchange. There is no express tier and no hands-off mode — invoking the flow commits to the whole flow, because the checkpoints are where problems surface, and a model running on its own approval finds none of them. Work too small for six stages doesn't get a discount; it stays out of the flow. Dropping an individual stage remains your call to make — recorded as a skip, with its reason.

## How it works

**One piece of work = one markdown file** under `.genius/`. The file — not conversation memory — carries the work: the confirmed problem, the options and their kill-reasons, the slices and their acceptance criteria, the build log, the close-out evidence. Any fresh session picks up exactly where the last one stopped.

**Every stage ends at a threshold, not a checklist.** Each skill names the one thing that must be honestly true before the next stage starts — the problem confirmed, a real choice made, slices grabbable cold, evidence fresh — and trusts the model's judgment on how to get there. The detailed gate grammar, its Stop-hook enforcement, and the whole mechanical layer (`hooks/`, the parser, its 53 deterministic tests) were retired in the 2026-08 redesign — rationale and trade-offs recorded in `evals/RESULTS.md`: as model capability rises, constraints written for yesterday's models increasingly bind judgment rather than protect it. Pre-redesign work files with gate checklists still read fine — they're records, and records don't expire.

**Skips are explicit.** Not every piece of work deserves all six stages — but dropping one is the user's call, recorded *with a reason*, never silent and never bundled. When work goes wrong later, recorded skips are the first suspects — `/genius` reads them to diagnose the gap.

**`/genius` is the map** — run it any time for where every piece of work stands and what runs next; any session resuming tracked work reads its work file first (the `genius-file` skill's one discipline).

**Post-mortems compound.** Every close-out writes one line — which genius was weakest this run. That line has readers: `/tenacity` reads the earlier ones before writing (a repeat weakness must name its adjustment, not just the diagnosis), `/genius` reports the pattern across finished work and lets it bend where new work gets extra care, and a lesson that keeps recurring gets promoted — sparingly, by a three-condition test — into `CLAUDE.md`, where every future session reads it. The workflow's weakest stage is data, not a mystery.

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

- **/genius** — status of all work, genius-gap diagnosis, post-mortem patterns across finished work, mid-flow entry points

**The six stages** (each a command you type — the flow never advances itself):

- **/wonder** — the live interview that turns a raw idea into a user-confirmed problem: homework before questions, recommendations attached, prices on cost forks, "don't build this" a win
- **/invent** — genuinely different options on the table before anyone falls in love; no judging yet; throwaway prototypes for questions paper can't settle
- **/discern** — try to kill every option, including the favorite; choose opinionated; record the kill-reasons so rejections stay rejected
- **/galvanize** — the decision converted into slices a fresh session can grab cold, the `base:` commit recorded — and slices published as one issue each where the repo pins issue tracking
- **/enable** — one slice per fresh context, tests leading the code, reality voting every few minutes, deviations recorded instead of improvised
- **/tenacity** — "done" as a claim about fresh evidence: everything re-run and read, a context-isolated reviewer, cleanup, commit, a post-mortem the next run reads

**Support:**

- **/waitwhat** — type it when an answer lost you: the re-pitch adds the missing premises and speaks the glossary's language — shorter and clearer, not shorter and blunter. A second `/waitwhat` on the same topic sends a term to the glossary: the repair loop feeds project memory
- **/blindspot** — the unknowns layer: the map is not the territory, so go look at the three moments the gap is widest — a read-only territory pass before unfamiliar work, judgment taught before a choice is extracted, a quiz that catches the user's map up with what actually changed. Driven by `/wonder`, `/discern`, and `/tenacity`; callable directly on any area
- **/setup-working-genius** — optional per-repo pinning of the work-file directory, verify commands (which `/enable` and `/tenacity` then use), and issue tracking (one issue per slice, opened at Galvanizing, closed as slices close)
- **genius-file** (model-invoked) — the work-file discipline: the file carries the work, skips and assumptions always recorded, checkpoints always live
- **domain-glossary** (model-invoked) — the project's shared language in `CONTEXT.md`: challenge conflicting terms, sharpen fuzzy ones, record resolutions inline. Driven by `/wonder`, `/discern`, and `/waitwhat`; spoken by every other stage. Work files are per-work memory; the glossary is project memory — it compounds across all work

## Token economics

The flow's structure is also its cost model: stages differ in how much intelligence they need, so they shouldn't all run on the same model. Three tiering rules are now built into the skills, derived from measured runs (see `evals/RESULTS.md`). Every number in this section is a single metered run — **n=1 per cell**, output-token pricing only — so read them as directional, not statistical; the run log states each caveat, and closing that gap is [ROADMAP](ROADMAP.md) Phase 1:

- **Exploration is frontier-model work.** The blindspot territory pass hunts unknown unknowns — judgment, not reading. A cheap-model pass scores well on potholes that are already written down, then mis-calls the ones that aren't: in a measured greenfield run it recommended the exact render path the project's fixed constraint forbade, and two later frontier stages paid to correct it. Run the pass on the session's main model or better; the saving is in the *shape* — a fresh subagent explores, the main session consumes the report and never re-walks the files (findings carry their evidence for exactly this reason).
- **Review is mid-model work, and scoped.** Tenacity's reviewer judges a diff against a brief — hand it the diff and the work file, not the repo. An unscoped frontier-model reviewer was the most expensive single step in measured runs ($6.55 of a $20 session) at no gain over a scoped mid-tier one.
- **Building is where the frontier model earns its rate; divergence is not building.** Invention's parallel option drafts are sketches for Discernment to attack — mid-tier models draft them fine, because Discernment's attack is where quality gets enforced, and *that* runs on the main model.

The macro lever is the door, not a discount: six stages on trivial work is the most expensive mistake available, and the answer is to keep that work out of the flow — not to run the flow shallowly, which pays the ceremony and buys nothing. The cost levers are the scoped mid-tier reviewer, mid-tier divergence drafts, and no-re-exploration handoffs — never the pass, and never depth. An earlier revision tiered the pass down to the cheapest model on the strength of a checklist score; a full-flow run showed the cheap pass mis-calling the load-bearing constraint, and the guidance was reversed (see `evals/RESULTS.md`). Quality of the pass is upstream of every stage that follows it; pay for it.

## Iterating on the plugin

Where this is heading — and the evidence that would kill it — lives in
[`ROADMAP.md`](ROADMAP.md), re-derived around the concept-first bet.

Skills are programs written in prose, and [`evals/`](evals/) holds the method for testing them: scenario against no-plugin baseline, three runs, majority, results logged. There is no standing scenario inventory anymore — the pre-redesign one was deleted with the detailed prose it graded (git history keeps both); a scenario is written fresh, from the concept skills, at the moment a claim needs evidence. The standing rule survives the redesign: a measured claim traces to a `RESULTS.md` row, or it doesn't ship.

## Lineage

The stage model is Patrick Lencioni's *[The 6 Types of Working Genius](https://www.workinggenius.com/)*, applied to agentic development. The skill design borrows deliberately from two excellent projects:

- [mattpocock/skills](https://github.com/mattpocock/skills) — small composable skills, user- vs model-invocation, the router pattern, grilling, vertical slices, gates as checkable completion criteria — and [`/wait-what`](https://www.aihero.dev/skills-wait-what), the reader-triggered re-explain `/waitwhat` adapts (name the listener's state, not the output shape; the glossary tie-in is ours)
- [obra/superpowers](https://github.com/obra/superpowers) — the SessionStart injection, evidence-before-claims verification, workflow-as-discipline
- Thariq Shihipar's [A Field Guide to Fable: Finding Your Unknowns](https://x.com/trq212/article/2073100352921215386) — the map/territory framing, the four kinds of unknowns, the blindspot pass, teach-before-judging, and the pre-acceptance quiz (`/blindspot`)

Both are worth studying in full.

## License

MIT
