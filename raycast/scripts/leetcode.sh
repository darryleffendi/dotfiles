#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Leetcode
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🧑‍💻
# @raycast.packageName Personal

YEAR=$(date +%Y)
MONTH_DAY=$(date +%m-%d)
TARGET_DIR="$HOME/codespace/personal/leetcode/$YEAR/$MONTH_DAY"

# Make the directory, then open a new tmux window already cd'd into it.
# Target the session of the most-recently-active client (the one you're looking at).
mkdir -p "$TARGET_DIR"

SESSION=$(tmux list-clients -F "#{client_activity} #{client_session}" 2>/dev/null |
  sort -rn | head -1 | cut -d' ' -f2)

NEW_WINDOW=$(tmux new-window ${SESSION:+-t "$SESSION"} -c "$TARGET_DIR" -P -F "#{session_name}:#{window_index}")
tmux send-keys -t "$NEW_WINDOW" "cd '$TARGET_DIR' && nvim" Enter

# Focus aerospace workspace U and open Chrome
aerospace workspace U 2>/dev/null || true
open -a "Google Chrome" "https://leetcode.com/problems"

echo "LeetCode: $YEAR/$MONTH_DAY"
