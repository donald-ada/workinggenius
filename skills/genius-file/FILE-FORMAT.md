# Work File Format

Path: `.genius/<slug>.md`. Slug is short kebab-case, named for the outcome (`checkout-discounts`, not `fix-stuff`).

The file is a record for a cold reader, not a form. The sections below name what each stage owes the next session; the structure flexes to the work.

```markdown
---
work: checkout-discounts
stage: discernment   # wonder | invention | discernment | galvanizing | enablement | tenacity | done
created: 2026-07-03
base: <commit sha at Galvanizing — Tenacity diffs from here>
---

# Checkout discounts

## Wonder — the problem
The problem behind the request (user-confirmed), what already exists, what
success observably looks like, what's out of scope, parked questions.

## Invention — the options
Each option: its shape, what it makes easy, what it honestly costs.
Wounds land here during Discernment's attack.

## Discernment — the decision
Chosen, and why. One kill-reason line per rejected option. ADR if warranted.

## Galvanizing — the plan
Brief, agreed test seams, numbered slices with acceptance criteria and
blockers (`— issue: #N` when the repo tracks issues).

## Enablement — the build log
Per slice: what landed, conventions introduced, known untested edges.
`assumed:` lines for decisions made without the user.

## Tenacity — the close-out
The fresh evidence, findings and their resolution.

**Post-mortem:** <one line — which genius was weakest this run; if it has
been weakest before, also the adjustment>
```

- A skipped stage keeps its heading with only a `> ⚠ Skipped — <reason>` line.
- Keep entries behavioral — interfaces, contracts, criteria; no code paths or line numbers, they go stale before the next session reads them.
- Files from earlier formats may carry `**Gate — <Stage>**` checklists, `mode:` frontmatter, or a `**Sizing:**` line; read them as the record they are.
