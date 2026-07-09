#!/usr/bin/env bash
# SessionStart hook for the workinggenius plugin.
# Injects a one-line map of the workflow plus any in-flight work items —
# including bypassed gates, so a fresh session inherits the warning, not
# the mystery. All parsing lives in genius-gates.sh; this script formats.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GATES="$SCRIPT_DIR/genius-gates.sh"

WORK_DIR=$("$GATES" dir)

items=""
while IFS=$'\t' read -r slug stage mode gatef bypf nogf; do
  [ -z "$slug" ] && continue
  gate="${gatef#gate:}"; byp="${bypf#bypass:}"; nog="${nogf#nogate:}"
  entry="- ${slug} — at ${stage}"
  [ "$gate" != "-" ] && entry="${entry} (gate ${gate})"
  if [ "$byp" = "unrecognized-stage" ]; then
    entry="${entry} ⚠ unrecognized stage value — fix the stage: line before anything else"
  elif [ "$byp" != "none" ]; then
    entry="${entry} ⚠ bypassed with no recorded skip: ${byp} — repair that gate before anything else"
  fi
  [ "$nog" != "none" ] && entry="${entry} (note: ${nog} ran without a recorded gate)"
  items="${items}\n${entry}"
done < <("$GATES" status)

context="<workinggenius>\nThis project uses the Working Genius workflow: /wonder -> /invent -> /discern -> /galvanize -> /enable -> /tenacity. Type /genius for the map and status. Work files live in ${WORK_DIR}/."
if [ -n "$items" ]; then
  context="${context}\n\nIn-flight work:${items}\nBefore touching any of these, read its work file first (workinggenius:genius-file skill)."
else
  context="${context}\nWhen the user asks for a substantive piece of development work (a feature, a refactor, a stubborn bug) outside the flow, suggest starting it with /genius — once, briefly; their call."
fi
context="${context}\n</workinggenius>"

# Escape for JSON embedding.
escape_for_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

escaped=$(escape_for_json "$(printf '%b' "$context")")

printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "$escaped"

exit 0
