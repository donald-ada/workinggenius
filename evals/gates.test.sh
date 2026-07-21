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

# --- Fixture 8: gate-block grammar under real-file mess ---------------------
# Four reproduced field bugs: a prose note between items must not end the
# block (it hid an unchecked box -> false pass); a mid-line "Gate — X" mention
# must not retarget the count; a skip line naming a gate is still a skip; a
# **Post-mortem:** line ends the block so a stray todo after it isn't counted.
P8="$TMP/p8"; mkdir -p "$P8/.genius"; cd "$P8"
mkfile .genius/messy.md <<'EOF'
---
work: messy
stage: invention
mode: guided
---
# Messy

## Wonder — the problem

**Gate — Wonder**
- [x] Problem confirmed
Note: the success-criteria box below was discussed at length.
- [ ] Success criteria are observable

## Invention — the options
EOF
out=$("$GATES" status)
check "grammar: prose note stays inside"  grep -q 'bypass:Wonder' <<<"$out"
mkfile .genius/mention.md <<'EOF'
---
work: mention
stage: discernment
mode: guided
---
# Mention

## Wonder — the problem

**Gate — Wonder**
- [x] Problem confirmed

## Invention — the options

**Gate — Invention**
- [x] Two options recorded
      — both survived the Gate — Wonder criteria review
- [ ] Costs stated

## Discernment — the decision
EOF
out=$("$GATES" status | grep '^mention')
check "grammar: mid-line mention no retarget" grep -q 'bypass:Invention' <<<"$out"
check "grammar: Wonder not falsely bypassed"  not grep -qE 'bypass:[A-Za-z,]*Wonder' <<<"$out"
mkfile .genius/skipmention.md <<'EOF'
---
work: skipmention
stage: discernment
mode: guided
---
# Skipmention

## Wonder — the problem

**Gate — Wonder**
- [x] Problem confirmed

## Invention — the options

> ⚠ Skipped — small work; Gate — Invention not needed here

## Discernment — the decision
EOF
out=$("$GATES" status | grep '^skipmention')
check "grammar: skip naming a gate is a skip" grep -q 'bypass:none' <<<"$out"
mkfile .genius/postmortem.md <<'EOF'
---
work: postmortem
stage: tenacity
mode: guided
---
# Postmortem

## Wonder — the problem

> ⚠ Skipped — test fixture

## Invention — the options

> ⚠ Skipped — test fixture

## Discernment — the decision

> ⚠ Skipped — test fixture

## Galvanizing — the plan

> ⚠ Skipped — test fixture

## Enablement — the build log

> ⚠ Skipped — test fixture

## Tenacity — the close-out

**Gate — Tenacity**
- [x] Suite run fresh
- [x] Committed

**Post-mortem:** to be written
- [ ] stray todo jotted after the close-out
EOF
out=$("$GATES" status | grep '^postmortem')
check "grammar: bold line ends the block"  grep -q 'gate:2/2' <<<"$out"

# --- Fixture 9: frontmatter values ------------------------------------------
P9="$TMP/p9"; mkdir -p "$P9/.genius"; cd "$P9"
mkfile .genius/commented.md <<'EOF'
---
work: commented
stage: wonder
mode: guided   # guided | delegated | auto — see the genius-file skill
---
# Commented

## Wonder — the problem
EOF
out=$("$GATES" status | grep '^commented')
check "frontmatter: inline comment stripped" grep -q "$(printf '\tguided\t')" <<<"$out"
check "frontmatter: no CR in output"         not grep -q "$(printf '\r')" <<<"$out"
mkfile .genius/typo.md <<'EOF'
---
work: typo
stage: enable
mode: guided
---
# Typo

## Wonder — the problem

**Gate — Wonder**
- [ ] Problem confirmed
EOF
out=$("$GATES" status | grep '^typo')
check "unknown stage: surfaced in status"   grep -q 'bypass:unrecognized-stage' <<<"$out"
rep=$("$GATES" check); rc=$?
check "unknown stage: check exits 1"        [ "$rc" -eq 1 ]
check "unknown stage: named in report"      grep -q 'typo: unrecognized stage "enable"' <<<"$rep"

