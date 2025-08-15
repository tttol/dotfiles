return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    build = function()
         require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    main = 'nvim-treesitter.configs',
     opts = {
         ensure_installed = { "markdown", "markdown_inline", "html", "typescript", "javascript", "java", "css", "lua", "python", "go", "yaml", "toml", "json" },
         auto_install = true,
         highlight = {
             enable = true,
 --            additional_vim_regex_highlighting = false,
         },
     },
}
