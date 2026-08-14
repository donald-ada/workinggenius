# Work File Format

Path: `.genius/<slug>.md`, with its records in `.genius/<slug>/`. Slug is short kebab-case, named for the outcome (`checkout-discounts`, not `fix-stuff`).

The work file is a record for a cold reader, not a form. The sections below name what each stage owes the next session; the structure flexes to the work.

```markdown
---
work: checkout-discounts
stage: discernment   # wonder | invention | discernment | galvanizing | enablement | tenacity | done
created: 2026-07-03
base: <HEAD when Galvanizing wrote the plan — Tenacity diffs from here>
---

# Checkout discounts

## Wonder — the problem
The problem behind the request, confirmed in the user's own words. What already
exists, what success observably looks like, what's out of scope, parked
questions. Record: [the interview as it ran](checkout-discounts/wonder.md).

## Invention — the options
One line per path — its shape, and what it honestly costs.
Record: [every path in full](checkout-discounts/invention.md).

## Discernment — the decision
Chosen, and why — with the whole fight the chosen path came through, attack by
attack, the ones that landed and the ones it survived. A builder sizes the work
from those. One kill-reason line per rejected path.
Record: [the rejected paths' battlefields](checkout-discounts/discernment.md).

## Galvanizing — the plan
Brief, agreed test seams, numbered slices with acceptance criteria and
blockers, and the conventions the build introduces as it goes. The slice list
is the work's progress view, each line linked to what that slice took:

- [x] **Slice 1 — cart totals through the API** … — closed: [slice 1](checkout-discounts/enablement.md#slice-1)
- [ ] **Slice 2 — the discount rule editor** …

Record: [the pressure test as it ran](checkout-discounts/galvanizing.md).
When the repo tracks issues: `**Parent issue:** #N` here, `— issue: #N` on each
slice line, and the parent's task list mirrors this list rather than replacing it.

## Enablement — what carries forward
`assumed:` lines, and the edges left untested. Conventions and corrected pins
are not held here: they go into the plan above, where the next slice already
looks. Record: [each slice's evidence](checkout-discounts/enablement.md),
appended by the commit that closed it.

## Tenacity — the close-out
Findings and their resolution, one line each; a `DECIDED.md` index line for
anything settled here that a stranger would re-fight (`decision-record` skill).
Record: [the evidence as it ran](checkout-discounts/tenacity.md).

**Post-mortem:** <one line — which genius was weakest this run; if it has
been weakest before, also the adjustment>
```

- A stage that never ran has neither a section nor a record — absence is the record.
- A record is written by its stage as it runs, never assembled afterwards. Nothing moves between files later; the split is where things are written, not a filing step someone must remember.
- Every record is linked from the section it backs. A record found by convention is a record a cold session has to guess at.
- Work that ran `/architect` or `/designer` keeps the confirmed design as a section and its study as a record, same rules. The committed design language still lands in the project's own `DESIGN.md`.
- Keep entries behavioral — interfaces, contracts, criteria; no code paths or line numbers, they go stale before the next session reads them.
- Keep them short: one fact per sentence, the actor named, one term per concept. A section a cold reader must decode is a section that will be skimmed, and every close-out reads the work file whole.
- Short, never stripped. A line may hold two sentences, and the one-line records need them — a kill-reason names its attack *and* what it broke, a repeat weakness names its diagnosis *and* its adjustment. Quoted words go in as they were said.
- Files from earlier formats keep everything in one file, and may carry a narrated build log, `**Gate — <Stage>**` checklists, `mode:` frontmatter, a `**Sizing:**` line, or `> ⚠ Skipped` markers; read them as the record they are.
- **A file finishes in the shape it started.** Don't split one mid-flight. The split reads only because every record is linked from the section it backs, and a half-split file breaks exactly that: nobody can tell a section that is missing — which is the record — from a section whose record nobody linked. So an older file keeps its build log inline to the end, and there its entries are the progress marks that the plan's slice list carries here. A finished file is never converted at all; a record rewritten later is no longer what was written then, and its worth is that it is what was written then.
