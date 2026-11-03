#!/usr/bin/env bash
# Claude Code status line dispatcher
# Reads the status line JSON once and forwards it to each command

input=$(cat)
dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "$input" | bash "$dir/statusline-command.sh"

# iTerm2 integration on macOS
if [ "$(uname -s)" = "Darwin" ] && command -v cc-status >/dev/null 2>&1; then
  echo "$input" | cc-status
fi
