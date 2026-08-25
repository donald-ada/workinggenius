# Working Genius — repository instructions

This repository is the Working Genius plugin itself: the Agent Skills under `skills/`, distributed through the Claude Code plugin marketplace and the skills CLI.

## Releasing

Any change under `skills/` or `.claude-plugin/` that merges to `main` bumps `version` in `.claude-plugin/plugin.json` in the same PR. Marketplace clients detect updates only through that version — a merge without a bump ships behavior no installer can pull. If `skills/` gained or lost a skill, the count in README.md's install line moves with it.

## Conventions

- Skills are prose, and the repo stays that way: no runtime, no scripts, no state a fork can't carry.
- Every rule a skill states carries its why; a constraint that can't name its reason doesn't land.
- Killed designs stay killed unless new evidence reopens them. Before proposing express paths, sizing calls, autonomy modes, gate checklists, or skip bookkeeping, read the git history — each was removed by a recorded ruling that names its kill-reason.
