return {
    "neovim-treesitter/nvim-treesitter",
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "markdown",
            "markdown_inline",
            "html",
            "typescript",
            "javascript",
            "java",
            "css",
            "lua",
            "python",
            "go",
            "yaml",
            "toml",
            "json",
            "rust",
        }
        local filetypes = {
            "markdown",
            "mdx",
            "html",
            "typescript",
            "javascript",
            "java",
            "css",
            "lua",
            "python",
            "go",
            "yaml",
            "toml",
            "json",
            "rust",
        }
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
    end,
}
