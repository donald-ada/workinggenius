# Work File Format

Path: `.genius/<slug>.md`. Slug is short kebab-case, named for the outcome (`checkout-discounts`, not `fix-stuff`).

```markdown
---
work: checkout-discounts
stage: discernment
mode: guided   # guided | delegated | auto — see the genius-file skill
created: 2026-07-03
base: <commit sha at Galvanizing — Tenacity reviews the diff from here>
---

# Checkout discounts

## Wonder — the problem

**Problem:** <the problem behind the request, from the user's perspective, user-confirmed>
**Success looks like:** <observable outcomes, not implementation>
**Out of scope:** <explicit no-list>
**Parked questions:** <questions deferred, with why deferring is safe>

**Gate — Wonder**
- [x] Problem statement confirmed by the user in their own words
- [x] Success criteria are observable
- [x] Out-of-scope list written
- [x] No open question blocks design
- [x] Terms resolved during the interview recorded in the glossary

## Invention — the options

### Option A — <name>
Shape: <what changes, at what interface> / Makes easy: … / Makes hard: …
Wounds: <filled in by Discernment's attack — one line per wound>

### Option B — <name>
…

**Gate — Invention**
- [x] At least two structurally different options recorded
- [x] Each option states what it makes easy and what it makes hard
- [x] Any prototype's question and answer captured; its code deleted or absorbed

## Discernment — the decision

**Chosen:** Option B — <one-line why>
**Rejected:** Option A — <the kill-reason, so it isn't re-proposed later>
**ADR:** <path, or "not warranted">

**Gate — Discernment**
- [ ] One option chosen, with reasons
- [ ] Every rejected option has a recorded kill-reason
- [ ] User confirmed the choice
- [ ] ADR written, or "not warranted" recorded

## Galvanizing — the plan

**Brief:** <2–5 sentences: problem + chosen approach, behavioral>
**Test seams:** <the agreed public interfaces tests will target>

### Slices
1. **<slice title>** — blocked by: none
   - [ ] <acceptance criterion, independently verifiable>
   - [ ] <criterion that only asserts existing behavior still holds> (verify)
2. **<slice title>** — blocked by: 1
   - [ ] …

**Gate — Galvanizing**
- [ ] Brief written — behavioral, no paths
- [ ] Test seams agreed with the user
- [ ] Every slice is a vertical cut, demoable on its own
- [ ] Every slice has independently verifiable acceptance criteria
- [ ] User approved the breakdown

## Enablement — the build log

- Slice 1: <per session: what landed; conventions introduced; known untested edges>
- assumed: <question the plan left open> → <answer adopted> (flag for review)

**Gate — Enablement**
- [ ] Every slice built, red-before-green at the agreed seams (recorded exceptions allowed)
- [ ] Every acceptance criterion checked against real output
- [ ] Every plan deviation and `assumed:` recorded in the work file

## Tenacity — the close-out

**Gate — Tenacity**
- [ ] Full test suite run fresh; output read; zero failures
- [ ] Typecheck/lint run fresh; clean
- [ ] Every acceptance criterion re-verified line by line, with evidence
- [ ] Diff reviewed on both axes (spec + standards); findings resolved
- [ ] Debug artifacts removed; prototypes deleted or absorbed
- [ ] Committed; work file marked done, post-mortem written

**Post-mortem:** <one line — which genius was weakest this run>
```

## Rules

- Sections for stages not yet reached may be absent — add them when the stage runs.
- The stage skills own the gate wording; this template mirrors them. If they ever disagree, the skill wins.
- A skipped stage keeps its heading with only the `> ⚠ Skipped — reason` line.
- Gates are append-only during a run: never delete a criterion because it's inconvenient; renegotiate it with the user and record the change.
