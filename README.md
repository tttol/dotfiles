# dotfiles

## Overview

A personal dotfiles repository for managing configuration files in macOS environment using Nix + Home Manager.

This repository centralizes configurations for editors, terminals, shells, and development tools, making it easy to rebuild environments and maintain backups.

**Management Approach**: Configuration files only (packages are managed separately via Homebrew)

## Prerequisites

- Nix with flakes support
- Git

## Initial Setup

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

## Daily Updates

### Updating Configuration Files

When you modify configuration files:

```bash
cd ~/Documents/workspace/dotfiles

# Edit configuration files
vim config/nvim/init.lua
vim config/zsh/.zshrc

# Apply changes
home-manager switch --flake .

# Or
nix build .#homeConfigurations.tttol.activationPackage
./result/activate
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

### Adding New Configuration Files

1. Add file to `config/` directory
2. Edit `home.nix` to add `home.file` entry
3. Apply changes

Example:

```bash
# Add new config file
cp ~/.gitconfig config/git/.gitconfig

# Edit home.nix
vim home.nix
```

Add to `home.nix`:

```nix
home.file.".gitconfig" = {
  source = ./config/git/.gitconfig;
};
```

Apply:

```bash
home-manager switch --flake .
```

## Rollback

Home Manager tracks generations, allowing you to rollback to previous configurations:

```bash
# List generations
home-manager generations

# Rollback to specific generation
/nix/store/xxxxx-home-manager-generation/activate
```

## Structure

```
dotfiles/
├── flake.nix                 # Nix flake configuration
├── flake.lock                # Dependency versions (tracked by Git)
├── home.nix                  # Home Manager configuration
├── config/
│   ├── nvim/                 # Neovim configuration
│   ├── wezterm/              # WezTerm configuration
│   ├── zsh/                  # Zsh configuration
│   └── starship/             # Starship prompt configuration
└── plan/                     # Implementation plans

```

