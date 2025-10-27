#!/bin/bash
find . -maxdepth 1 ! -name 'copy_obsidian_config.sh' ! -name '.' -exec rm -rf {} +
cp -r ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/tttol-icloud-vault/.obsidian/snippets/customizes.css ./
