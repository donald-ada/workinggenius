---
name: setup-working-genius
description: Per-repo configuration — pin the work-file directory, verify commands, and issue tracking, seed the project docs, and leave the pointer that tells every future session this project works this way.
disable-model-invocation: true
---

# Setup Working Genius

The workflow runs on defaults (`.genius/` for work files, verify commands discovered per run, no issue mirror), so this skill is about the pointer as much as the settings: a fresh session knows none of it until an instruction file tells it. Run it once per repo, as a conversation: look first (existing `CLAUDE.md`/`AGENTS.md`, any `.genius/` in flight, the task runner, a `CONTEXT.md` or `DESIGN.md` already alive), propose what you found, let the user correct each choice.

**A — Work-file directory.** Default `.genius/` at the repo root. Recommend committing — done files are decision history every session can read. Create the directory now (a `.gitkeep` where it would be empty).

**B — Verify commands.** Propose the discovered typecheck / test / lint commands; the user corrects them. Pin each in its quiet form — `pytest -q --tb=short`, never `-v` — because a coordinator re-runs every criterion of every slice and carries each run's output in its context to the end of the work.

**C — Issue tracking.** Default off — the work file already carries the state. Pin `Issue tracking: github` when people watch progress through the tracker: Galvanizing then publishes each approved breakdown as one parent issue with a slice issue per slice, all wearing one shared `working-genius` label; Enablement closes slice issues as slices close, Tenacity closes the parent last. Issues are the work file's published mirror, never a second place to plan.

**D — Seed the project docs.** Work files are per-work memory; three homes are *project* memory, and setup is the one conversation guaranteed to happen before any of it. `.genius/DECIDED.md` needs no seeding — its lines are earned by the first decision a future stranger would re-fight (`decision-record` skill). The other two:

- **`CONTEXT.md` — the vocabulary.** Propose the handful of terms a stranger would need decoded — domain words, never general programming ones — and let the user confirm or sharpen each; write the confirmed set in the `domain-glossary` skill's format. Where the project's records will be written in a language other than English, add the flow's own names — the glossary skill lists which — each with one rendering the user confirms. Confirmed terms only: an empty skeleton is premature documentation, and an existing `CONTEXT.md` gets its `## Language` section appended, everything else left alone. A user with no patience for this declines in a word; the pointer still tells every session to grow the file as terms resolve.
- **`DESIGN.md` — the visual language.** Never scaffolded here: it is the *output* of the `/designer` conversation, and a template written without it is the model-default aesthetic it exists to prevent. Ask one question — does this project have an interface someone will see? — and the answer decides whether the pointer carries the DESIGN.md line.
- **`ARCHITECTURE.md` — the committed architecture.** The same rule: the *output* of `/architect`, never scaffolded. Where one exists, the pointer says to read it before designing across its boundaries; where the project is greenfield, the pointer routes to `/architect` first.

Three settings, and it stays three: configuration is for what a session must know and cannot infer from the repo. Preferences — how deep to interview, which style you like — are said in plain words when they matter, not switches.

## Where the pointer goes

Agents don't share one instruction file: Claude Code reads `CLAUDE.md`, most others read `AGENTS.md`. So write **both**: the section goes in `AGENTS.md`, and `CLAUDE.md` carries `@AGENTS.md` as its first line to import it. Update existing files in place and preserve everything in them. **Move** any `## Working Genius` section already in `CLAUDE.md` whole into `AGENTS.md`, lessons included, leaving only the import: two copies of these settings is worse than none, because a model reading both picks between them arbitrarily.

```markdown
## Working Genius

Work files: `.genius/` (committed)

Before starting substantial work, find that work's snapshot — `<slug>.md` inside its own folder in the
directory above. It is the work's current truth: the confirmed problem, the decision and its
kill-reasons, which contract version binds, the slices and where they stand, and `next:` naming the
exact command that moves it forward. Beside it: `<slug>.log.md`, the history, opened only if a question
needs it; `CONTRACT.md`, what binds the slices not yet built, opened when you are about to build,
attack or verify against it; and that work's own artifacts. That one folder is everything a session
needs — other slugs, in flight or done, stay closed. Anything written into a work's folder links
relative to that folder, never from the repo root. The user types `/genius` for status across all
of them and the next command; the flow is /wonder → /invent → /discern → /galvanize → /enable →
/tenacity, and every stage is a command they type.

Project docs — read before writing, improve while working:
- `CONTEXT.md`: the project's vocabulary. Name things in its terms; the moment a conversation
  resolves or collides a term, record it there inline (domain-glossary skill), never batched.
- `DESIGN.md`: the committed visual language. Read it before building anything someone will see;
  a screen that wants to break it is a conversation, not a drift. No file yet? `/designer` creates it.
- `ARCHITECTURE.md`: the committed architecture — boundaries, contracts, ranked qualities, what it
  makes cheap and dear. Read it before designing anything that crosses a boundary. Greenfield, or a
  subsystem about to be shaped? `/architect` creates it, before the first slice.
- `.genius/DECIDED.md`: the index of settled decisions, one line each, pointing at the fight that
  settled it. Read it before designing against settled ground; a decision a future stranger would
  re-fight earns its line at close-out (decision-record skill), and overturning one moves its line.
- `.genius/BACKLOG.md`: work discovered but not started. The moment one surfaces, give it one line
  here (genius-file skill); `/genius` lights these up. Order is what to do next, top to bottom.
  What leaves goes to `.genius/BACKLOG.log.md` — nothing is deleted to make this file shorter.
  `/triage` asks whether a line still belongs; `/reconcile` asks whether the code has satisfied it.
- `.genius/HISTORY.md`: one line per finished work — what it was and which genius was weakest.
  Written and read at close-out (tenacity skill), so a repeat weakness is caught without reopening
  a done work file.

Issue tracking: github

Verify commands:
- typecheck: `<command>`
- test: `<command>`
- lint: `<command>`
```

Tailor the docs list to what setup found: a project with no interface drops the `DESIGN.md` line, one whose shape is settled and unremarkable drops the `ARCHITECTURE.md` line — each doc kept carries its read-trigger and its write-trigger, because a doc nothing tells sessions to update was current once. Write it as instructions, not description — "check `.genius/` before starting" is followed; "work files live in `.genius/`" is merely true. Editing the section directly is the normal way to change these later; re-running this skill is only for starting over.
