#!/bin/bash

set -e

DIFF=$(git diff --cached | head -n 300)
if [ -z "$DIFF" ]; then
    echo "Error: No staged changes found" >&2
    exit 1
fi

copilot -p "Write a single-line git commit message in conventional commits format (type: description) for this diff. Output ONLY the message:
$DIFF" -s --no-ask-user --model gpt-5-mini
