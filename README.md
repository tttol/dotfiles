# dotfiles

[![Automation test for Nix](https://github.com/tttol/dotfiles/actions/workflows/nix-build.yml/badge.svg)](https://github.com/tttol/dotfiles/actions/workflows/nix-build.yml)

## Overview

A personal dotfiles repository for managing configuration files in macOS environment using Nix + Home Manager.

This repository centralizes configurations for editors, terminals, shells, and development tools, making it easy to rebuild environments and maintain backups.

## Prerequisites

- Nix with flakes support
- Git
- Rust with Cargo

## Daily Updates

### Adding or Updating Configuration Files

When you modify configuration files:

```bash
# Add your changes to git
git add [files you add or update]

# Build without claude-code
home-manager switch --flake . --impure

# First installation of claude-code
nix profile install .#claude-code --impure

# Update the claude-code version
nix profile upgrade '.*claude-code.*' --impure
```

### Updating Dependencies (nixpkgs, home-manager)

```bash
cd ~/Documents/workspace/dotfiles

# Update all dependencies
nix flake update

# Update specific dependency
nix flake lock --update-input nixpkgs

# Apply updated dependencies
home-manager switch --flake . --impure

# Commit updated flake.lock
git add flake.lock
git commit -m "Update flake dependencies"
git push
```

## Installation
<details>
<summary><h2>Initial Setup</h2></summary>

### 1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

### 2. Enable Flakes

```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
max-jobs = auto
EOF
```

### 3. Install tree-sitter CLI

Neovim uses tree-sitter parsers for syntax highlighting and folding.
Install `tree-sitter-cli` so nvim-treesitter can build parsers.

```bash
cargo install tree-sitter-cli
```

ref: https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md

### 4. Clone Repository

```bash
git clone https://github.com/tttol/dotfiles.git ~/Documents/workspace/dotfiles
cd ~/Documents/workspace/dotfiles
```

### 5. Backup Existing Configurations

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.wezterm.lua ~/.wezterm.lua.backup
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/starship.toml ~/.config/starship.toml.backup
```

### 6. Apply Configuration

```bash
nix build .#homeConfigurations.$USER.activationPackage --impure
./result/activate
```

Or install home-manager and use:

```bash
# Build without claude-code
home-manager switch --flake . --impure

# First installation of claude-code
nix profile install .#claude-code --impure

# Update the claude-code version
nix profile upgrade '.*claude-code.*' --impure
```

### 7. Verify

```bash
ls -la ~/.config/nvim
ls -la ~/.wezterm.lua
ls -la ~/.zshrc
ls -la ~/.config/starship.toml
```

All files should be symlinks pointing to `/nix/store/...`

</details>


## Rollback

Home Manager tracks generations, allowing you to rollback to previous configurations:

```bash
# List generations
home-manager generations

# Rollback to specific generation
/nix/store/xxxxx-home-manager-generation/activate
```
