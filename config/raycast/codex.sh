#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title codex
# @raycast.mode silent
# @raycast.packageName Developer Tools
# @raycast.icon 🧠
# @raycast.argument1 { "type": "text", "placeholder": "prompt", "optional": true }

if [ -n "$1" ]; then
  wezterm start -- zsh -ic "cd ~/tmp/codex-sandbox; codex \"$1\"; exec zsh"
else
  wezterm start -- zsh -ic "cd ~/tmp/codex-sandbox; codex; exec zsh"
fi

sleep 0.5
open -a WezTerm
