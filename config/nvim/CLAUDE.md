# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration using lazy.nvim plugin manager with a modular structure:

- `init.lua` - Main configuration entry point that sets up basic Neovim options, keymaps, and loads lazy.nvim
- `lua/config/lazy.lua` - Bootstraps lazy.nvim and imports all plugins from the `plugins/` directory
- `lua/plugins/` - Individual plugin configurations as separate Lua files
- `lua/lsp.lua` - LSP configuration loaded directly from init.lua (separate from plugin system)

## Key Configuration Details

### Plugin System
- Uses lazy.nvim plugin manager with automatic plugin loading from `lua/plugins/` directory
- Each plugin has its own configuration file in `lua/plugins/`
- Luarocks support is disabled in lazy configuration

### LSP Configuration
- LSP is configured in a separate `lua/lsp.lua` file (not part of the plugin system)
- Currently includes rust-analyzer with cargo.allFeatures and procMacro.enable settings
- Uses standard LSP keymaps (gd, gr, K, etc.)

### Custom Settings
- Leader key: `<Space>`
- Local leader key: `\`
- Uses 'habamax' colorscheme
- Custom keybindings: `e` maps to `$` in normal/visual mode
- 4-space indentation by default, 2-space for JS/TS files
- Clipboard integration with OS clipboard

### Plugin Structure
Notable plugins configured include:
- mason.nvim ecosystem (commented out in current lsp.lua setup)
- treesitter, telescope, nvim-tree
- cmp for completion
- lualine for statusline
- Individual LSP configs in `lua/plugins/lsp/` directory (jdtls.lua, rust-analyzer.lua)

## Important Notes
- The main LSP configuration is currently in `lua/lsp.lua`, not in the plugins system
- Individual language server configs exist in `lua/plugins/lsp/` but may not be actively loaded
- Configuration includes both English comments and Japanese user instructions

# new h1
## new h2
