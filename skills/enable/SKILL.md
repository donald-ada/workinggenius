---
name: enable
description: Build one slice at a time with red-before-green tests at the agreed seams and tight feedback loops. Use when a tracked piece of work is at its enablement stage and a slice needs building.
argument-hint: "work slug and slice number, e.g. 'checkout-discounts, slice 2'"
---

# Enablement

The genius of doing the work the work needs. Its failure mode is flying blind: code produced without feedback until a big-bang reveal at the end. Enablement keeps the loop tight — every few minutes, reality gets a vote.

Run the `genius-file` skill: read the work file. Galvanizing's gate must be checked (or skipped, recorded) before this stage begins. Identify which slice you're building — from the user's argument, or the first unblocked, unbuilt slice.

Check `CLAUDE.md` / `AGENTS.md` for pinned verify commands (typecheck, test, lint) — in a `## Working Genius` section or plainly stated anywhere else — and use them exactly. Otherwise discover them from the project's task runner once, and reuse all session. If a verify command's baseline is already dirty (pre-existing failures), record the baseline in the build log and hold the line at **no new failures** — don't adopt the dirt, don't silently fix unrelated code.

## The loop

Build the slice through red → green cycles at the seams agreed in Galvanizing:

1. **Red first.** Write one failing test at the agreed seam for the next bit of behavior. Run it. **Watch it fail** — a test you never saw red proves nothing.
2. **Green minimally.** Write just enough code to pass. No speculative parameters, no hooks for imagined futures — the acceptance criteria are the whole spec.
3. **Typecheck** after each green (and lint if the project has it fast).
4. Repeat until the slice's acceptance criteria are covered.

Rules that hold every cycle:

- **Test behavior, not implementation.** Assert through the seam's public interface; expected values come from an independent source (a known literal, a worked example), never recomputed the way the code computes them. A test that breaks under refactor while behavior held is testing the wrong thing.
- **One slice at a time.** Adjacent slices' code is out of bounds, however tempting.
- **Mock only at system boundaries** (third-party APIs, time, randomness) — never your own modules.
- **Some criteria can't be red-green** — a visual tweak, a config change, a docs page. Don't force a ceremonial test: verify by running/looking at the real thing and record *what you observed* in the build log. The rule is feedback every few minutes, not tests for their own sake.
- **Speak the project's language.** If `CONTEXT.md` exists, test names and interface vocabulary follow it.

## When the plan meets reality and loses

If the design doesn't survive contact with the code — the seam is wrong, a criterion is unbuildable, a dependency lied — **don't silently improvise**. Enablement responds to what the work actually needs: surface the problem, propose the adjustment, record the change in the work file (plan changes are decisions too), then continue. A quiet workaround today is an unexplainable diff next month.

The plan being **silent** is the same case in miniature: a value, contract, or ordering the plan never fixed. If the user is reachable, ask (with a recommendation). If not — whatever the mode — adopt your recommended answer and record it as `assumed:` in the Enablement section, flagged for review at next contact. Never let a silent gap become an invisible convention.

## Closing a slice

- Run the slice's tests plus the tests of anything it touched; read the output.
- Check off the slice's acceptance criteria **only against real command output**.
- Append to the build log: what landed, **every convention you introduced** (injection mechanisms, error orderings, body shapes, test-setup idioms — the things the next session would otherwise reverse-engineer from code), and **known untested edges**. The next session reads this instead of your mind.
- **Commit the slice, work-file update included** (message: what behavior landed). A slice that only exists in the working tree dies with the session; Tenacity reviews and can still reshape history, but every closed slice deserves to survive a crash.

More unblocked slices → tell the user the next one (fresh session recommended). All slices built → check the Enablement gate below in the work file, set `stage: tenacity`, and tell the user: next is `/tenacity`.

## Gate — Enablement

- [ ] Every slice built, red-before-green at the agreed seams (recorded exceptions — `(verify)` criteria, observed-not-tested checks — allowed)
- [ ] Every acceptance criterion checked against real output
- [ ] Every plan deviation and `assumed:` recorded in the work file
