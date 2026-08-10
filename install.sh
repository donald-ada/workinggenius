#!/usr/bin/env sh
# Install the Working Genius skills into any Agent Skills-compatible tool.
#
# Usage:
#   ./install.sh                       # detect this project's agents
#   ./install.sh DIR [DIR ...]         # install into exactly these directories
#   curl -fsSL https://raw.githubusercontent.com/donald-ada/workinggenius/main/install.sh | sh
#
# With no argument it installs into `.agents/skills` — the vendor-neutral
# location — and mirrors into any agent directory this project ALREADY has.
# It never creates a vendor directory that isn't there: a Cursor project does
# not get a `.claude` folder, and no agent is assumed.
#
# When npm is available, `npx skills add donald-ada/workinggenius` is the
# better path — it knows ~70 agents' locations and auto-detects yours.
set -eu

REPO="https://github.com/donald-ada/workinggenius"
SELF_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"

if [ -n "$SELF_DIR" ] && [ -f "$SELF_DIR/skills/genius/SKILL.md" ]; then
  SRC="$SELF_DIR/skills"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  git clone --depth 1 --quiet "$REPO" "$TMP/wg"
  SRC="$TMP/wg/skills"
fi

install_into() {
  mkdir -p "$1"
  cp -R "$SRC/." "$1/"
  echo "  → $1"
}

echo "Working Genius skills:"

if [ "$#" -gt 0 ]; then
  for target in "$@"; do
    install_into "$target"
  done
  exit 0
fi

install_into ".agents/skills"

for dir in .claude .cursor .codex .gemini .windsurf .zed .opencode .goose .amp .roo .continue .kilo; do
  if [ -d "$dir" ]; then
    install_into "$dir/skills"
  fi
done

echo
echo "Your agent reads skills from somewhere else? ./install.sh <dir> [<dir> ...]"
