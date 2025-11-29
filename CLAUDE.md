# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

これは個人的なdotfilesリポジトリで、macOS環境における各種ツールの設定ファイルを管理しています。各ディレクトリが対応するツールの設定を含んでいます。

## Directory Structure

- `nvim/` - Neovim設定（lazy.nvimベースのプラグイン管理）
- `zsh/` - Zsh設定（Oh My Zsh使用）
- `wezterm/` - WezTerm ターミナルエミュレータ設定
- `vim/` - Vim設定
- `vscode/` - Visual Studio Code設定
- `claude/` - Claude Code設定とカスタムコマンド
- `obsidian/` - Obsidianカスタマイズ
- `google-ja-input/` - Google日本語入力キーマップ
- `squid/` - Squid Proxy設定

## Configuration Synchronization Scripts

設定ファイルを実際の場所からこのリポジトリにコピーするためのスクリプト:

- `nvim/copy_nvim_config.sh` - `~/.config/nvim/` から nvim設定をコピー
- `obsidian/copy_obsidian_config.sh` - `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/tttol-icloud-vault/.obsidian/snippets/customizes.css` から Obsidianカスタマイズをコピー

これらのスクリプトは、各ディレクトリの既存ファイルを削除してから最新の設定をコピーします。

## Environment Details

### Zsh Configuration (.zshrc)
- **プロンプト**: カスタムプロンプト（緑背景でユーザー名とパス表示）
- **プラグインマネージャ**: Oh My Zsh
- **プラグイン**: git, zsh-autosuggestions, aliases
- **重要なエイリアス**:
  - `nv` → `nvim`
  - `ll` → `eza --icons -al` (exa使用)
  - `icloud` → Obsidian vaultへの移動
- **ツール統合**:
  - Starship (プロンプトテーマ)
  - zoxide (ディレクトリ移動)
  - Bun (JavaScriptランタイム)
- **環境変数**:
  - `JAVA_HOME`: Amazon Corretto 21
  - `SPRING_PROFILES_ACTIVE=local`

### Neovim Configuration
詳細は `nvim/CLAUDE.md` を参照。
- lazy.nvimによるプラグイン管理
- Leader key: `<Space>`
- カスタムキーバインド: `e` → `$`

### WezTerm Configuration
- **カラースキーム**: Tokyo Night
- **フォント**: CommitMono Nerd Font (14pt)
- **ペイン分割**:
  - `Cmd+\` - 左右分割
  - `Cmd+Shift+\` - 上下分割
- **ペイン移動**: `Cmd+h/j/k/l`
- **ペインサイズ調整**: `Cmd+矢印キー`
- **タブバー**: カスタムカラーリング（アクティブタブ: #72a7fc）

## Working with this Repository

### 設定ファイルの更新
1. 実際の設定ファイルを編集
2. 対応するコピースクリプトを実行してリポジトリに同期
3. gitでコミット・プッシュ

### 新規環境へのセットアップ
各ディレクトリの設定ファイルを対応する場所にコピーまたはシンボリックリンクを作成します。

## Important Notes

- このリポジトリには `shrc/` ディレクトリが削除されています（git status参照）
- 新しい `zsh/` ディレクトリが追加されています
- 設定ファイルの編集時は、実際の配置場所（~/.config/、~/.zshrcなど）を意識する必要があります
