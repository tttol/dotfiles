#!/bin/bash

input=$(cat)

PURPLE='\033[35m'
GREEN='\033[32m'
ORANGE='\033[38;5;208m'
RESET='\033[0m'
FULL_BAR="██████████"
EMPTY_BAR="░░░░░░░░░░"

# Single jq call: extract all values + pre-compute rounded integers in jq
IFS=$'\t' read -r current_dir used_int used_filled five_int five_filled week_int week_filled < <(
  printf '%s' "$input" | jq -r '[
    (.workspace.current_dir // ""),
    (if .context_window.used_percentage != null then (.context_window.used_percentage | round | tostring) else "" end),
    (if .context_window.used_percentage != null then (.context_window.used_percentage / 10 | round | tostring) else "" end),
    (if .rate_limits.five_hour.used_percentage != null then (.rate_limits.five_hour.used_percentage | round | tostring) else "" end),
    (if .rate_limits.five_hour.used_percentage != null then (.rate_limits.five_hour.used_percentage / 10 | round | tostring) else "" end),
    (if .rate_limits.seven_day.used_percentage != null then (.rate_limits.seven_day.used_percentage | round | tostring) else "" end),
    (if .rate_limits.seven_day.used_percentage != null then (.rate_limits.seven_day.used_percentage / 10 | round | tostring) else "" end)
  ] | join("\t")'
)

# Git branch
branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null)
git_info="${PURPLE} ${branch:-(no git)}${RESET}"

# Context window bar (string slicing — no loop, no subprocess)
ctx_info=""
if [ -n "$used_int" ]; then
  ctx_bar="${FULL_BAR:0:$used_filled}${EMPTY_BAR:0:$((10 - used_filled))}"
  ctx_info="${GREEN} Context[${ctx_bar}]${used_int}%${RESET}"
fi

# Rate limit bars
rate_info=""
if [ -n "$five_int" ]; then
  five_bar="${FULL_BAR:0:$five_filled}${EMPTY_BAR:0:$((10 - five_filled))}"
  rate_info="${ORANGE} 5h[${five_bar}]${five_int}%${RESET}"
fi
if [ -n "$week_int" ]; then
  week_bar="${FULL_BAR:0:$week_filled}${EMPTY_BAR:0:$((10 - week_filled))}"
  rate_info="${rate_info}${ORANGE} 7d[${week_bar}]${week_int}%${RESET}"
fi

printf '%b\n' "${git_info}${ctx_info}${rate_info}"
