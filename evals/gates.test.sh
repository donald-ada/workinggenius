#!/usr/bin/env bash
# Deterministic tests for hooks/scripts/genius-gates.sh and stop-gate.sh.
# The gate rule became code; code gets a test suite. Run from anywhere:
#   bash evals/gates.test.sh
set -uo pipefail

PLUGIN_ROOT=$(cd "$(dirname "$0")/.." && pwd)
GATES="$PLUGIN_ROOT/hooks/scripts/genius-gates.sh"
STOP="$PLUGIN_ROOT/hooks/scripts/stop-gate.sh"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
pass=0; failed=0

check() { # check <name> <expr...>
  local name="$1"; shift
  if "$@"; then pass=$((pass + 1)); echo "PASS  $name"
  else failed=$((failed + 1)); echo "FAIL  $name"
  fi
}

mkfile() { mkdir -p "$(dirname "$1")"; cat > "$1"; }
not() { ! "$@"; }

# --- Fixture 1: clean file at discernment — earlier gates fully checked ----
P1="$TMP/p1"; mkdir -p "$P1/.genius"; cd "$P1"
mkfile .genius/clean.md <<'EOF'
---
work: clean
stage: discernment
mode: guided
---
# Clean

## Wonder — the problem
**Problem:** something confirmed.

**Gate — Wonder**
- [x] Problem statement confirmed by the user in their own words
- [x] Success criteria are observable

## Invention — the options

**Gate — Invention**
- [x] At least two structurally different options recorded
- [x] Each option states what it makes easy and what it makes hard

## Discernment — the decision

**Gate — Discernment**
- [ ] One option chosen, with reasons
- [ ] User confirmed the choice
EOF
out=$("$GATES" status)
check "clean: no bypass"            grep -q 'bypass:none' <<<"$out"
check "clean: current gate 0/2"     grep -q 'gate:0/2' <<<"$out"
check "clean: check exits 0"        "$GATES" check

# --- Fixture 2: hard bypass — at enablement over an unchecked Discernment ---
P2="$TMP/p2"; mkdir -p "$P2/.genius"; cd "$P2"
sed 's/^stage: discernment/stage: enablement/; s/^work: clean/work: rushed/' \
  "$P1/.genius/clean.md" > .genius/rushed.md
out=$("$GATES" status)
check "bypass: flagged"             grep -q 'bypass:Discernment' <<<"$out"
rep=$("$GATES" check); rc=$?
check "bypass: check exits 1"       [ "$rc" -eq 1 ]
check "bypass: report names both"   grep -q 'rushed: at enablement, but these gates are neither fully checked nor skipped: Discernment,Galvanizing' <<<"$rep"

# --- Fixture 3: express path — skips recorded, no bypass -------------------
P3="$TMP/p3"; mkdir -p "$P3/.genius"; cd "$P3"
mkfile .genius/express.md <<'EOF'
---
work: express
stage: galvanizing
mode: guided
---
# Express

## Wonder — the problem
**Problem:** small and confirmed.

**Gate — Wonder**
- [x] Problem statement confirmed by the user in their own words

## Invention — the options

> ⚠ Skipped — small work, single obvious approach

## Discernment — the decision

> ⚠ Skipped — small work, single obvious approach
EOF
check "express: skips satisfy"      "$GATES" check
out=$("$GATES" status)
check "express: no bypass in status" grep -q 'bypass:none' <<<"$out"

# --- Fixture 4: done files are ignored; missing section is a bypass --------
P4="$TMP/p4"; mkdir -p "$P4/.genius"; cd "$P4"
mkfile .genius/finished.md <<'EOF'
---
work: finished
stage: done
---
# Finished
**Post-mortem:** Wonder weakest.
EOF
mkfile .genius/gapped.md <<'EOF'
---
work: gapped
stage: discernment
mode: guided
---
# Gapped

## Wonder — the problem

**Gate — Wonder**
- [x] Problem statement confirmed by the user in their own words
EOF
out=$("$GATES" status)
check "done: not listed"            not grep -q 'finished' <<<"$out"
check "missing section: bypass"     grep -q 'bypass:Invention' <<<"$out"

# --- Fixture 5: section without a gate block → nogate, not blocking --------
P5="$TMP/p5"; mkdir -p "$P5/.genius"; cd "$P5"
mkfile .genius/nogate.md <<'EOF'
---
work: nogate
stage: invention
mode: guided
---
# Nogate

## Wonder — the problem
**Problem:** ran, but nobody wrote the gate.

## Invention — the options
EOF
out=$("$GATES" status)
check "nogate: reported"            grep -q 'nogate:Wonder' <<<"$out"
check "nogate: not a bypass"        grep -q 'bypass:none' <<<"$out"
check "nogate: check exits 0"       "$GATES" check

