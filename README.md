# Working Genius

A development workflow for coding agents — packaged as standard [Agent Skills](https://agentskills.io), so it runs in Claude Code, Cursor, ChatGPT/Codex, Gemini CLI, GitHub Copilot, and any other client that speaks SKILL.md. Built on one observation:

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
| The value was **located by measurement**, not assumed: with-skill vs no-plugin baseline runs found the delta only where correct practice runs *against the model's momentum* — the failing test written first (3/3 vs baseline **0/3**), the ask questioned before building (3/3 vs **0/3**) — while disciplines a careful model already follows when asked graded as honest softballs. The sentence that survived: the value is in forcing the *action* at the decision point, never in eliciting *reflection*. | `evals/RESULTS.md` (2026-07-21 synthesis); re-measuring against today's concept skills is [ROADMAP](ROADMAP.md) Phase 1 |
| The cost guidance is **measured**, not vibes — model-tiering advice traces to instrumented runs, including a rule we *reversed* when a full-flow run refuted it, kill-reason recorded | `evals/RESULTS.md` |
| The ceremony is **priced** — a measured full six-stage run cost 11× its no-plugin baseline (n=1, single task), which is why work too small for the flow stays out of it entirely rather than getting a discount | `evals/RESULTS.md` (full-flow run) |
| The interview's shape is **measured UX** — story-first, priced questions: a persona test reached a user-**confirmed** problem contract in 3 turns and ~1,000 typed characters where question-drip interviewing hit a 6-turn cap unconfirmed (n=1 per arm) | `evals/RESULTS.md` (E2E persona UX test, 2026-07-22) |

Anything in this README that sounds like a measurement should trace to a line in `evals/RESULTS.md`; if it doesn't, file an issue — that's a bug in the README.

## Install

The skills use the open [Agent Skills](https://agentskills.io) standard (SKILL.md — originally developed by Anthropic, adopted by 40+ agents; the [client showcase](https://agentskills.io/clients) links each tool's setup docs).

**Any Agent Skills client** — copy the skills into wherever your tool discovers them:

```
curl -fsSL https://raw.githubusercontent.com/donald-ada/workinggenius/main/install.sh | sh -s -- <your-skills-dir>
```

(defaults to `.claude/skills`; from a clone, `./install.sh <dir>` does the same)

**Claude Code** — one line, no clone:

```
/plugin marketplace add donald-ada/workinggenius
```

The whole thing is prose — no hooks, no runtime, nothing platform-specific to port. Two frontmatter fields (`disable-model-invocation`, `argument-hint`) are Claude Code extensions other clients ignore per the standard; the only degradation is graceful — user-invoked-only skills may become model-discoverable elsewhere. Slash commands are the Claude Code spelling: in other clients, ask for a skill by name ("run the wonder skill on this idea").

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

The flow is deliberately manual: every stage is a command you type, every checkpoint a live exchange — invoking the flow commits to the whole flow, because the checkpoints are where problems surface, and a model running on its own approval finds none of them. Work too small for six stages stays out of the flow entirely. Dropping an individual stage is your call to make — recorded as a skip, with its reason.

## How it works

**One piece of work = one markdown file** under `.genius/`. The file — not conversation memory — carries the work: the confirmed problem, the options and their kill-reasons, the slices and their acceptance criteria, the build log, the close-out evidence. Any fresh session picks up exactly where the last one stopped.

**Every stage ends at a threshold, not a checklist.** Each skill names the one thing that must be honestly true before the next stage starts — the problem confirmed, a real choice made, slices grabbable cold, evidence fresh — and trusts the model's judgment on how to get there. That bet — concepts over constraints, as model capability rises — and what it trades away are on the record in `evals/RESULTS.md`; measuring it is [ROADMAP](ROADMAP.md) Phase 1. Work files from earlier formats still read fine — they're records, and records don't expire.

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

A fresh repo gives these moves nothing to grip — so greenfield flips the direction, not the principle: when there's no history to mine, `/architect` studies the field's instead, and the systems that already solved your problem become the territory.

## Skills

**The map** (user-invoked only — the flow never hijacks work you didn't put in it):

- **/genius** — status of all work, genius-gap diagnosis, post-mortem patterns across finished work, mid-flow entry points

**The six stages** (each a command you type — the flow never advances itself):

- **/wonder** — the live interview that turns a raw idea into a user-confirmed problem: homework before questions, recommendations attached, prices on cost forks, "don't build this" a win
- **/invent** — genuinely different options on the table before anyone falls in love; no judging yet; throwaway prototypes for questions paper can't settle
- **/discern** — try to kill every option, including the favorite; choose opinionated; record the kill-reasons so rejections stay rejected
- **/galvanize** — the decision converted into slices a fresh session can grab cold, the `base:` commit recorded — and, where the repo pins issue tracking, the breakdown published as one parent issue per work with a sub-issue per slice, all under one shared label
- **/enable** — one slice per fresh context, tests leading the code, reality voting every few minutes, deviations recorded instead of improvised
- **/tenacity** — "done" as a claim about fresh evidence: everything re-run and read, a context-isolated reviewer, cleanup, commit, a post-mortem the next run reads

**Support:**

- **/architect** — the architecture fork asked honestly: adopt an existing system, or build — and if build, **one committed architecture** designed from the model's own understanding of your problem, not a menu of reference-flavored options. The field stress-tests it (diverging from a consensus needs a reason; forks your world decides come to you, priced), and you confirm consequences, not diagrams — after which Invention/Discernment are already spent: the skip is recorded and the work goes straight to slices. A command you type — Wonder and Invention recommend it where it fits, never run it for you
- **/waitwhat** — type it when an answer lost you: the re-pitch adds the missing premises and speaks the glossary's language — shorter and clearer, not shorter and blunter. A second `/waitwhat` on the same topic sends a term to the glossary: the repair loop feeds project memory
- **/blindspot** — the unknowns layer: the map is not the territory, so go look at the three moments the gap is widest — a read-only territory pass before unfamiliar work, judgment taught before a choice is extracted, a quiz that catches the user's map up with what actually changed. Driven by `/wonder`, `/discern`, and `/tenacity`; callable directly on any area
- **/setup-working-genius** — optional per-repo pinning of the work-file directory, verify commands (which `/enable` and `/tenacity` then use), and issue tracking (a parent issue per work with a sub-issue per slice, one shared label; opened at Galvanizing, closed as the work closes)
- **genius-file** (model-invoked) — the work-file discipline: the file carries the work, skips and assumptions always recorded, checkpoints always live
- **domain-glossary** (model-invoked) — the project's shared language in `CONTEXT.md`: challenge conflicting terms, sharpen fuzzy ones, record resolutions inline. Driven by `/wonder`, `/discern`, and `/waitwhat`; spoken by every other stage. Work files are per-work memory; the glossary is project memory — it compounds across all work

## Token economics

Stages differ in how much intelligence they need, and the guidance here is measured, not vibes — every number a single metered run (**n=1**, output-token pricing; `evals/RESULTS.md` states each caveat):

- **Exploration is frontier-model work** — the one tiering rule a skill encodes: the blindspot pass runs on the session's main model or better, because hunting unknown unknowns is judgment, not reading. A cheap-model pass collects the potholes already written down, then mis-calls the ones that aren't — measured, and the opposite guidance was reversed with its kill-reason recorded. The saving is in the *shape*: a fresh subagent explores, the main session consumes the report and never re-walks the files.
- **Review reads fine on a mid-tier model, scoped** — hand the reviewer the diff and the work file, not the repo. An unscoped frontier-model reviewer was the most expensive single step in measured runs ($6.55 of a $20 session) at no gain over a scoped mid-tier one.
- **Building is where the frontier model earns its rate; divergence is not building** — option sketches draft fine on a mid-tier model, because Discernment's attack is where quality gets enforced, and *that* runs on the main model.

The macro lever is the door: six stages on trivial work is the most expensive mistake available, and the answer is to keep that work out of the flow — not to run the flow shallowly, which pays the ceremony and buys nothing.

## Iterating on the plugin

Where this is heading — and the evidence that would kill it — lives in
[`ROADMAP.md`](ROADMAP.md), re-derived around the concept-first bet.

Skills are programs written in prose, and [`evals/`](evals/) holds the method for testing them: scenario against no-plugin baseline, three runs, majority, results logged. A scenario is written fresh, from the concept skills, at the moment a claim needs evidence. The standing rule: a measured claim traces to a `RESULTS.md` row, or it doesn't ship.

## Lineage

The stage model is Patrick Lencioni's *[The 6 Types of Working Genius](https://www.workinggenius.com/)*, applied to agentic development. The skill design borrows deliberately from two excellent projects:

- [mattpocock/skills](https://github.com/mattpocock/skills) — small composable skills, user- vs model-invocation, the router pattern, grilling, vertical slices, gates as checkable completion criteria — and [`/wait-what`](https://www.aihero.dev/skills-wait-what), the reader-triggered re-explain `/waitwhat` adapts (name the listener's state, not the output shape; the glossary tie-in is ours)
- [obra/superpowers](https://github.com/obra/superpowers) — the SessionStart injection, evidence-before-claims verification, workflow-as-discipline
- Thariq Shihipar's [A Field Guide to Fable: Finding Your Unknowns](https://x.com/trq212/article/2073100352921215386) — the map/territory framing, the four kinds of unknowns, the blindspot pass, teach-before-judging, and the pre-acceptance quiz (`/blindspot`)

All three are worth studying in full.

## License

MIT
