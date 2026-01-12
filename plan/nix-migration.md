# dotfiles Nix + Home Manager 移行計画

## 概要

現在のdotfilesをNix + Home Managerで管理する構成に移行します。ユーザーの選択に基づき、以下の方針で実装します：

- **Neovim**: lazy.nvim維持、LSP/ツールのみNixで管理
- **Zsh**: zinit維持（ハイブリッド構成）
- **既存設定**: legacy/ディレクトリに移動し、バックアップとして保持

## 目標ディレクトリ構造

```
dotfiles/
├── flake.nix                    # Flakeエントリーポイント
├── flake.lock                   # 依存バージョン固定
├── home/
│   ├── default.nix              # Home-Manager統合設定
│   ├── shell.nix                # Zsh設定（zinitハイブリッド）
│   ├── git.nix                  # Git設定
│   ├── neovim.nix               # Neovim設定（lazy.nvim維持）
│   ├── wezterm.nix              # WezTerm設定
│   └── packages.nix             # CLIツール一覧
├── darwin/
│   ├── default.nix              # nix-darwin統合
│   ├── system.nix               # macOSシステム設定
│   ├── homebrew.nix             # Homebrew管理（GUIアプリ）
│   └── services.nix             # launchdサービス
├── config/
│   ├── nvim/                    # Neovim設定（既存からコピー）
│   │   ├── init.lua
│   │   └── lua/
│   ├── wezterm/
│   │   └── wezterm.lua
│   ├── zsh/
│   │   └── .zshrc               # 既存のzshrc（zinit含む）
│   └── starship/
│       └── starship.toml
└── legacy/                      # 移行前設定のバックアップ
    ├── nvim/
    ├── zsh/
    ├── wezterm/
    └── copy_*_config.sh
```

## 重要ファイルの実装内容

### 1. flake.nix

```nix
{
  description = "tttol's dotfiles managed by Nix + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin }:
    let
      system = "aarch64-darwin";
      # ホスト名は実際のマシン名に置換する（`hostname`コマンドで確認）
      hostname = "your-hostname";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.tttol = import ./home/default.nix;
            };
          }
        ];
      };
    };
}
```

### 2. home/default.nix

```nix
{ pkgs, ... }: {
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./wezterm.nix
  ];

  home = {
    username = "tttol";
    homeDirectory = "/Users/tttol";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
```

### 3. home/packages.nix

```nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Shell utilities
    eza
    fzf
    fd
    ripgrep
    bat
    zoxide
    jq

    # Git tools
    lazygit
    gh
    git-lfs

    # Development tools
    nodejs_22
    bun
    rustc
    cargo

    # Prompt
    starship

    # Java environment
    jdk21
  ];

  # Lombok for Java LSP
  home.file.".local/share/java/lombok.jar" = {
    source = pkgs.fetchurl {
      url = "https://projectlombok.org/downloads/lombok.jar";
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
  };

  # 環境変数
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
    SPRING_PROFILES_ACTIVE = "local";
    JDTLS_JVM_ARGS = "-javaagent:$HOME/.local/share/java/lombok.jar";
  };
}
```

**注**: lombok.jarのsha256は実際の値に置き換える必要があります（`nix-prefetch-url`で取得）。

### 4. home/shell.nix（ハイブリッド構成）

```nix
{ pkgs, ... }: {
  programs.zsh = {
    enable = true;

    # 既存の.zshrcをそのまま読み込む（zinit含む）
    initExtra = ''
      source ${../config/zsh/.zshrc}
    '';
  };

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
```

**注**: 既存の.zshrc内のstarship/zoxide初期化コードは削除不要（Home Managerの統合が優先される）。

### 5. home/neovim.nix

```nix
{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # LSPや必要なツールのみNixで管理
    extraPackages = with pkgs; [
      # Language Servers
      nodePackages.typescript-language-server
      lua-language-server
      rust-analyzer
      pyright
      tailwindcss-language-server

      # Tree-sitter
      tree-sitter

      # Formatters
      stylua
      nodePackages.prettier

      # その他ツール
      ripgrep  # Telescope依存
      fd       # Telescope依存
    ];
  };

  # lazy.nvim設定をそのまま使用
  home.file.".config/nvim" = {
    source = ../config/nvim;
    recursive = true;
  };
}
```

### 6. home/wezterm.nix

```nix
{ ... }: {
  # WeztermはHomebrewで管理（darwin/homebrew.nix参照）

  home.file.".wezterm.lua" = {
    source = ../config/wezterm/wezterm.lua;
  };
}
```

