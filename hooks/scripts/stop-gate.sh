#!/usr/bin/env bash
# Stop hook for the workinggenius plugin.
# The gate rule, enforced: a session may not end while tracked work sits past
# an earlier gate that is neither fully checked nor skipped — the unrecorded
# bypass that /genius calls the loudest smell. Blocks once per session: loud,
# repairable, and never a strangle-loop (recording an honest skip, checking
# the gate against reality, or moving stage: back all clear it).
set -uo pipefail

input=$(cat 2>/dev/null || true)

# Already continuing because this hook blocked — never loop on ourselves.
if printf '%s' "$input" | grep -qE '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

cwd=$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -n "$cwd" ] && [ -d "$cwd" ] && cd "$cwd"

# One block per session: the bypass gets one loud, actionable refusal; a user
# who then declines the repair is not fought turn after turn.
session_id=$(printf '%s' "$input" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
marker="${TMPDIR:-/tmp}/wg-stop-gate-${session_id:-nosession}"
[ -e "$marker" ] && exit 0

script_dir=$(cd "$(dirname "$0")" && pwd)
report=$("$script_dir/genius-gates.sh" check 2>/dev/null) && exit 0

if [ -n "$report" ]; then
  : > "$marker" 2>/dev/null || true
  {
    echo "Working Genius gate check: a stage ran past an earlier gate with no recorded skip."
    echo "$report"
    echo "Repair before stopping — one of: check the open gate items against reality (only if they are truly satisfied); record '> ⚠ Skipped — <reason>' in the bypassed stage's section; or move 'stage:' back to the unfinished stage. The workinggenius:genius-file skill has the rules. If the repair is genuinely the user's call, tell them exactly which gate items are open and stop after that."
  } >&2
  exit 2
fi
exit 0
