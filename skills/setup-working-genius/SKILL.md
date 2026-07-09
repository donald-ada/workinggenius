---
name: setup-working-genius
description: Optional per-repo configuration — pin the work-file directory and verify commands so every stage runs them the same way.
disable-model-invocation: true
---

# Setup Working Genius

The workflow runs fine on defaults (`.genius/` for work files, verify commands discovered per run). This skill pins those choices per repo so no session has to rediscover them. Run it once, or never.

This is a prompt-driven skill: explore, present findings, confirm each decision with the user one at a time, then write.

## Process

### 1. Explore

- `CLAUDE.md` / `AGENTS.md` at the repo root — which exists? Is there already a `## Working Genius` section?
- `.genius/` — any work files already in flight?
- The project's task runner (`package.json` scripts, `Makefile`, `justfile`, `pyproject.toml`, …) — find the likely typecheck, test, and lint commands.

### 2. Ask, one decision at a time

**A — Work-file directory.** Default `.genius/` at the repo root. Also ask: commit work files or gitignore them? Recommend committing — done files are decision history, and gates only bind what's visible to every session.

**B — Verify commands.** Propose the discovered typecheck / test / lint commands; let the user correct them. These are what Enablement runs each cycle and Tenacity runs fresh at close-out.

### 3. Write

Pick the file: `CLAUDE.md` if it exists, else `AGENTS.md` if it exists; if neither, ask which to create — never create one when the other already exists. If a `## Working Genius` section already exists, update it in place — don't append a duplicate, and preserve any `Lessons:` list Tenacity has grown there (it's project memory, not setup output).

```markdown
## Working Genius

Work files: `.genius/` (committed). Flow: /wonder → /invent → /discern → /galvanize → /enable → /tenacity; type /genius for status.

Verify commands:
- typecheck: `<command>`
- test: `<command>`
- lint: `<command>`
```

Don't seed a `Lessons:` list — Tenacity creates it lazily, the first time a lesson recurs across work and earns promotion.

If the user chose gitignore, add the directory to `.gitignore`.

### 4. Done

Tell the user setup is complete, and that editing the `## Working Genius` section directly is the normal way to change these later — re-running this skill is only for starting over.