# --- Fixture 10: work-dir resolution walks UP from cwd ----------------------
# A monorepo package with its own CLAUDE.md override must resolve to the
# package (the old cd-to-git-root made subdirectory projects invisible to
# both hooks); a plain subdir with no config walks up to the root's .genius.
P10="$TMP/p10"; mkdir -p "$P10"; cd "$P10"
git init -q .
mkdir -p .genius packages/app/work src
sed 's/^stage: discernment/stage: enablement/; s/^work: clean/work: rootwork/' \
  "$TMP/p1/.genius/clean.md" > .genius/rootwork.md   # bypassed at root
printf '## Working Genius\n\nWork files: `work` (committed).\n' > packages/app/CLAUDE.md
sed 's/^work: clean/work: appwork/' "$TMP/p1/.genius/clean.md" > packages/app/work/appwork.md
cd "$P10/packages/app"
check "walkup: package override wins"       [ "$("$GATES" dir)" = "work" ]
out=$("$GATES" status)
check "walkup: sees only package work"      grep -q '^appwork' <<<"$out"
check "walkup: root work not dragged in"    not grep -q 'rootwork' <<<"$out"
check "walkup: package check clean"         "$GATES" check
cd "$P10/src"
out=$("$GATES" status)
check "walkup: bare subdir finds root"      grep -q '^rootwork' <<<"$out"
cd "$P10"
out=$("$GATES" status)
check "walkup: root sees root"              grep -q '^rootwork' <<<"$out"

# --- Fixture 11: gate enforcement level resolution --------------------------
# Default is warn (the once-per-distinct-state Stop behavior). `Gate
# enforcement: block` pinned in the ## Working Genius section of
# CLAUDE.md/AGENTS.md hardens the Stop hook to re-block on every stop
# attempt. Unrecognized values resolve to warn — the same posture as no
# setting, and documented in the setup skill, not silent invention.
P11="$TMP/p11"; mkdir -p "$P11/.genius"; cd "$P11"
sed 's/^work: clean/work: hardened/; s/^stage: discernment/stage: enablement/' \
  "$TMP/p1/.genius/clean.md" > .genius/hardened.md   # bypassed
check "enforce: default is warn"        [ "$("$GATES" enforcement)" = "warn" ]
printf '## Working Genius\n\nGate enforcement: block\n' > CLAUDE.md
check "enforce: CLAUDE.md pins block"   [ "$("$GATES" enforcement)" = "block" ]
printf '## Working Genius\n\nGate enforcement: `warn`\n' > CLAUDE.md
check "enforce: backticked value read"  [ "$("$GATES" enforcement)" = "warn" ]
rm CLAUDE.md
printf '## Working Genius\n\nGate enforcement: Block\n' > AGENTS.md
check "enforce: AGENTS.md, any case"    [ "$("$GATES" enforcement)" = "block" ]
printf '## Working Genius\n\nGate enforcement: blokc\n' > AGENTS.md
check "enforce: unrecognized stays warn" [ "$("$GATES" enforcement)" = "warn" ]
printf '## Working Genius\n\nGate enforcement: block\n' > AGENTS.md

# --- Stop hook -------------------------------------------------------------
cd "$P2"  # the bypassed project
rm -f "${TMPDIR:-/tmp}"/wg-stop-gate-wgtest-*
err=$(printf '{"session_id":"wgtest-%s","cwd":"%s","hook_event_name":"Stop"}' "$$" "$P2" | "$STOP" 2>&1 >/dev/null); rc=$?
check "stop: blocks with exit 2"    [ "$rc" -eq 2 ]
check "stop: stderr names the work" grep -q 'rushed' <<<"$err"
printf '{"session_id":"wgtest-%s","cwd":"%s","hook_event_name":"Stop"}' "$$" "$P2" | "$STOP" 2>/dev/null; rc=$?
check "stop: same state reported once" [ "$rc" -eq 0 ]
# A DIFFERENT bypass in the same session must block again (the old
# once-per-session marker swallowed every later, unrelated bypass).
sed 's/^stage: discernment/stage: galvanizing/; s/^work: clean/work: second/' \
  "$TMP/p1/.genius/clean.md" > .genius/second.md
