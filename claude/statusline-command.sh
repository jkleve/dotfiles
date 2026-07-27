#!/usr/bin/env bash
# Claude Code status line command
# Derived from ~/.bashrc PS1: green user, blue cwd, plus model and context info

input=$(cat)

user=$(whoami)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# ANSI colors (dim-friendly)
GREEN='\033[01;32m'
BLUE='\033[01;34m'
RESET='\033[00m'
DIM='\033[2m'

# Base prompt: user + cwd (matching original PS1 style, trailing $ removed)
status=$(printf "${GREEN}%s${RESET} ${BLUE}%s${RESET}" "$user" "$cwd")

# Append model name if available
if [ -n "$model" ]; then
  status="$status ${DIM}[$model]${RESET}"
fi

# Append context size information if available
if [ -n "$used_pct" ] && [ -n "$total_input" ] && [ -n "$ctx_size" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  # Convert token counts to K for readability
  used_k=$(awk "BEGIN {printf \"%.0f\", $total_input / 1000}")
  total_k=$(awk "BEGIN {printf \"%.0f\", $ctx_size / 1000}")
  status="$status ${DIM}ctx:${used_k}K/${total_k}K (${used_int}%)${RESET}"
elif [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  status="$status ${DIM}ctx:${used_int}%${RESET}"
fi

printf "%b" "$status"

