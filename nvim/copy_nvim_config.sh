#!/bin/bash
find . -maxdepth 1 ! -name 'copy_nvim_config.sh' ! -name '.' -exec rm -rf {} +
cp -r ~/.config/nvim/ ./