# --- Fixture 6: work-dir override via CLAUDE.md ----------------------------
P6="$TMP/p6"; mkdir -p "$P6/work/items"; cd "$P6"
printf '## Working Genius\n\nWork files: `work/items` (committed).\n' > CLAUDE.md
sed 's/^work: clean/work: moved/' "$P1/.genius/clean.md" > work/items/moved.md
check "override: dir resolved"      [ "$("$GATES" dir)" = "work/items" ]
check "override: file found"        grep -q '^moved' <<<"$("$GATES" status)"

# --- Fixture 7: multi-line gate items (wrapped continuation lines) ---------
# Real work files wrap gate items onto indented continuation lines and add
# inline annotations. A continuation must NOT end the gate block, or later
# boxes go uncounted — and a checked box followed by a continuation followed
# by an unchecked box would hide a real bypass from the Stop hook.
P7="$TMP/p7"; mkdir -p "$P7/.genius"; cd "$P7"
mkfile .genius/wrapped.md <<'EOF'
---
work: wrapped
stage: galvanizing
mode: guided
---
# Wrapped

## Wonder — the problem

**Gate — Wonder**
- [x] Problem statement confirmed by the user in their own words
      — confirmed verbally, quote recorded above
- [x] Success criteria are observable

## Invention — the options

**Gate — Invention**
- [x] Two structurally different options recorded
      (Option A and Option B, see above)
- [ ] Each option states what it makes easy and what it makes hard
      — Option B's "makes hard" is still blank; this box is honestly open
- [x] Any prototype captured

## Discernment — the decision

**Gate — Discernment**
- [x] One option chosen, with reasons
- [x] User confirmed the choice
EOF
out=$("$GATES" status)
# Wonder's two boxes are both checked but both wrapped; if a continuation ended
# the block early, Wonder would look unfinished and show up in bypass. It must not.
check "wrapped: wrapped checks counted"   not grep -qE 'bypass:[A-Za-z,]*Wonder' <<<"$out"
# Invention's unchecked box sits AFTER a continuation line — the dangerous case.
check "wrapped: bypass caught past cont." grep -q 'bypass:Invention' <<<"$out"
rep=$("$GATES" check); rc=$?
check "wrapped: check exits 1"            [ "$rc" -eq 1 ]
# A clean multi-line gate (all boxes checked, all wrapped) must NOT false-flag.
mkfile .genius/wrapped2.md <<'EOF'
---
work: wrapped2
stage: discernment
mode: guided
---
# Wrapped2

## Wonder — the problem

**Gate — Wonder**
- [x] Problem confirmed
      — long wrapped annotation that must not end the block early
- [x] Success criteria observable

## Invention — the options

**Gate — Invention**
- [x] Two options recorded
- [x] Costs stated
      (with a trailing continuation line)

## Discernment — the decision

**Gate — Discernment**
- [ ] One option chosen
EOF
out=$("$GATES" status | grep '^wrapped2')
check "wrapped2: earlier gates satisfied" grep -q 'bypass:none' <<<"$out"
check "wrapped2: current gate 0/1"        grep -q 'gate:0/1' <<<"$out"

# --- Stop hook -------------------------------------------------------------
cd "$P2"  # the bypassed project
rm -f "${TMPDIR:-/tmp}"/wg-stop-gate-wgtest-*
err=$(printf '{"session_id":"wgtest-%s","cwd":"%s","hook_event_name":"Stop"}' "$$" "$P2" | "$STOP" 2>&1 >/dev/null); rc=$?
check "stop: blocks with exit 2"    [ "$rc" -eq 2 ]
check "stop: stderr names the work" grep -q 'rushed' <<<"$err"
printf '{"session_id":"wgtest-%s","cwd":"%s","hook_event_name":"Stop"}' "$$" "$P2" | "$STOP" 2>/dev/null; rc=$?
check "stop: blocks once per session" [ "$rc" -eq 0 ]
printf '{"session_id":"other-%s","cwd":"%s","stop_hook_active": true}' "$$" "$P2" | "$STOP" 2>/dev/null; rc=$?
check "stop: honors stop_hook_active" [ "$rc" -eq 0 ]
cd "$P1"  # the clean project
printf '{"session_id":"wgclean-%s","cwd":"%s"}' "$$" "$P1" | "$STOP" 2>/dev/null; rc=$?
check "stop: clean project passes"  [ "$rc" -eq 0 ]
rm -f "${TMPDIR:-/tmp}"/wg-stop-gate-wgtest-* "${TMPDIR:-/tmp}"/wg-stop-gate-wgclean-* "${TMPDIR:-/tmp}"/wg-stop-gate-other-*

echo
echo "passed: $pass, failed: $failed"
[ "$failed" -eq 0 ]
