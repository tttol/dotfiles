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
            "html_tag",
            "superhtml",
            "typescript",
            "tsx",
            "javascript",
            "java",
            "css",
            "lua",
            "python",
            "go",
            "gotmpl",
            "helm",
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
            "typescriptreact",
            "javascript",
            "javascriptreact",
            "java",
            "css",
            "lua",
            "python",
            "go",
            "helm",
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
        vim.cmd.TSInstallConfigured()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetypes,
            callback = function(args)
                -- Neovim itself runs highlighting and folding from installed parser/query files.
                -- Keep yaml available as the injected language for Helm templates.
                local language = vim.bo[args.buf].filetype == "yaml" and "helm" or nil
                pcall(vim.treesitter.start, args.buf, language)
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo.foldmethod = "expr"
                vim.wo.foldlevel = 99
            end,
        })
    end,
}
