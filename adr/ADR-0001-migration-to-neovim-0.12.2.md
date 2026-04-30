# Migration to Neovim 0.12.2
2026/04/30: I have migrated Neovim 0.11.x -> 0.12.2. This is the ADR of it.

## Difference Between Neovim 0.11.x and 0.12.2

In Neovim 0.11.x, many users commonly enabled Treesitter features through `nvim-treesitter.configs`, for example:

```lua
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
})
```

In Neovim 0.12.2, the preferred direction is to use Neovim's built-in Treesitter APIs directly:

```lua
vim.treesitter.start()
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"
```

The important difference is the responsibility split. In the old setup, `nvim-treesitter` was often treated as the plugin that enabled Treesitter highlighting. In this setup, Neovim itself enables and runs highlighting/folding, while `nvim-treesitter` is used mainly to install and update parsers and queries.

## What Neovim Itself Does

Neovim provides the runtime features that use Treesitter data.

In this configuration, Neovim itself does the following:

- Starts Treesitter highlighting with `vim.treesitter.start()`.
- Uses Treesitter-based folding with `vim.treesitter.foldexpr()`.
- Reads installed parsers and queries from the runtime path.
- Applies highlight, fold, and injection behavior based on installed query files.

Neovim does not automatically install every parser for every language. It also does not build parser binaries from parser source code by itself.

## What Neovim Itself Does Not Do

Neovim does not manage the full parser/query lifecycle.

It does not do the following:

- Download parser source repositories.
- Build parser binaries.
- Install parser/query files for every language automatically.
- Keep parser/query files updated.
- Provide sticky code context UI like `nvim-treesitter-context`.
- Provide Markdown rendering UI like `render-markdown.nvim`.

Those responsibilities are handled by external tools and plugins.

## Where the Parser Function Lives

A parser is the language-specific component that reads source code and produces a syntax tree.

For example:

```text
Lua source code
  -> Lua parser
  -> Lua syntax tree
```

```text
Markdown source code
  -> Markdown parser
  -> Markdown syntax tree
```

The parser function lives in the installed Tree-sitter parser binary for each language. These parser binaries are usually installed as compiled shared libraries such as `lua.so`, `python.so`, or `markdown.so`.

Neovim loads those parser binaries when `vim.treesitter.start()` is called for a buffer. If the parser for a filetype is missing, Neovim cannot provide Treesitter-based highlighting or folding for that language.

In this repository, parser installation is managed through:

```vim
:TSInstallConfigured
```

This command installs the parser list defined in `config/nvim/lua/plugins/treesitter.lua`.

## Where the Query Function Lives

A query tells Neovim how to use the syntax tree produced by a parser.

The parser only creates structure. It does not decide which nodes should be highlighted, folded, or treated as embedded languages. Queries define those rules.

Common query files include:

- `highlights.scm`: Defines syntax highlight captures.
- `folds.scm`: Defines fold regions.
- `injections.scm`: Defines embedded languages, such as code blocks inside Markdown.
- `indents.scm`: Defines Treesitter-based indentation rules.
- `locals.scm`: Defines scope and symbol information for other tooling.

For example, a parser can identify a function name in the syntax tree. A highlight query can then mark that node as `@function`, and Neovim can render it with the configured highlight group.

Query files live in the Neovim runtime path. They can come from plugins, installed query repositories, or local overrides under the Neovim config directory.

## What nvim-treesitter Does

In this configuration, `nvim-treesitter` is not responsible for enabling highlighting directly.

Its main responsibilities are:

- Install Tree-sitter parsers.
- Install query files for supported languages.
- Update installed parsers and queries through `:TSUpdate`.
- Use the parser registry to know where parser/query sources come from.

This repository uses:

```lua
"neovim-treesitter/nvim-treesitter"
```

with:

```lua
dependencies = { "neovim-treesitter/treesitter-parser-registry" }
```

Parser installation is intentionally not run automatically during normal Neovim startup. Running parser builds during startup can interrupt editing if `tree-sitter-cli` is missing or if a parser build fails.

Instead, this repository provides:

```vim
:TSInstallConfigured
```

Use this command after installing `tree-sitter-cli`.

## tree-sitter CLI

The `tree-sitter` CLI is required to build parser binaries.

Install it with:

```bash
cargo install tree-sitter-cli
```

After that, open Neovim and run:

```vim
:TSInstallConfigured
```

The flow is:

```text
source code
  -> parser
  -> syntax tree
  -> query
  -> Neovim highlight / fold / injection
```

The practical split is:

```text
Neovim
  -> Uses parsers and queries.
  -> Runs highlighting and folding.

nvim-treesitter
  -> Installs and updates parsers and queries.

tree-sitter CLI
  -> Builds parser binaries.
```