printf '{"session_id":"wgtest-%s","cwd":"%s"}' "$$" "$P2" | "$STOP" 2>/dev/null; rc=$?
check "stop: distinct bypass re-blocks" [ "$rc" -eq 2 ]
rm -f .genius/second.md
printf '{"session_id":"other-%s","cwd":"%s","stop_hook_active": true}' "$$" "$P2" | "$STOP" 2>/dev/null; rc=$?
check "stop: honors stop_hook_active" [ "$rc" -eq 0 ]
# A session id that sanitizes to nothing gets NO marker: fail toward blocking,
# never toward a machine-wide shared 'nosession' suppression.
printf '{"session_id":"!!!","cwd":"%s"}' "$P2" | "$STOP" 2>/dev/null; rc1=$?
printf '{"session_id":"!!!","cwd":"%s"}' "$P2" | "$STOP" 2>/dev/null; rc2=$?
check "stop: unusable id still blocks"  [ "$rc1$rc2" = "22" ]
cd "$P1"  # the clean project
printf '{"session_id":"wgclean-%s","cwd":"%s"}' "$$" "$P1" | "$STOP" 2>/dev/null; rc=$?
check "stop: clean project passes"  [ "$rc" -eq 0 ]
# A clean check clears the marker, so a later fresh bypass blocks again.
printf '{"session_id":"wgtest-%s","cwd":"%s"}' "$$" "$P1" | "$STOP" 2>/dev/null
printf '{"session_id":"wgtest-%s","cwd":"%s"}' "$$" "$P2" | "$STOP" 2>/dev/null; rc=$?
check "stop: clean run resets the gate" [ "$rc" -eq 2 ]

# Block mode (Fixture 11's project): the SAME bypass state re-blocks on every
# stop attempt — the once-per-distinct-state marker is warn-mode only. The
# stop_hook_active guard still wins: that is the harness's anti-loop contract,
# so block mode means "every fresh stop attempt", not an unbreakable loop.
cd "$P11"
printf '{"session_id":"wgblock-%s","cwd":"%s"}' "$$" "$P11" | "$STOP" 2>/dev/null; rc1=$?
printf '{"session_id":"wgblock-%s","cwd":"%s"}' "$$" "$P11" | "$STOP" 2>/dev/null; rc2=$?
check "stop/block: same state blocks twice" [ "$rc1$rc2" = "22" ]
err=$(printf '{"session_id":"wgblock-%s","cwd":"%s"}' "$$" "$P11" | "$STOP" 2>&1 >/dev/null)
check "stop/block: stderr names the level"  grep -q 'enforcement: block' <<<"$err"
printf '{"session_id":"wgblock-%s","cwd":"%s","stop_hook_active": true}' "$$" "$P11" | "$STOP" 2>/dev/null; rc=$?
check "stop/block: honors stop_hook_active" [ "$rc" -eq 0 ]
# Repairing the bypass releases block mode — no false positive on clean state.
sed 's/^work: clean/work: hardened/' "$TMP/p1/.genius/clean.md" > .genius/hardened.md
printf '{"session_id":"wgblock-%s","cwd":"%s"}' "$$" "$P11" | "$STOP" 2>/dev/null; rc=$?
check "stop/block: clean state passes"      [ "$rc" -eq 0 ]

rm -f "${TMPDIR:-/tmp}"/wg-stop-gate-wgtest-* "${TMPDIR:-/tmp}"/wg-stop-gate-wgclean-* "${TMPDIR:-/tmp}"/wg-stop-gate-other-* "${TMPDIR:-/tmp}"/wg-stop-gate-wgblock-*

echo
echo "passed: $pass, failed: $failed"
[ "$failed" -eq 0 ]
