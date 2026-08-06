---
name: setup-working-genius
description: Optional per-repo configuration — pin the work-file directory, verify commands, and issue tracking so every stage runs them the same way.
disable-model-invocation: true
---

# Setup Working Genius

The workflow runs fine on defaults (`.genius/` for work files, verify commands discovered per run, no issue mirror). This skill pins those choices per repo so no session has to rediscover them. Run it once, or never.

Run it as a conversation, not a script: look first (existing `CLAUDE.md`/`AGENTS.md`, any `.genius/` in flight, the project's task runner), propose what you found, let the user correct each choice.

**A — Work-file directory.** Default `.genius/` at the repo root. Commit or gitignore? Recommend committing — done files are decision history every session can read.

**B — Verify commands.** Propose the discovered typecheck / test / lint commands; the user corrects them. These are what Enablement runs each cycle and Tenacity runs fresh at close-out.

**C — Issue tracking.** Default off — the work file already carries the state. Pin `Issue tracking: github` when people watch progress through the tracker: Galvanizing then opens one issue per approved slice before building starts, Enablement closes each as its slice closes, Tenacity sweeps for orphans. The work file stays the source of truth — issues are its published mirror, never a second place to plan. Only on needs writing.

Write the result into a `## Working Genius` section — `CLAUDE.md` if it exists, else `AGENTS.md`; if neither, ask which to create. Update an existing section in place, preserving any `Lessons:` list Tenacity has grown there.

```markdown
## Working Genius

Work files: `.genius/` (committed). Flow: /wonder → /invent → /discern → /galvanize → /enable → /tenacity; type /genius for status.
Issue tracking: github

Verify commands:
- typecheck: `<command>`
- test: `<command>`
- lint: `<command>`
```

Editing the section directly is the normal way to change these later — re-running this skill is only for starting over.
