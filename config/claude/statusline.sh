#!/bin/bash

input=$(cat)

PURPLE='\033[35m'
GREEN='\033[32m'
ORANGE='\033[38;5;208m'
RESET='\033[0m'

# Git branch (skip optional locks for safety)
branch=$(git -C "$(echo "$input" | jq -r '.workspace.current_dir // empty')" \
  --no-optional-locks branch --show-current 2>/dev/null)
if [ -n "$branch" ]; then
  git_info="${PURPLE} $branch${RESET}"
else
  git_info="${PURPLE}(no git)${RESET}"
fi

# Context window progress bar
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  ctx_filled=$(printf "%.0f" "$(echo "$used_pct / 10" | bc -l)")
  ctx_bar=""
  for i in $(seq 1 10); do
    if [ "$i" -le "$ctx_filled" ]; then
      ctx_bar="${ctx_bar}█"
    else
      ctx_bar="${ctx_bar}░"
    fi
  done
  ctx_pct_int=$(printf "%.0f" "$used_pct")
  ctx_info="${GREEN} Context[${ctx_bar}]${ctx_pct_int}%${RESET}"
else
  ctx_info=""
fi

# Rate limit progress bars (5h and 7d)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rate_info=""
if [ -n "$five_pct" ]; then
  five_filled=$(printf "%.0f" "$(echo "$five_pct / 10" | bc -l)")
  five_bar=""
  for i in $(seq 1 10); do
    if [ "$i" -le "$five_filled" ]; then
      five_bar="${five_bar}█"
    else
      five_bar="${five_bar}░"
    fi
  done
  five_int=$(printf "%.0f" "$five_pct")
  rate_info="${rate_info}${ORANGE} 5h[${five_bar}]${five_int}%${RESET}"
fi
if [ -n "$week_pct" ]; then
  week_filled=$(printf "%.0f" "$(echo "$week_pct / 10" | bc -l)")
  week_bar=""
  for i in $(seq 1 10); do
    if [ "$i" -le "$week_filled" ]; then
      week_bar="${week_bar}█"
    else
      week_bar="${week_bar}░"
    fi
  done
  week_int=$(printf "%.0f" "$week_pct")
  rate_info="${rate_info}${ORANGE} 7d[${week_bar}]${week_int}%${RESET}"
fi

echo -e "${git_info}${ctx_info}${rate_info}"