### 7. home/git.nix

```nix
{ ... }: {
  programs.git = {
    enable = true;
    userName = "tttol";
    userEmail = "your-email@example.com";  # 実際のメールアドレスに置換

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };
}
```

### 8. darwin/default.nix

```nix
{ ... }: {
  imports = [
    ./system.nix
    ./homebrew.nix
    ./services.nix
  ];

  # Nix daemon
  services.nix-daemon.enable = true;

  # Nix設定
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "tttol" ];
    };
  };

  # システムバージョン
  system.stateVersion = 5;
}
```

### 9. darwin/system.nix

```nix
{ ... }: {
  system.defaults = {
    # Dock設定
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
    };

    # Finder設定
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };

    # グローバル設定
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      "com.apple.swipescrolldirection" = false;
    };
  };
}
```

### 10. darwin/homebrew.nix

```nix
{ ... }: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    brews = [
      # Nixで管理できない、またはHomebrewの方が良いもの
    ];

    casks = [
      "wezterm"
      "obsidian"
    ];
  };
}
```

### 11. darwin/services.nix

```nix
{ ... }: {
  # 必要に応じてlaunchdサービスを定義
  # 例: 自動バックアップスクリプト等
}
```

## 段階的実装手順

### Phase 1: 準備（30分）

1. **Nixインストール確認**
   ```bash
   nix --version
   ```
   未インストールの場合: `curl -L https://nixos.org/nix/install | sh`

2. **現在の設定をコミット**
   ```bash
   git add -A
   git commit -m "Backup before Nix migration"
   ```

3. **バックアップディレクトリ作成**
   ```bash
   mkdir -p legacy
   cp -r nvim zsh wezterm starship vim vscode claude obsidian google-ja-input squid *.sh legacy/
   ```

### Phase 2: 基盤構築（2時間）

1. **新規ディレクトリ作成**
   ```bash
   mkdir -p home darwin config/{nvim,wezterm,zsh,starship}
   ```

2. **flake.nix作成**
   - 上記のflake.nixの内容を実装
   - `hostname`を実際のマシン名に置換（`hostname`コマンドで確認）

3. **darwin/とhome/の各ファイル作成**
   - 各default.nixファイルを実装

4. **構文チェック**
   ```bash
   nix flake check
   ```

### Phase 3: 設定ファイル移行（1時間）

1. **config/配下に設定をコピー**
   ```bash
   cp -r nvim/* config/nvim/
   cp wezterm/.wezterm.lua config/wezterm/wezterm.lua
   cp zsh/.zshrc config/zsh/.zshrc
   cp starship/starship.toml config/starship/starship.toml
   ```

2. **config/zsh/.zshrc の調整**
   - starship init, zoxide initの行をコメントアウト（Home Managerが管理）
   ```bash
   # starship
   # eval "$(starship init zsh)"

   # zoxide
   # eval "$(zoxide init zsh)"
   ```

### Phase 4: パッケージ設定（1時間）

1. **home/packages.nix実装**
   - 上記の内容を実装
   - lombok.jarのsha256を取得:
     ```bash
     nix-prefetch-url https://projectlombok.org/downloads/lombok.jar
     ```

2. **darwin/homebrew.nix実装**
   - WezTermとObsidianをcasksに追加

### Phase 5: 各モジュール実装（2時間）

1. **home/shell.nix実装**
   - ハイブリッド構成で実装

2. **home/neovim.nix実装**
   - lazy.nvim維持、LSPツールのみNix管理

3. **home/wezterm.nix実装**

4. **home/git.nix実装**
   - メールアドレスを実際の値に置換

5. **darwin/system.nix実装**

6. **darwin/services.nix実装**（空ファイルでOK）

### Phase 6: ビルドとデプロイ（1時間）

1. **初回ビルド**
   ```bash
   nix build .#darwinConfigurations.your-hostname.system
   ```

2. **システム切り替え**
   ```bash
   ./result/sw/bin/darwin-rebuild switch --flake .
   ```

3. **エイリアス設定（オプション）**
   - .zshrcに追加:
     ```bash
     alias darwin-rebuild-switch='darwin-rebuild switch --flake ~/Documents/workspace/dotfiles'
     ```

### Phase 7: 検証（1時間）

1. **新しいターミナルを開く**

2. **パッケージ確認**
   ```bash
   which eza fzf fd ripgrep bat zoxide jq lazygit gh node bun rustc starship nvim
   ```

