#!/usr/bin/env bash
# Headless scenario runner (ROADMAP Phase 1.1 / Phase 4.1 prototype).
#
# Builds a fresh scratch project, sets up one scenario, runs its prompt through
# `claude -p`, and saves the transcript for grading. Deterministic scaffolding
# around a nondeterministic core — the grading itself stays human/blind-subagent
# work (see evals/README.md). This is the first real step toward the extractable
# runner Phase 4.1 describes; it implements one scenario at a time as each is run
# for real, not the whole matrix up front.
#
#   run-scenario.sh <scenario-id> <arm: skill|baseline> <out-transcript>
#
# Two arms, and the difference between them is the whole point:
#   skill    — the plugin's skills installed under .claude/skills/
#   baseline — no skills, AND the ## Working Genius section stripped from the
#              fixture's CLAUDE.md. That section documents the entire flow, so
#              leaving it in *teaches the baseline the plugin's methodology* and
#              silently converts every scenario into a softball. Stripping it is
#              what makes the baseline a real no-plugin control.
set -euo pipefail

PLUGIN=$(cd "$(dirname "$0")/.." && pwd)
ID="${1:?scenario id}"; ARM="${2:?skill|baseline}"; OUT="${3:?out path}"
SCRATCH=$(mktemp -d)

bash "$PLUGIN/evals/fixtures/scratch.sh" "$SCRATCH" >/dev/null 2>&1
cd "$SCRATCH"

if [ "$ARM" = "skill" ]; then
  mkdir -p .claude/skills
  cp -r "$PLUGIN"/skills/* .claude/skills/
else
  awk 'BEGIN{skip=0} /^## Working Genius/{skip=1;next} /^## /{if(skip)skip=0} !skip' \
    CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
fi

# Per-scenario setup + prompt. Skill arm uses the /command; baseline arm uses
# the same ask in plain English (no plugin means no slash command) and must NOT
# add any invitation to reflect on process — that flatters the baseline.
case "$ID" in
  M2)
    mkdir -p .genius
    cp "$PLUGIN"/evals/fixtures/done/*.md .genius/
    if [ "$ARM" = "skill" ]; then
      PROMPT="/genius add bulk order import — merchants upload a CSV of orders"
    else
      PROMPT="I want to add bulk order import — merchants upload a CSV of orders."
    fi
    ;;
  *) echo "unknown/unimplemented scenario $ID" >&2; exit 2 ;;
esac

git add -A >/dev/null 2>&1 && git -c user.email=e@e.e -c user.name=e commit -qm setup >/dev/null 2>&1 || true

timeout 300 claude -p "$PROMPT" \
  --allowedTools "Read,Grep,Glob,Bash,Skill,Task,TodoWrite,Write,Edit" \
  < /dev/null > "$OUT" 2>&1 || echo "[harness: claude exited $?]" >> "$OUT"

echo "$SCRATCH"
