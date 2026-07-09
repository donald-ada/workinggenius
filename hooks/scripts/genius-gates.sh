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
# Gate grammar (owned by genius-file/FILE-FORMAT.md): a gate block opens at a
# line that STARTS with `**Gate — <Stage>**` (or a `#`-heading form) and ends
# only at the next `## ` heading, the next `**`-led line (e.g. **Post-mortem:**),
# or another gate marker. Inside the block, checkboxes count at any indent;
# prose notes, wrapped continuations, and blank lines stay inside without
# ending it. A stage is satisfied when its gate exists with every box checked,
# or its section carries a `> ... Skipped` line. A stage EARLIER than the
# file's current stage that is neither → bypass. A section that ran without
# any gate block → nogate: (surfaced, not blocking). An unrecognized stage:
# value is its own finding — a file the whole toolchain would otherwise
# silently treat as healthy.
set -euo pipefail

cmd="${1:-status}"

# Resolve the project base by walking UP from the session cwd to the git
# toplevel (or /): the first directory that pins a work dir in
# CLAUDE.md/AGENTS.md, or that already has a .genius/, wins. A monorepo
# package with its own CLAUDE.md therefore resolves to the package — never
# to the monorepo root (jumping straight to the git root made subdirectory
# projects invisible to both hooks).
top=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
BASE=""; WORK_DIR=""
d=$(pwd)
while :; do
  for f in "$d/CLAUDE.md" "$d/AGENTS.md"; do
    [ -f "$f" ] || continue
    override=$(sed -n 's/^Work files:[[:space:]]*`\([^`]*\)`.*/\1/p' "$f" | head -1)
    if [ -n "$override" ]; then
      BASE="$d"; WORK_DIR="${override%/}"
      break 2
    fi
  done
  if [ -d "$d/.genius" ]; then BASE="$d"; WORK_DIR=".genius"; break; fi
  { [ "$d" = "$top" ] || [ "$d" = "/" ]; } && break
  d=$(dirname "$d")
done
if [ -z "$BASE" ]; then BASE=$(pwd); WORK_DIR=".genius"; fi
cd "$BASE"

if [ "$cmd" = "dir" ]; then
  printf '%s\n' "$WORK_DIR"
  exit 0
fi

[ -d "$WORK_DIR" ] || exit 0

fail=0
for f in "$WORK_DIR"/*.md; do
  [ -e "$f" ] || continue
  slug=${f##*/}; slug=${slug%.md}

  # One awk pass per file: frontmatter (stage/mode — CR stripped, inline
  # `# comments` removed, full value kept) plus the gate grammar above.
  line=$(awk '
    BEGIN {
      n = split("wonder invention discernment galvanizing enablement tenacity", ord, " ")
      for (i = 1; i <= n; i++) {
        idx[ord[i]] = i
        Name[i] = toupper(substr(ord[i], 1, 1)) substr(ord[i], 2)
      }
      infm = 0; stage = ""; mode = ""; sec = ""; gate = ""
    }
    NR == 1 && /^---\r?$/ { infm = 1; next }
    infm && /^---\r?$/    { infm = 0; next }
    infm {
      v = $0; sub(/\r$/, "", v)
      if (v ~ /^stage:/) { sub(/^stage:[[:space:]]*/, "", v); sub(/[[:space:]]*#.*$/, "", v); sub(/[[:space:]]+$/, "", v); stage = tolower(v) }
      else if (v ~ /^mode:/) { sub(/^mode:[[:space:]]*/, "", v); sub(/[[:space:]]*#.*$/, "", v); sub(/[[:space:]]+$/, "", v); mode = v }
      next
    }
    # Gate marker — anchored: only a line that STARTS with the marker (bold
    # or heading form) opens a block. A mid-line mention ("… survived the
    # Gate — Wonder review") must not retarget the count.
    /^(\*\*|#+[ \t]*)Gate — / {
      g = ""
      for (i = 1; i <= n; i++) if (index($0, "Gate — " Name[i]) > 0) g = ord[i]
      if (g != "") { gate = g; next }
    }
    /^## / {
      sec = ""; gate = ""
      for (i = 1; i <= n; i++) if (index($0, "## " Name[i]) == 1) sec = ord[i]
      if (sec != "") seen[sec] = 1
      next
    }
    /^\*\*/ { gate = "" }   # any other bold-led line (e.g. **Post-mortem:**) ends the block
    {
      if (sec != "" && $0 ~ /^>/ && $0 ~ /Skipped/) { skipped[sec] = 1; next }
      if (gate != "") {
        if ($0 ~ /^[ \t]*- \[[xX]\]/)   { total[gate]++; checked[gate]++ }
        else if ($0 ~ /^[ \t]*- \[ \]/) { total[gate]++ }
        # everything else — prose notes, wrapped continuations, blanks —
        # stays inside; the block ends only at ^## , ^**, or a new marker.
      }
    }
    END {
      if (stage == "" || stage == "done") { print "SKIP"; exit }
      if (mode == "") mode = "-"
      if (!(stage in idx)) { printf "UNKNOWN\t%s\t%s\n", stage, mode; exit }
      cur = idx[stage]
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
      if (total[ord[cur]] > 0) g = checked[ord[cur]] + 0 "/" total[ord[cur]]
      printf "OK\t%s\t%s\tgate:%s\tbypass:%s\tnogate:%s\n", stage, mode,
             g, (byp == "" ? "none" : byp), (ng == "" ? "none" : ng)
    }
  ' "$f")

  kind=${line%%$'\t'*}
  case "$kind" in
    SKIP) continue ;;
    UNKNOWN)
      rest=${line#UNKNOWN$'\t'}
      stage=${rest%%$'\t'*}; mode=${rest#*$'\t'}
      if [ "$cmd" = "check" ]; then
        fail=1
        printf '%s: unrecognized stage "%s" — expected wonder|invention|discernment|galvanizing|enablement|tenacity|done; the file is invisible to every gate check until the stage: line is repaired\n' "$slug" "$stage"
      else
        printf '%s\t%s\t%s\tgate:-\tbypass:unrecognized-stage\tnogate:none\n' "$slug" "$stage" "$mode"
      fi
      continue ;;
  esac

  rest=${line#OK$'\t'}
  if [ "$cmd" = "check" ]; then
    stage=$(printf '%s' "$rest" | cut -f1)
    byp=$(printf '%s' "$rest" | cut -f4)
    byp=${byp#bypass:}
    if [ "$byp" != "none" ]; then
      fail=1
      printf '%s: at %s, but these gates are neither fully checked nor skipped: %s\n' "$slug" "$stage" "$byp"
    fi
  else
    printf '%s\t%s\n' "$slug" "$rest"
  fi
done

exit "$fail"
