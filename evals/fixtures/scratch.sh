#!/usr/bin/env bash
# Builds the scratch project the eval scenarios run in.
# Usage: bash fixtures/scratch.sh /tmp/wg-eval
set -euo pipefail

TARGET="${1:?usage: scratch.sh <target-dir>}"
mkdir -p "$TARGET"
cd "$TARGET"
git init -q

cat > package.json <<'EOF'
{
  "name": "wg-scratch",
  "type": "module",
  "scripts": {
    "test": "node --test"
  }
}
EOF

cat > CLAUDE.md <<'EOF'
# wg-scratch

A small upload CLI used as an eval fixture.

## Working Genius

Work files: `.genius/` (committed). Flow: /wonder → /invent → /discern → /galvanize → /enable → /tenacity; type /genius for status.

Verify commands:
- test: `npm test`
EOF

mkdir -p src test

# Prior art on purpose: Wonder scenarios check the agent finds this
# instead of asking whether retry logic exists.
cat > src/http.js <<'EOF'
// Shared HTTP helpers.
export async function retry(fn, { attempts = 3, delayMs = 100 } = {}) {
  let lastErr;
  for (let i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (err) {
      lastErr = err;
      await new Promise((r) => setTimeout(r, delayMs * (i + 1)));
    }
  }
  throw lastErr;
}
EOF

cat > src/upload.js <<'EOF'
// Uploads a file to the storage endpoint. Throws on network failure.
export async function upload(path, send) {
  if (!path) throw new Error("path required");
  return send({ path });
}
EOF

cat > test/upload.test.js <<'EOF'
import { test } from "node:test";
import assert from "node:assert/strict";
import { upload } from "../src/upload.js";

test("upload sends the path", async () => {
  const sent = [];
  await upload("a.txt", async (req) => sent.push(req));
  assert.deepEqual(sent, [{ path: "a.txt" }]);
});
EOF

git add -A
git commit -qm "scratch fixture: upload CLI with retry helper and one passing test"
echo "scratch project ready at $TARGET (HEAD $(git rev-parse --short HEAD))"
