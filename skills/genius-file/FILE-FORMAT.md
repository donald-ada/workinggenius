# Work File Format

Path: `.genius/<slug>.md`. Slug is short kebab-case, named for the outcome (`checkout-discounts`, not `fix-stuff`).

```markdown
---
work: checkout-discounts
stage: discernment
created: 2026-07-03
---

# Checkout discounts

## Wonder — the problem

**Problem:** <the problem behind the request, from the user's perspective, user-confirmed>
**Success looks like:** <observable outcomes, not implementation>
**Out of scope:** <explicit no-list>
**Parked questions:** <questions deferred, with why deferring is safe>

**Gate — Wonder**
- [x] Problem statement confirmed by the user
- [x] Success criteria are observable
- [x] Out-of-scope list written
- [x] No open question blocks design

## Invention — the options

### Option A — <name>
Shape: <what changes, at what interface> / Makes easy: … / Makes hard: …

### Option B — <name>
…

**Gate — Invention**
- [x] At least two structurally different options recorded
- [x] Each option states what it makes easy and what it makes hard

## Discernment — the decision

**Chosen:** Option B — <one-line why>
**Rejected:** Option A — <the kill-reason, so it isn't re-proposed later>
**ADR:** <path, or "not warranted">

**Gate — Discernment**
- [ ] One option chosen, with reasons
- [ ] Every rejected option has a recorded kill-reason
- [ ] User confirmed the choice

## Galvanizing — the plan

**Brief:** <2–5 sentences: problem + chosen approach, behavioral>
**Test seams:** <the agreed public interfaces tests will target>

### Slices
1. **<slice title>** — blocked by: none
   - [ ] <acceptance criterion, independently verifiable>
   - [ ] <acceptance criterion>
2. **<slice title>** — blocked by: 1
   - [ ] …

**Gate — Galvanizing**
- [ ] Every slice is a vertical cut, demoable on its own
- [ ] Every slice has testable acceptance criteria
- [ ] Test seams agreed with the user

## Enablement — the build log

- Slice 1: <status — one line per session that touched it>

**Gate — Enablement**
- [ ] Every slice built, red-before-green at the agreed seams
- [ ] Every acceptance criterion checked against real output

## Tenacity — the close-out

**Gate — Tenacity**
- [ ] Full test suite run fresh; output read; zero failures
- [ ] Typecheck/lint run fresh; clean
- [ ] Every acceptance criterion re-verified line by line, with evidence
- [ ] Diff reviewed against the brief (spec) and repo conventions (standards)
- [ ] Debug artifacts removed; prototypes deleted or absorbed
- [ ] Committed

**Post-mortem:** <one line — which genius was weakest this run>
```

## Rules

- Sections for stages not yet reached may be absent — add them when the stage runs.
- A skipped stage keeps its heading with only the `> ⚠ Skipped — reason` line.
- Gates are append-only during a run: never delete a criterion because it's inconvenient; renegotiate it with the user and record the change.
