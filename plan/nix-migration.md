# dotfiles Nix + Home Manager 移行計画（簡易版）

## 概要

現在のdotfilesをNix + Home Managerで管理する構成に移行します。

**方針**: **設定ファイルの配置のみをNixで管理**
- パッケージのインストールは管理しない（既存のHomebrewやその他の方法を継続使用）
- システム設定（Dock, Finder等）は管理しない
- 設定ファイル（.zshrc, init.lua, .wezterm.lua等）をHome Managerで配置

## 目標ディレクトリ構造

```
dotfiles/
├── flake.nix                    # Home Manager standalone構成
├── flake.lock                   # 依存バージョン固定
├── home.nix                     # 設定ファイル配置定義
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
  description = "tttol's dotfiles managed by Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."tttol" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [ ./home.nix ];
    };
  };
}
```

### 2. home.nix

```nix
{ config, pkgs, ... }: {
  home.username = "tttol";
  home.homeDirectory = "/Users/tttol";
  home.stateVersion = "24.05";

  # Neovim設定
  home.file.".config/nvim" = {
    source = ./config/nvim;
    recursive = true;
  };

  # WezTerm設定
  home.file.".wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
  };

  # Zsh設定
  home.file.".zshrc" = {
    source = ./config/zsh/.zshrc;
  };

  # Starship設定
  home.file.".config/starship.toml" = {
    source = ./config/starship/starship.toml;
  };

  programs.home-manager.enable = true;
}
```

## 段階的実装手順

### Phase 1: 準備（15分）

1. **Nixインストール確認**
   ```bash
   nix --version
   ```
   未インストールの場合:
   ```bash
   curl -L https://nixos.org/nix/install | sh
   ```

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

### Phase 2: 基盤構築（30分）

1. **新規ディレクトリ作成**
   ```bash
   mkdir -p config/{nvim,wezterm,zsh,starship}
   ```

2. **flake.nix作成**
   - 上記のflake.nixの内容を実装

3. **home.nix作成**
   - 上記のhome.nixの内容を実装

### Phase 3: 設定ファイル移行（30分）

1. **config/配下に設定をコピー**
   ```bash
   cp -r nvim/* config/nvim/
   cp wezterm/.wezterm.lua config/wezterm/wezterm.lua
   cp zsh/.zshrc config/zsh/.zshrc
   cp starship/starship.toml config/starship/starship.toml
   ```

### Phase 4: ビルドとデプロイ（30分）

1. **flake.lock生成**
   ```bash
   nix flake update
   ```

2. **初回ビルド**
   ```bash
   nix build .#homeConfigurations.tttol.activationPackage
   ```

3. **Home Manager適用**
   ```bash
   ./result/activate
   ```

4. **エイリアス設定（オプション）**
   - .zshrcに追加:
     ```bash
     alias home-rebuild='home-manager switch --flake ~/Documents/workspace/dotfiles'
     ```

### Phase 5: 検証（15分）

1. **シンボリックリンク確認**
   ```bash
   ls -la ~/.config/nvim
   ls -la ~/.wezterm.lua
   ls -la ~/.zshrc
   ls -la ~/.config/starship.toml
   ```

2. **設定ファイル確認**
   - 各設定ファイルが正しくリンクされているか確認
   - Neovim, WezTerm, Zshを起動して動作確認

### Phase 6: クリーンアップ（15分）

1. **既存ディレクトリ削除**
   ```bash
   rm -rf nvim zsh wezterm starship vim vscode
   rm -f sync_all_configs.sh
   ```

2. **.gitignore更新**
   ```bash
   echo "result" >> .gitignore
   echo "legacy/" >> .gitignore
   ```

3. **コミット**
   ```bash
   git add -A
   git commit -m "Migrate to Nix + Home Manager (dotfiles only)"
   git push
   ```

## トラブルシューティング

### シンボリックリンクが作成されない

- 既存ファイルが残っている可能性があります。削除してから再度適用:
  ```bash
  rm ~/.config/nvim
  rm ~/.wezterm.lua
  rm ~/.zshrc
  ./result/activate
  ```

### Neovim設定が読み込まれない

- `~/.config/nvim`のシンボリックリンクを確認:
  ```bash
  ls -la ~/.config/nvim
  readlink ~/.config/nvim
  ```

### flake checkエラー

- flake.nixの構文確認:
  ```bash
  nix flake check --show-trace
  ```

## 所要時間見積もり

- Phase 1: 15分（準備）
- Phase 2: 30分（基盤構築）
- Phase 3: 30分（設定ファイル移行）
- Phase 4: 30分（ビルドとデプロイ）
- Phase 5: 15分（検証）
- Phase 6: 15分（クリーンアップ）

**合計: 約2時間15分**

## 実装後の日常運用

### 設定変更時

1. config/配下のファイルを直接編集
2. Home Managerで反映
   ```bash
   home-manager switch --flake ~/Documents/workspace/dotfiles
   ```

### 新しい設定ファイル追加時

1. config/配下に新しいファイルを追加
2. home.nixに`home.file`エントリを追加
3. Home Managerで反映

### パッケージ管理

- パッケージ（eza, fzf, neovim等）は従来通りHomebrewやその他の方法で管理
- Nixでは設定ファイルの配置のみを管理

## 利点

- **シンプル**: 設定ファイルの配置のみを管理するため、学習コストが低い
- **既存ツールと共存**: Homebrew等の既存パッケージ管理と競合しない
- **バージョン管理**: Git + Nixで設定ファイルの履歴を管理
- **再現性**: 同じflakeから同じ設定を複製可能

## 今後の拡張（オプション）

必要に応じて、以下を追加可能:

### 他の設定ファイル追加

```nix
# home.nix
home.file.".vimrc" = {
  source = ./config/vim/.vimrc;
};

home.file.".gitconfig" = {
  source = ./config/git/.gitconfig;
};
```

### Obsidian CSS追加

```nix
home.file."Library/Mobile Documents/iCloud~md~obsidian/Documents/tttol-icloud-vault/.obsidian/snippets/customizes.css" = {
  source = ./config/obsidian/customizes.css;
};
```

### 環境変数のみ追加（パッケージなし）

```nix
home.sessionVariables = {
  JAVA_HOME = "/Library/Java/JavaVirtualMachines/amazon-corretto-25.jdk/Contents/Home";
  SPRING_PROFILES_ACTIVE = "local";
};
```

## 重要な注意点

1. **既存ファイルの削除**: Home Managerはシンボリックリンクを作成するため、既存の設定ファイルは削除する必要があります
2. **バックアップ**: legacy/ディレクトリは動作確認完了まで削除しないでください
3. **パッケージ管理の分離**: この構成ではパッケージ管理はNixで行いません。既存のHomebrew等を継続使用してください