3. **環境変数確認**
   ```bash
   echo $JAVA_HOME
   echo $SPRING_PROFILES_ACTIVE
   echo $JDTLS_JVM_ARGS
   ```

4. **Zshカスタム関数テスト**
   ```bash
   nvf    # fzfでファイル選択→nvimで開く
   nvd    # fzfでディレクトリ選択→nvimで開く
   cdf    # fzfでディレクトリ選択→zoxideで移動
   ```

5. **Neovimテスト**
   ```bash
   nvim
   # :Lazy sync でプラグイン同期
   # LSP動作確認（適当なファイルで gd, K 等）
   ```

6. **WezTermテスト**
   - ペイン分割: `Cmd+\`
   - ペイン移動: `Cmd+h/j/k/l`
   - タブ表示確認

### Phase 8: クリーンアップ（30分）

1. **既存ディレクトリ削除**
   ```bash
   rm -rf nvim zsh wezterm starship vim vscode
   rm -f sync_all_configs.sh
   ```

2. **.gitignore更新**
   - 必要に応じてlegacy/を追加

3. **コミット**
   ```bash
   git add -A
   git commit -m "Migrate to Nix + Home Manager"
   git push
   ```

## トラブルシューティング

### Neovimプラグインが動作しない

- `~/.config/nvim`が正しくリンクされているか確認
  ```bash
  ls -la ~/.config/nvim
  ```
- lazy.nvimのプラグイン同期を実行
  ```bash
  nvim
  :Lazy sync
  ```

### Zshのカスタム関数が動作しない

- fzf, fd, ezaがインストールされているか確認
  ```bash
  which fzf fd eza
  ```
- .zshrcが読み込まれているか確認
  ```bash
  echo $ZSH_VERSION
  type nvf
  ```

### Java環境が動作しない

- JAVA_HOMEが正しく設定されているか確認
  ```bash
  echo $JAVA_HOME
  java -version
  ```
- jdt-language-serverのパスが正しいか確認
  ```bash
  ls ~/jdt-language-server-*/bin
  ```

### nix-darwinビルドエラー

- flake.lockを削除して再生成
  ```bash
  rm flake.lock
  nix flake update
  ```
- キャッシュをクリア
  ```bash
  nix-collect-garbage -d
  ```

## 今後の拡張

### jdt-language-serverのNix管理（将来的に）

現在はjdt-language-serverを手動でインストールしていますが、Nix化する場合：

```nix
# home/packages.nix
home.packages = with pkgs; [
  jdt-language-server
];

home.sessionVariables = {
  PATH = "$PATH:${pkgs.jdt-language-server}/bin";
};
```

### その他の設定追加

- vim, vscode設定もNix化する場合は、home/vim.nix, home/vscode.nixを作成
- Obsidian CSSもhome.fileで管理可能
- squid設定もdarwin/services.nixで管理可能

## 重要な注意点

1. **hostname の確認**: flake.nix内のホスト名を必ず実際のマシン名に置換してください
2. **メールアドレス**: home/git.nixのメールアドレスを実際の値に置換してください
3. **lombok.jar**: sha256ハッシュを実際の値に置換してください
4. **バックアップ**: legacy/ディレクトリは削除せず、動作確認完了まで保持してください
5. **Java PATH**: jdt-language-serverのパスが変わる可能性があるため、必要に応じて調整してください

## 所要時間見積もり

- Phase 1: 30分（準備）
- Phase 2: 2時間（基盤構築）
- Phase 3: 1時間（設定ファイル移行）
- Phase 4: 1時間（パッケージ設定）
- Phase 5: 2時間（各モジュール実装）
- Phase 6: 1時間（ビルドとデプロイ）
- Phase 7: 1時間（検証）
- Phase 8: 30分（クリーンアップ）

**合計: 約9時間**（土曜日1日で完了可能）

## 実装後の日常運用

### 設定変更時

1. config/配下のファイルを直接編集
2. darwin-rebuildで反映
   ```bash
   darwin-rebuild switch --flake ~/Documents/workspace/dotfiles
   ```

### パッケージ追加時

1. home/packages.nixを編集
2. darwin-rebuildで反映

### システム設定変更時

1. darwin/system.nixを編集
2. darwin-rebuildで反映

### プラグイン管理

- **Neovim**: lazy.nvim経由で管理（従来通り）
- **Zsh**: zinit経由で管理（従来通り）

これにより、従来のワークフローを大きく変えずにNixの恩恵を受けられます。
