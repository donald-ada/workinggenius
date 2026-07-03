#!/usr/bin/env bash
# SessionStart hook for the workinggenius plugin.
# Injects a one-line map of the workflow plus any in-flight work items,
# so both the human and the model know where each piece of work stands.

set -euo pipefail

WORK_DIR=".genius"

items=""
if [ -d "$WORK_DIR" ]; then
  for f in "$WORK_DIR"/*.md; do
    [ -e "$f" ] || continue
    stage=$(sed -n 's/^stage:[[:space:]]*//p' "$f" | head -1 | tr -d '\r')
    [ -z "$stage" ] && continue
    [ "$stage" = "done" ] && continue
    name=$(basename "$f" .md)
    items="${items}\n- ${name} — at ${stage}"
  done
fi

context="<workinggenius>\nThis project uses the Working Genius workflow: /wonder -> /invent -> /discern -> /galvanize -> /enable -> /tenacity. Type /genius for the map and status. Work files live in ${WORK_DIR}/."
if [ -n "$items" ]; then
  context="${context}\n\nIn-flight work:${items}\nBefore touching any of these, read its work file first (workinggenius:genius-file skill)."
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
