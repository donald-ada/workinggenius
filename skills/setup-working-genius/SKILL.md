---
name: setup-working-genius
description: Per-repo configuration — pin the work-file directory, verify commands, and issue tracking, and leave the pointer that tells every future session this project works this way.
disable-model-invocation: true
---

# Setup Working Genius

The workflow runs on defaults (`.genius/` for work files, verify commands discovered per run, no issue mirror), so this skill is about the pointer as much as the settings: a fresh session in a fresh context knows none of it until an instruction file tells it. Run it once per repo — after that, every session starts already knowing.

Run it as a conversation, not a script: look first (existing `CLAUDE.md`/`AGENTS.md`, any `.genius/` in flight, the project's task runner), propose what you found, let the user correct each choice.

**A — Work-file directory.** Default `.genius/` at the repo root. Commit or gitignore? Recommend committing — done files are decision history every session can read.

**B — Verify commands.** Propose the discovered typecheck / test / lint commands; the user corrects them. These are what Enablement runs each cycle and Tenacity runs fresh at close-out.

**C — Issue tracking.** Default off — the work file already carries the state. Pin `Issue tracking: github` when people watch progress through the tracker: Galvanizing then publishes each approved breakdown as one parent issue with a slice issue under it per slice, all wearing one shared `working-genius` label (one-click filter; the parent does the per-work grouping, so labels don't sprawl). Enablement closes slice issues as slices close, Tenacity sweeps orphans and closes the parent last — its open state is the work's live status. The work file stays the source of truth — issues are its published mirror, never a second place to plan. Only on needs writing.

Three settings, and it stays three: configuration is for what a session must know and cannot infer from the repo. Preferences — how deep to interview, which style you like, what tone to use — are things you say in plain words when they matter, not switches to accumulate here.

## Where the pointer goes

Agents don't share one instruction file: Claude Code reads `CLAUDE.md` and not `AGENTS.md`; most others read `AGENTS.md`. Writing to whichever already exists leaves the other half of the ecosystem blind, so write **both**: the section goes in `AGENTS.md`, and `CLAUDE.md` carries `@AGENTS.md` as its first line to import it (a symlink does the same job where the OS allows). One source of truth, every agent reading it. Update existing files in place and preserve everything already in them. **Move** any `## Working Genius` section already sitting in `CLAUDE.md` — from an earlier setup, or written by hand — whole into `AGENTS.md`, lessons included, leaving only the import behind. Two copies of these settings is worse than none: a model reading both picks between them arbitrarily.

```markdown
## Working Genius

Work files: `.genius/` (committed)

Before starting substantial work, check the work-file directory above — a file there carries the
confirmed problem, the decisions and their kill-reasons, the slices and where they stand, with each
stage's own record in the folder beside it. The user types `/genius` for status and the next command;
the flow is /wonder → /invent → /discern → /galvanize → /enable → /tenacity, and every stage is a
command they type.
Where this project keeps them: project vocabulary in `CONTEXT.md`, visual language in `DESIGN.md` —
read whichever exist before writing words or interfaces this project will keep.
Issue tracking: github

Verify commands:
- typecheck: `<command>`
- test: `<command>`
- lint: `<command>`
```

Write it as instructions, not description — "check `.genius/` before starting" is followed; "work files live in `.genius/`" is merely true. Instruction files are context, not enforcement: they make the right thing likely, never certain.

Editing the section directly is the normal way to change these later — re-running this skill is only for starting over.
