#!/usr/bin/env bash
# A tiny stdlib HTTP API with one piece of work whose Wonder is done: per-user rate limiting, problem confirmed, no paths yet.
set -euo pipefail
git init -q .
git config user.email demo@example.com
git config user.name demo
mkdir -p api tests .genius/ratelimit/log
: > api/__init__.py
: > tests/__init__.py
cat > api/auth.py <<'PY'
"""Resolves the caller from the Authorization header. Every public route goes through here."""

KEYS = {"key-ada": "ada", "key-bob": "bob"}


def user_for(headers):
    token = headers.get("Authorization", "").removeprefix("Bearer ")
    return KEYS.get(token)
PY
cat > api/routes.py <<'PY'
"""Public routes. Each handler takes (user, query) and returns (status, body)."""


def list_items(user, query):
    return 200, {"items": ["a", "b"], "user": user}


def search(user, query):
    return 200, {"results": [], "q": query.get("q", "")}


ROUTES = {"/items": list_items, "/search": search}
PY
cat > api/server.py <<'PY'
"""One process, one thread per request (ThreadingHTTPServer). Dispatch: auth, then the route's handler."""
import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qsl, urlsplit

from api.auth import user_for
from api.routes import ROUTES


def dispatch(path, headers):
    parts = urlsplit(path)
    handler = ROUTES.get(parts.path)
    if handler is None:
        return 404, {"error": "not found"}
    user = user_for(headers)
    if user is None:
        return 401, {"error": "unauthorized"}
    return handler(user, dict(parse_qsl(parts.query)))


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        status, body = dispatch(self.path, self.headers)
        data = json.dumps(body).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(data)


if __name__ == "__main__":
    ThreadingHTTPServer(("", 8080), Handler).serve_forever()
PY
cat > tests/test_dispatch.py <<'PY'
import unittest

from api.server import dispatch


class DispatchTest(unittest.TestCase):
    def test_items(self):
        self.assertEqual(dispatch("/items", {"Authorization": "Bearer key-ada"})[0], 200)

    def test_unauthorized(self):
        self.assertEqual(dispatch("/items", {})[0], 401)
PY
cat > CLAUDE.md <<'MD'
## Working Genius

Work files: `.genius/` (committed)

Before starting substantial work, find that work's snapshot: `<slug>.md` inside its own folder in the directory above. It is the work's current truth; the history is a tree, `<slug>.log.md` naming one branch per stage or slice under `log/`, and only the branch a question needs is opened. Anything written into a work's folder links relative to that folder. The flow is /wonder → /discern (which runs Invention first) → /galvanize → /enable → /tenacity, and every stage runs only when the user types its command.

Verify commands:
- test: `python3 -m unittest discover -s tests -t . -q`
MD
cat > .genius/ratelimit/ratelimit.md <<'MD'
---
work: ratelimit
stage: wonder
created: 2026-09-25
next: /discern ratelimit
---

# Per-user rate limiting

## Problem
One user's script hammered `/search` last week and slowed the API for everyone. The user's words: "each API key gets 60 requests a minute across all routes; the 61st gets a 429 with a Retry-After header, and nobody else notices." Success, by their own measure: a test that fires 61 requests for one key inside a minute sees exactly one 429 carrying Retry-After, and a second key in the same minute sees none. Scope: the public routes in `api/routes.py`. Out of scope: per-route limits, billing tiers. It runs as one process today; a second process behind a load balancer is planned for next quarter. [Confirmed](log/wonder.md#wonder)

## Open
MD
cat > .genius/ratelimit/ratelimit.log.md <<'MD'
- [wonder](log/wonder.md) — 2026-09-25 — the interview that confirmed the problem
MD
cat > .genius/ratelimit/log/wonder.md <<'MD'
## wonder
2026-09-25 — asked what "per-user" means: per API key. Asked the limit: 60 a minute, all routes together. Asked about the second process: planned next quarter, "don't build for it yet, but don't make it a rewrite either". Confirmed: "yes, that's it."
MD
git add -A
git commit -qm "scaffold: a small API with rate limiting confirmed at Wonder"
