#!/usr/bin/env bash
# A tiny project with one piece of work at enablement: S1 closed, S2 (greet(name)) open, verify command pinned.
set -euo pipefail
git init -q .
git config user.email demo@example.com
git config user.name demo
mkdir -p .genius/demo tests
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

Before starting substantial work, find that work's snapshot: `<slug>.md` inside its own folder in the directory above. It is the work's current truth; `CONTRACT.md` beside it binds the slices not yet built; `<slug>.log.md` is the history. Anything written into a work's folder links relative to that folder. The flow is /wonder → /invent → /discern → /galvanize → /enable → /tenacity, and every stage is a command the user types.

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
A greeting module the CLI can import: `hello()` today, `greet(name)` next, both covered by unittest. Success: `python3 -m unittest discover -s tests -t . -q` green with a test per function. [Confirmed](demo.log.md#wonder)

## Decision
Chosen: plain functions in `greet.py`, because the module has no state and a class would add nothing. [The whole fight](demo.log.md#discernment)

## Contract v1
- The brief, seams, pinned values and slice criteria: [CONTRACT.md](CONTRACT.md)

## Slices
- [x] **S1 — hello()** (2026-09-23) [evidence](demo.log.md#slice-1)
- [ ] **S2 — greet(name)** — after: S1 · [criteria](CONTRACT.md#s2)

## Open
MD
cat > .genius/demo/demo.log.md <<'MD'
## wonder
2026-09-23 — the user wants a greeting module with tests; confirmed as written in the Problem section.

## discernment
2026-09-23 — plain functions chosen over a Greeter class: no state to hold.

## galvanizing
2026-09-23 — two slices, S1 hello(), S2 greet(name); the seam is the module's public functions.

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
### Tests live in `tests/`, discovered with `-s tests -t .` — S1 established, S2 reads it. [source](demo.log.md#slice-1)
MD
git add -A
git commit -qm "scaffold: a greeting module with one slice open"
