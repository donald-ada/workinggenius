# Working Genius

A development workflow for coding agents — packaged as standard [Agent Skills](https://agentskills.io) (SKILL.md), so it runs in Claude Code, Cursor, ChatGPT/Codex, Gemini CLI, GitHub Copilot, and any other client that speaks the format. Three subagents ship inside the skills that spawn them — an inventor, a builder and a reviewer — as Claude Code plugin agents whose bodies double as briefs anywhere else. Built on one observation:

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

This plugin walks every piece of work through all six — and every stage is a command you type, so one you don't type simply doesn't run: the work file shows what ran and what didn't. Gaps stay visible instead of becoming mysteries.

## Install

**Any Agent Skills client** — the [skills CLI](https://skills.sh) auto-detects your agent and installs all 22 skills:

```
npx skills add donald-ada/workinggenius
```

**Claude Code** — one line, no install:

```
/plugin marketplace add donald-ada/workinggenius
```

No npm? The skills are plain folders — clone the repo and copy `skills/*` into wherever your agent reads them. Nothing to build, nothing to run.

On Claude Code the same folders carry three more things, ignored everywhere else: `/genius` and `/compact` count the work files before reading them, the three agents preload the discipline skills, and two prompt hooks judge the two failures the flow has measured — a coordinator that announces a dispatch and ends its turn, a builder that hands back a claim instead of evidence.

Then, in any project:

```
/genius add per-user rate limiting        # start a piece of work
/wonder                                   # correct its story, answer its questions, confirm the problem
/architect                                # (greenfield) build-or-adopt first, then one committed architecture
/designer                                 # (UI work) settle the look before the pixels
/invent                                   # genuinely diverge — alternatives exist to be beaten
/discern                                  # attack every path, commit to one, record the kills
/galvanize                                # slice into fresh-session-ready vertical slices
/enable                                   # build one slice, red-before-green, tight loops
/tenacity                                 # verify everything fresh, review, clean up, commit
```

`/genius` at any time shows where every piece of work stands and what to run next. Run `/setup-working-genius` once per repo: it pins the work-file directory, verify commands, and issue tracking, and writes the pointer that tells every future session this project works this way.

**One piece of work = one folder** at `.genius/<slug>/` — the snapshot (current truth, bounded by a character ceiling), the append-only log behind it, the contract that binds the unbuilt slices, and the work's own artifacts. The files — not conversation memory — carry the work: the confirmed problem, the options and their kill-reasons, the slices and where they stand. Any fresh session picks up exactly where the last one stopped. Not every piece of work deserves all six stages — dropping one is your call, made by not typing it; the snapshot's missing section is the record.

## Skills

**The map** (user-invoked only — the flow never hijacks work you didn't put in it):

- **/genius** — status of all work, the backlog of what the flow discovered and nobody started, genius-gap diagnosis, post-mortem patterns, mid-flow entry points

**The six stages** (each a command you type — the flow never advances itself):

- **/wonder** — the live interview that turns a raw idea into a user-confirmed problem
- **/invent** — genuine divergence before commitment: structurally different paths, each grounded in the repo
- **/discern** — try to kill every path, including the favorite; commit to one, kills on the record
- **/galvanize** — the decision converted into slices a fresh session can grab cold
- **/enable** — one slice per fresh context, tests leading the code, reality voting every few minutes
- **/tenacity** — "done" as a claim about fresh evidence: everything re-run and read, then cleanup, commit, post-mortem

**Support:**

- **/architect** — adopt an existing system or build — and if build, one committed architecture in `ARCHITECTURE.md`: qualities ranked, boundaries by ownership, stressed against the field and the future, proven by a walking skeleton, confirmed in consequences
- **/designer** — the style conversation building momentum never starts: audience first, 13 template bases, taste settled by looking at real states, accessibility computed as the floor, one committed language of tokens with roles in `DESIGN.md`
- **/waitwhat** — type it when an answer lost you: the re-pitch adds the missing premises; a repeat sends the term to the glossary
- **/blindspot** — the unknown-unknowns pass: territory before unfamiliar work, judgment before a choice, a quiz before acceptance
- **/reconcile** — the drift sweep: settled decisions, glossary terms, pinned commands and live contracts checked against the repo they describe, each finding carrying what produced it
- **/triage** — the backlog's own rules put to its lines: seeds that shouldn't still be there, pairs that are one discovery, seeds that outgrew a line, the order nobody stated — one at a time, your call
- **/distill** — retroactive log distillation for done work that closed before the rule existed: what the repo now answers leaves, what it cannot stays
- **/compact** — the compaction question put to a snapshot that drifted: what no longer constrains unfinished work is routed out, a file in some other shape brought to the format on the way, proposed before moved
- **/setup-working-genius** — per-repo pinning of directory, verify commands, and issue tracking, plus the cross-agent pointer
- **genius-file** (model-invoked) — the work-file discipline: the files carry the work, absence is the record
- **record-prose** (model-invoked) — how every record under `.genius/` is written: for a cold reader and the owner both, reasoning load-bearing, evidence as data
- **domain-glossary** (model-invoked) — the project's shared language in `CONTEXT.md`: challenge collisions, record resolutions
- **decision-record** (model-invoked) — the decision index: one line per settled decision in `.genius/DECIDED.md`, pointing at the fight that settled it
- **errata** (model-invoked) — the correction discipline: what binds is rewritten, what records is appended to, and only evidence overturns either
- **diagnose** (model-invoked) — debugging as the six geniuses at minute scale: red reproduction, plural hypotheses, fresh rerun

## License

MIT
