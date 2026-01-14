{ config, pkgs, ... }: {
    home.username = "tttol";
    home.homeDirectory = "/Users/tttol";
    home.stateVersion = "24.05";

# Neovim
# home.file.".config/nvim" = {
#   source = ./config/nvim;
#   recursive = true;
# };

    # WezTerm
    home.file.".wezterm.lua" = {
        source = ./config/wezterm/.wezterm.lua;
    };

    # zsh
    home.file.".zshrc" = {
        source = ./config/zsh/.zshrc;
    };

    # Starship
    home.file.".config/starship.toml" = {
        source = ./config/starship/starship.toml;
    };

    # claude
    home.file.".claude/CLAUDE.md" = {
        source = ./config/claude/CLAUDE.md;
    };

    programs.home-manager.enable = true;
   }
