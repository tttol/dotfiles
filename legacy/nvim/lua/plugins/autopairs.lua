return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
        local npairs = require('nvim-autopairs')
        npairs.setup({
            check_ts = true,
            map_cr = false,
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
        local remap = vim.api.nvim_set_keymap
        local npairs_ok, _ = pcall(require, 'nvim-autopairs')
        if npairs_ok then
            _G.MUtils = {}
            MUtils.CR = function()
                if vim.fn.pumvisible() ~= 0 then
                    return vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
                else
                    return npairs.autopairs_cr()
                end
            end
            remap('i', '<CR>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })
        end
    end
}
