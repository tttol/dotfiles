{ config, pkgs, username, ... }: {
    home.username = username;
    home.homeDirectory = "/Users/${username}";
    home.stateVersion = "24.05";

    # Neovim
    home.file.".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
    };

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
    home.file.".claude/settings.json" = {
        source = ./config/claude/settings.json;
    };
    home.file.".claude/statusline.sh" = {
        source = ./config/claude/statusline.sh;
    };

    # lazygit
    home.file."Library/Application Support/lazygit" = {
        source = ./config/lazygit;
        recursive = true;
    };
    
    # skills
    home.file.".claude/skills" = {
        source = ./config/skills;
        recursive = true;
    };
    # home.file.".codex/skills" = {
    #     source = ./skills;
    #     recursive = true;
    # };

    # git
    home.file.".config/git" = {
        source = ./config/git;
        recursive = true;
    };

    # ghostty
    home.file.".config/ghostty" = {
        source = ./config/ghostty;
        recursive = true;
    };
    programs.home-manager.enable = true;
    # /Library/Application Support
   }
