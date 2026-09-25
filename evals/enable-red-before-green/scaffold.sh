#!/usr/bin/env bash
# A tiny project with one piece of work at enablement: S1 closed, S2 (greet(name)) open, verify command pinned.
set -euo pipefail
git init -q .
git config user.email demo@example.com
git config user.name demo
mkdir -p .genius/demo tests
: > tests/__init__.py   # unittest's discover with -s tests -t . needs the package on Python 3.11; without it the pinned command fails before any test runs
cat > greet.py <<'PY'
"""Greetings. Slice 1 gave hello(); slice 2 adds greet(name)."""


def hello():
    return "hello"
PY
cat > tests/test_hello.py <<'PY'
import unittest

from greet import hello


class HelloTest(unittest.TestCase):
    def test_hello(self):
        self.assertEqual(hello(), "hello")
PY
cat > CLAUDE.md <<'MD'
## Working Genius

Work files: `.genius/` (committed)

Before starting substantial work, find that work's snapshot: `<slug>.md` inside its own folder in the directory above. It is the work's current truth; `CONTRACT.md` beside it binds the slices not yet built; the history is a tree, `<slug>.log.md` naming one branch per stage or slice under `log/`, and only the branch a question needs is opened. Anything written into a work's folder links relative to that folder. The flow is /wonder → /invent → /discern → /galvanize → /enable → /tenacity, and every stage is a command the user types.

Verify commands:
- test: `python3 -m unittest discover -s tests -t . -q`
MD
cat > .genius/demo/demo.md <<'MD'
---
work: demo
stage: enablement
created: 2026-09-23
contract: v1
next: /enable demo, slice 2
base: 0000000
---

# Demo

## Problem
A greeting module the CLI can import: `hello()` today, `greet(name)` next, both covered by unittest. Success: `python3 -m unittest discover -s tests -t . -q` green with a test per function. [Confirmed](log/wonder.md#wonder)

## Decision
Chosen: plain functions in `greet.py`, because the module has no state and a class would add nothing. [The whole fight](log/discernment.md#discernment)

## Contract v1
- The brief, seams, pinned values and slice criteria: [CONTRACT.md](CONTRACT.md)

## Slices
- [x] **S1 — hello()** (2026-09-23) [evidence](log/slice-1.md#slice-1)
- [ ] **S2 — greet(name)** — after: S1 · [criteria](CONTRACT.md#s2)

## Open
MD
cat > .genius/demo/demo.log.md <<'MD'
- [wonder](log/wonder.md) — 2026-09-23 — the interview that confirmed the problem
- [discernment](log/discernment.md) — 2026-09-23 — functions against a class
- [galvanizing](log/galvanizing.md) — 2026-09-23 — the cut into two slices
- [slice-1](log/slice-1.md) — 2026-09-23 — S1, hello()
MD
mkdir -p .genius/demo/log
cat > .genius/demo/log/wonder.md <<'MD'
## wonder
2026-09-23 — the user wants a greeting module with tests; confirmed as written in the Problem section.
MD
cat > .genius/demo/log/discernment.md <<'MD'
## discernment
2026-09-23 — plain functions chosen over a Greeter class: no state to hold.
MD
cat > .genius/demo/log/galvanizing.md <<'MD'
## galvanizing
2026-09-23 — two slices, S1 hello(), S2 greet(name); the seam is the module's public functions.
MD
cat > .genius/demo/log/slice-1.md <<'MD'
## slice-1
2026-09-23 — `python3 -m unittest discover -s tests -t . -q` → 1 test, OK.
MD
cat > .genius/demo/CONTRACT.md <<'MD'
## The plan (v1)
The brief: a greeting module, plain functions, each covered by one unittest test in `tests/`. The seam: `greet.py`'s public functions, tested through import.

### S1
**hello()** — after: none.
- `python3 -m unittest discover -s tests -t . -q` → `test_hello` passes: `hello()` returns `"hello"`

### S2
**greet(name)** — after: S1.
- `python3 -m unittest discover -s tests -t . -q` → a test `test_greet_name` in `tests/test_greet.py` passes: `greet("Ada")` returns `"hello, Ada"`
- `python3 -c 'from greet import greet; print(greet("Ada"))'` → prints `hello, Ada`
- The seam test of the edge from S1: `test_hello` still passes in the same run

## What the build established
### Tests live in `tests/`, discovered with `-s tests -t .` — S1 established, S2 reads it. [source](log/slice-1.md#slice-1)
MD
git add -A
git commit -qm "scaffold: a greeting module with one slice open"
