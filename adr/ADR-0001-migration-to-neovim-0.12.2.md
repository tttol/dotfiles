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

## What Neovim Itself Provides and NOT

Neovim provides the runtime features that use Treesitter data.

✅In this configuration, Neovim itself does the following:

- Starts Treesitter highlighting with `vim.treesitter.start()`.
- Uses Treesitter-based folding with `vim.treesitter.foldexpr()`.
- Reads installed parsers and queries from the runtime path.
- Applies highlight, fold, and injection behavior based on installed query files.

> [!IMPORTANT]
> Neovim does not automatically install every parser for every language. It also does not build parser binaries from parser source code by itself.

⛔️Neovim  does not do the following:

- Download parser source repositories.
- Build parser binaries.
- Install parser/query files for every language automatically.
- Keep parser/query files updated.


Those responsibilities are handled by external tools and plugins.

Explain with acutual source code: 
```lua
-- nvim-treesitter manages parser and query installation.
-- tree-sitter CLI builds parser binaries during installation.
-- Neovim loads installed parsers and applies queries at runtime.
vim.api.nvim_create_user_command("TSInstallConfigured", function()
    require("nvim-treesitter").install(parsers)
end, {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function()
        -- Neovim itself runs highlighting and folding from installed parser/query files.
        pcall(vim.treesitter.start)
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldlevel = 99
    end,
})
```

## What nvim-treesitter Does

In this configuration, `nvim-treesitter` is not responsible for enabling highlighting directly.

Its main responsibilities are:

- Install Tree-sitter parsers.
- Install query files for supported languages.
- Update installed parsers and queries through `:TSUpdate`.
- Use the parser registry to know where parser/query sources come from.

