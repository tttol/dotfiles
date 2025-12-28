#!/bin/bash
find . -maxdepth 1 ! -name 'copy_claude_config.sh' ! -name '.' -exec rm -rf {} +
cp -r ~/.claude/ ./
