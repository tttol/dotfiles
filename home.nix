{ config, pkgs, lib, username, ... }:
let
  claudeCodeVersion = "2.1.114"; # Set to a version string like "1.2.3" to pin, or null for latest
  claudeCodeBinaryPkg = {
    "aarch64-darwin" = { name = "claude-code-darwin-arm64"; hash = "sha256-W33zTuyDOZaEGI7EZCrmD0//lsaCLbL/WY5JNbnSnfk="; };
    "x86_64-darwin"  = { name = "claude-code-darwin-x64";   hash = lib.fakeHash; };
    "aarch64-linux"  = { name = "claude-code-linux-arm64";  hash = lib.fakeHash; };
    "x86_64-linux"   = { name = "claude-code-linux-x64";    hash = lib.fakeHash; };
  }.${pkgs.stdenv.hostPlatform.system};
  claude-code = if claudeCodeVersion == null
    then pkgs.claude-code
    else pkgs.stdenv.mkDerivation {
      pname = "claude-code";
      version = claudeCodeVersion;
      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/@anthropic-ai/${claudeCodeBinaryPkg.name}/-/${claudeCodeBinaryPkg.name}-${claudeCodeVersion}.tgz";
        hash = claudeCodeBinaryPkg.hash;
      };
      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;
      dontFixup = true;
      installPhase = ''
        mkdir -p $out/bin
        cp claude $out/bin/claude
        chmod +x $out/bin/claude
      '';
      meta = {
        description = "Claude Code CLI";
        license = pkgs.lib.licenses.unfree;
        mainProgram = "claude";
      };
    };
in {
    nixpkgs.config.allowUnfree = true;
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
        executable = true;
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
    home.packages = [ claude-code ];
    programs.home-manager.enable = true;
    # /Library/Application Support
   }
