---
name: setup-working-genius
description: Per-repo configuration — pin the work-file directory, verify commands, and issue tracking, seed the project docs, and leave the pointer that tells every future session this project works this way.
disable-model-invocation: true
---

# Setup Working Genius

The workflow runs on defaults (`.genius/` for work files, verify commands discovered per run, no issue mirror), so this skill is about the pointer as much as the settings: a fresh session in a fresh context knows none of it until an instruction file tells it. Run it once per repo — after that, every session starts already knowing.

Run it as a conversation, not a script: look first (existing `CLAUDE.md`/`AGENTS.md`, any `.genius/` in flight, the project's task runner, a `CONTEXT.md` or `DESIGN.md` already alive), propose what you found, let the user correct each choice.

**A — Work-file directory.** Default `.genius/` at the repo root. Commit or gitignore? Recommend committing — done files are decision history every session can read. Create the directory now (a `.gitkeep` when it would otherwise be empty): pinned and present beats pinned and promised.

**B — Verify commands.** Propose the discovered typecheck / test / lint commands; the user corrects them. These are what Enablement runs each cycle and Tenacity runs fresh at close-out.

**C — Issue tracking.** Default off — the work file already carries the state. Pin `Issue tracking: github` when people watch progress through the tracker: Galvanizing then publishes each approved breakdown as one parent issue with a slice issue under it per slice, all wearing one shared `working-genius` label (one-click filter; the parent does the per-work grouping, so labels don't sprawl). Enablement closes slice issues as slices close, Tenacity sweeps orphans and closes the parent last — its open state is the work's live status. The work file stays the source of truth — issues are its published mirror, never a second place to plan. Only on needs writing.

**D — Seed the project docs.** Work files are per-work memory; three homes are *project* memory, compounding across all future work — and setup is the one conversation guaranteed to happen before any of it, so the ground is prepared here rather than left to whichever session happens to notice. `.genius/DECIDED.md` needs no seeding — its lines are earned, written by the first decision a future stranger would re-fight (`decision-record` skill); the pointer alone prepares it. The other two:

- **`CONTEXT.md` — the vocabulary.** Exploration already read the README and the code's load-bearing names; propose the handful of terms a stranger would need decoded — domain words, never general programming ones — and let the user confirm or sharpen each definition. Write the confirmed set in the `domain-glossary` skill's format. Confirmed terms only: an empty skeleton is premature documentation, and a `CONTEXT.md` that already exists gets its `## Language` section appended, everything else left alone (the glossary skill's don't-hijack rule). A user with no patience for this right now declines in a word — the pointer below still tells every session to grow the file as terms resolve.
- **`DESIGN.md` — the visual language.** Never scaffolded here: it is the *output* of the `/designer` taste conversation, and a template written without that conversation is exactly the model-default aesthetic it exists to prevent. Ask one question — does this project have an interface someone will see? The answer decides whether the pointer carries the DESIGN.md line: read the file before building screens when it exists, route to `/designer` before pixels when it doesn't.

Three settings, and it stays three: configuration is for what a session must know and cannot infer from the repo. D adds no switch — it turns the files the pointer names into files that exist. Preferences — how deep to interview, which style you like, what tone to use — are things you say in plain words when they matter, not switches to accumulate here.

## Where the pointer goes

Agents don't share one instruction file: Claude Code reads `CLAUDE.md` and not `AGENTS.md`; most others read `AGENTS.md`. Writing to whichever already exists leaves the other half of the ecosystem blind, so write **both**: the section goes in `AGENTS.md`, and `CLAUDE.md` carries `@AGENTS.md` as its first line to import it (a symlink does the same job where the OS allows). One source of truth, every agent reading it. Update existing files in place and preserve everything already in them. **Move** any `## Working Genius` section already sitting in `CLAUDE.md` — from an earlier setup, or written by hand — whole into `AGENTS.md`, lessons included, leaving only the import behind. Two copies of these settings is worse than none: a model reading both picks between them arbitrarily.

```markdown
## Working Genius

Work files: `.genius/` (committed)

Before starting substantial work, find that work's snapshot — `<slug>.md` inside its own folder in the
directory above, or, for work written before the folder layout, sitting directly in that directory.
That snapshot is the work's current truth: the confirmed problem, the decision
and its kill-reasons, which contract version binds, the slices and where they stand, and `next:` naming
the exact command that moves it forward. Beside it in the same folder: `<slug>.log.md`, the history,
opened only if a question needs it; `CONTRACT.md`, what binds the slices not yet built, opened when you
are about to build, attack or verify against it; and that work's own artifacts. That one folder is
everything a session needs to start or resume its own work — other slugs, in flight or done, stay
closed, so the directory can hold any number without costing this session more. Anything you write into
a work's folder — log anchors, `CONTRACT.md`, its artifacts — links relative to that folder, never from
the repo root. The user types
`/genius` for status across all of them and the next command; the flow is
/wonder → /invent → /discern → /galvanize → /enable → /tenacity, and every stage is a command
they type.

Project docs — read before writing, improve while working:
- `CONTEXT.md`: the project's vocabulary. Name things in its terms; the moment a conversation
  resolves or collides a term, record it there inline (domain-glossary skill), never batched at
  the end of the work.
- `DESIGN.md`: the committed visual language. Read it before building anything someone will see —
  screens speak it, and a screen that wants to break it is a conversation, not a drift. No file
  yet? `/designer` creates it, before pixels.
- `.genius/DECIDED.md`: the index of settled decisions — one line per decision, pointing at the
  fight that settled it. Read it before designing against settled ground; a decision a future
  stranger would re-fight earns its line at close-out (decision-record skill), and overturning
  one moves its line to the new fight — the old record stays as written.
- `.genius/BACKLOG.md`: work discovered but not started — an edge worth testing, a refactor
  worth doing, spotted mid-work. The moment one surfaces, give it one line here (genius-file
  skill); `/genius` lights these up, so nothing worth doing depends on someone remembering it.
- `.genius/HISTORY.md`: one line per finished work — what it was and which genius was weakest
  that run. Written at close-out (tenacity skill), read there too, so a repeat weakness is
  caught without reopening a single done work file.

Issue tracking: github

Verify commands:
- typecheck: `<command>`
- test: `<command>`
- lint: `<command>`
```

Tailor the docs list to what setup found: a project with no interface anyone sees drops the `DESIGN.md` line rather than carrying a dead instruction — the list names the docs this project actually keeps, each with its read-trigger and its write-trigger, because a doc nothing tells sessions to update is a doc that was current once.

Write it as instructions, not description — "check `.genius/` before starting" is followed; "work files live in `.genius/`" is merely true. Instruction files are context, not enforcement: they make the right thing likely, never certain.

Editing the section directly is the normal way to change these later — re-running this skill is only for starting over.
