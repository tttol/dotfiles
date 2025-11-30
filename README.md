# dotfiles

## Overview

A personal dotfiles repository for managing configuration files in macOS environment.

This repository centralizes configurations for editors, terminals, shells, and development tools, making it easy to rebuild environments and maintain backups.

## Structure

Each directory contains configuration files for corresponding tools:

- **Editors**: Vim, Neovim, Visual Studio Code
- **Shell**: Zsh, Starship
- **Terminal**: WezTerm
- **Development Tools**: Claude Code
- **Others**: Obsidian, Google Japanese Input, Squid

## Syncing Configurations

### Sync All

Copy all configuration files from home directory to repository:

```bash
./sync_all_configs.sh
```

### Sync Individual

Each directory has a `copy_*_config.sh` script for individual syncing:

```bash
cd nvim
./copy_nvim_config.sh
```

## Usage

1. **Update Configuration**: Edit actual configuration files in home directory
2. **Sync**: Run corresponding copy script to reflect changes in repository
3. **Version Control**: Commit and push with git
