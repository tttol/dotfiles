# dotfiles

## Overview

A personal dotfiles repository for managing configuration files in macOS environment using Nix + Home Manager.

This repository centralizes configurations for editors, terminals, shells, and development tools, making it easy to rebuild environments and maintain backups.

## Prerequisites

- Nix with flakes support
- Git

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

### 3. Clone Repository

```bash
git clone https://github.com/tttol/dotfiles.git ~/Documents/workspace/dotfiles
cd ~/Documents/workspace/dotfiles
```

### 4. Backup Existing Configurations

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.wezterm.lua ~/.wezterm.lua.backup
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/starship.toml ~/.config/starship.toml.backup
```

### 5. Apply Configuration

```bash
nix build .#homeConfigurations.tttol.activationPackage
./result/activate
```

Or install home-manager and use:

```bash
nix run home-manager/master -- switch --flake .
```

### 6. Verify

```bash
ls -la ~/.config/nvim
ls -la ~/.wezterm.lua
ls -la ~/.zshrc
ls -la ~/.config/starship.toml
```

All files should be symlinks pointing to `/nix/store/...`

</details>

## Daily Updates

### Adding or Updating Configuration Files

When you modify configuration files:

```bash
# Apply changes
home-manager switch --flake .
```

### Updating Dependencies (nixpkgs, home-manager)

```bash
cd ~/Documents/workspace/dotfiles

# Update all dependencies
nix flake update

# Update specific dependency
nix flake lock --update-input nixpkgs

# Apply updated dependencies
home-manager switch --flake .

# Commit updated flake.lock
git add flake.lock
git commit -m "Update flake dependencies"
git push
```

## Rollback

Home Manager tracks generations, allowing you to rollback to previous configurations:

```bash
# List generations
home-manager generations

# Rollback to specific generation
/nix/store/xxxxx-home-manager-generation/activate
```

