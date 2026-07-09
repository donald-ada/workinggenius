#!/usr/bin/env bash
# Deterministic gate scanner for Working Genius work files.
# The single parser behind the SessionStart hook, the Stop gate, and /genius —
# so "is a gate bypassed?" is answered mechanically, never by skimming prose.
#
# Usage:
#   genius-gates.sh status   one line per in-flight work file, tab-separated:
#                            slug  stage  mode  gate:<checked>/<total>|-  bypass:<Stages>|none  nogate:<Stages>|none
#   genius-gates.sh check    bypass report on stdout; exit 1 if any bypass
#   genius-gates.sh dir      print the resolved work-file directory
#
# A stage counts as satisfied when its gate block exists with every box
# checked, or its section carries a "Skipped" line. A stage EARLIER than the
# file's current stage that is neither → bypass (the section is missing
# entirely, or its gate has unchecked boxes). A section that ran without any
# gate block is reported as nogate: — suspicious, surfaced, but not blocking.
set -euo pipefail

cmd="${1:-status}"

# Hooks run in the session cwd, which may be a subdirectory.
root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$root"

WORK_DIR=".genius"
for f in CLAUDE.md AGENTS.md; do
  [ -f "$f" ] || continue
  override=$(sed -n 's/^Work files:[[:space:]]*`\([^`]*\)`.*/\1/p' "$f" | head -1)
  if [ -n "$override" ]; then
    WORK_DIR="${override%/}"
    break
  fi
done

if [ "$cmd" = "dir" ]; then
  printf '%s\n' "$WORK_DIR"
  exit 0
fi

[ -d "$WORK_DIR" ] || exit 0

fail=0
for f in "$WORK_DIR"/*.md; do
  [ -e "$f" ] || continue
  stage=$(sed -n 's/^stage:[[:space:]]*//p' "$f" | head -1 | tr -d '\r' | tr '[:upper:]' '[:lower:]' | awk '{print $1}')
  mode=$(sed -n 's/^mode:[[:space:]]*//p' "$f" | head -1 | awk '{print $1}')
  [ -z "$stage" ] && continue
  [ "$stage" = "done" ] && continue
  slug=$(basename "$f" .md)

  verdict=$(awk -v stage="$stage" '
    BEGIN {
      n = split("wonder invention discernment galvanizing enablement tenacity", ord, " ")
      for (i = 1; i <= n; i++) {
        idx[ord[i]] = i
        Name[i] = toupper(substr(ord[i], 1, 1)) substr(ord[i], 2)
      }
      cur = (stage in idx) ? idx[stage] : 0
      sec = ""; gate = ""
    }
    /^## / {
      if ($0 ~ /Gate — /) {
        for (i = 1; i <= n; i++) if (index($0, "Gate — " Name[i]) > 0) gate = ord[i]
        next
      }
      sec = ""; gate = ""
      for (i = 1; i <= n; i++) if (index($0, "## " Name[i]) == 1) sec = ord[i]
      if (sec != "") seen[sec] = 1
      next
    }
    {
      if ($0 ~ /Gate — /) {
        g = ""
        for (i = 1; i <= n; i++) if (index($0, "Gate — " Name[i]) > 0) g = ord[i]
        if (g != "") { gate = g; next }
      }
      if (sec != "" && $0 ~ /^>/ && $0 ~ /Skipped/) { skipped[sec] = 1; next }
      if (gate != "") {
        if ($0 ~ /^- \[[xX]\]/)      { total[gate]++; checked[gate]++ }
        else if ($0 ~ /^- \[ \]/)    { total[gate]++ }
        else if ($0 != "" && $0 !~ /^[[:space:]]/) gate = ""
        # A blank line or an indented continuation (a wrapped gate item, a
        # sub-bullet) keeps the block open; only a fresh non-indented,
        # non-checkbox line ends it. Wrapped items are common in real files.
      }
    }
    END {
      byp = ""; ng = ""
      for (i = 1; i < cur; i++) {
        s = ord[i]
        if (skipped[s]) continue
        if (total[s] > 0 && checked[s] == total[s]) continue
        if (total[s] > 0)      { byp = byp (byp == "" ? "" : ",") Name[i] }
        else if (seen[s])      { ng  = ng  (ng  == "" ? "" : ",") Name[i] }
        else                   { byp = byp (byp == "" ? "" : ",") Name[i] }
      }
      g = "-"
      if (cur >= 1 && cur <= n && total[ord[cur]] > 0)
        g = checked[ord[cur]] + 0 "/" total[ord[cur]]
      printf "gate:%s\tbypass:%s\tnogate:%s", g, (byp == "" ? "none" : byp), (ng == "" ? "none" : ng)
    }
  ' "$f")

  if [ "$cmd" = "check" ]; then
    byp=$(printf '%s' "$verdict" | cut -f2)
    byp="${byp#bypass:}"
    if [ "$byp" != "none" ]; then
      fail=1
      printf '%s: at %s, but these gates are neither fully checked nor skipped: %s\n' "$slug" "$stage" "$byp"
    fi
  else
    printf '%s\t%s\t%s\t%s\n' "$slug" "$stage" "${mode:--}" "$verdict"
  fi
done

exit "$fail"
