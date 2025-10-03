return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
        require('nvim-autopairs').setup({
            check_ts = true,
            ts_config = {
                lua = { 'string' },
                javascript = { 'string', 'template_string' },
            },
            disable_filetype = { "TelescopePrompt", "vim" },
            fast_wrap = {
                map = '<M-e>',
                chars = { '{', '[', '(', '"', "'" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = '$',
                keys = 'qwertyuiopzxcvbnmasdfghjkl',
                check_comma = true,
                highlight = 'Search',
                highlight_grey = 'Comment'
            },
        })
        
        -- Force autopairs keymaps after LSP
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                vim.schedule(function()
                    local autopairs = require('nvim-autopairs')
                    autopairs.setup({})
                    
                    -- Force re-setup keymaps
                    local Rule = require('nvim-autopairs.rule')
                    autopairs.clear_rules()
                    autopairs.add_rules(require('nvim-autopairs.rules.basic'))
                end)
            end,
        })
    end
}
