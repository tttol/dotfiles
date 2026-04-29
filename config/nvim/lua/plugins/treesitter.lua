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
        vim.api.nvim_create_user_command("TSInstallConfigured", function()
            require("nvim-treesitter").install(parsers)
        end, {})
        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetypes,
            callback = function()
                pcall(vim.treesitter.start)
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo.foldmethod = "expr"
                vim.wo.foldlevel = 99
            end,
        })
    end,
}
