#!/usr/bin/env sh
# Install the Working Genius skills into any Agent Skills-compatible tool.
#
# Usage:
#   ./install.sh [TARGET_DIR]                  # from a clone
#   curl -fsSL https://raw.githubusercontent.com/donald-ada/workinggenius/main/install.sh | sh -s -- [TARGET_DIR]
#
# TARGET_DIR is wherever your agent discovers skills (default: .claude/skills).
# See https://agentskills.io/clients for each tool's location.
set -eu

TARGET="${1:-.claude/skills}"
REPO="https://github.com/donald-ada/workinggenius"

SELF_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"

mkdir -p "$TARGET"

if [ -n "$SELF_DIR" ] && [ -f "$SELF_DIR/skills/genius/SKILL.md" ]; then
  cp -R "$SELF_DIR/skills/." "$TARGET/"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  git clone --depth 1 --quiet "$REPO" "$TMP/wg"
  cp -R "$TMP/wg/skills/." "$TARGET/"
fi

echo "Working Genius skills installed to: $TARGET"
echo "If your agent uses a different skills directory, re-run with it as the first argument."
