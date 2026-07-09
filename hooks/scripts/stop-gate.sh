#!/usr/bin/env bash
# Stop hook for the workinggenius plugin.
# The gate rule, enforced: a session may not end while tracked work sits past
# an earlier gate that is neither fully checked nor skipped — the unrecorded
# bypass that /genius calls the loudest smell. Blocks once per DISTINCT bypass
# state: the marker stores a fingerprint of the check report, so a repaired
# bypass followed by a new, different one blocks again, while re-stopping on
# the same already-reported state passes. A clean check clears the marker.
set -uo pipefail

input=$(cat 2>/dev/null || true)

# Already continuing because this hook blocked — never loop on ourselves.
if printf '%s' "$input" | grep -qE '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

# Field extraction: FIRST occurrence only (a greedy .* would bind to the last,
# which any echoed JSON in the payload could poison), then sanitize hard.
json_field() {
  printf '%s' "$input" \
    | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 \
    | sed 's/^[^:]*:[[:space:]]*"//; s/"$//'
}

cwd=$(json_field cwd)
[ -n "$cwd" ] && [ -d "$cwd" ] && cd "$cwd"

# Sanitized session id; empty means "no safe marker key" — in that case we use
# no marker at all and fail toward blocking (a repeated warning is annoying;
# a machine-wide shared marker silently killing the gate is worse).
sid=$(json_field session_id | tr -cd 'A-Za-z0-9._-')

script_dir=$(cd "$(dirname "$0")" && pwd)
report=$("$script_dir/genius-gates.sh" check 2>/dev/null)
rc=$?

marker=""
[ -n "$sid" ] && marker="${TMPDIR:-/tmp}/wg-stop-gate-${sid}"

if [ "$rc" -eq 0 ] || [ -z "$report" ]; then
  [ -n "$marker" ] && rm -f "$marker" 2>/dev/null
  exit 0
fi

state=$(printf '%s' "$report" | cksum | tr -d ' \t')
if [ -n "$marker" ] && [ -f "$marker" ] && [ "$(cat "$marker" 2>/dev/null)" = "$state" ]; then
  exit 0   # this exact bypass state was already reported this session
fi
[ -n "$marker" ] && printf '%s' "$state" > "$marker" 2>/dev/null

{
  echo "Working Genius gate check failed:"
  echo "$report"
  echo "Repair before stopping — one of: check the open gate items against reality (only if they are truly satisfied); record '> ⚠ Skipped — <reason>' in the bypassed stage's section; or move 'stage:' back to the unfinished stage. The workinggenius:genius-file skill has the rules. If the repair is genuinely the user's call, tell them exactly which gate items are open and stop after that."
} >&2
exit 2
