# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Basic Guidelines
- Always output answer in Japanese, but output source-code comment in English. If you are asked something in English, you must answer in Japanese, no matter what.
- Do not use trailing spaces in source code.
- Do not apply empty lines, trailing spaces and tab characters in source code.

## Repository Structure

This is a personal dotfiles repository containing configuration files for various development tools:

- `nvim/` - Neovim configuration with Lua
- `vscode/` - Visual Studio Code settings and preferences
- `google-ja-input/` - Google Japanese Input custom keymap
- `vim/` - Vim configuration (currently empty)
- `shrc/` - Shell configuration (currently empty)

## Neovim Configuration

The Neovim setup (`nvim/init.lua`) includes:
- Lazy.nvim plugin manager (config in `config.lazy`)
- Telescope for fuzzy finding
- Custom key mappings:
  - `e` mapped to `$` (end of line) in normal and visual modes
  - `ff` for Telescope find files
  - `fg` for Telescope live grep
  - `fb` for Telescope buffers
  - `fh` for Telescope help tags
- Clipboard integration with OS
- Line numbers enabled
- UTF-8 encoding
- Disabled netrw in favor of other file explorers
- Color scheme: habamax

## VSCode Configuration

Key settings in `vscode/setting.json`:
- Vim extension with custom status bar colors for different modes
- Default formatters for various file types
- Auto-save enabled
- Word wrap enabled
- Git auto-fetch and smart commit
- Java development with Amazon Corretto 21
- PlantUML server integration
- Copilot chat in Japanese
- Tab size set to 2 spaces
- Ruby/RuboCop integration

## Google Japanese Input

Custom keymap file (`google-ja-input/keymap.txt`) provides:
- Emacs-style cursor movement in composition mode (Ctrl+a, Ctrl+e, etc.)
- Additional conversion shortcuts
- Escape key to cancel and turn off IME
- Enhanced navigation and text manipulation during input
