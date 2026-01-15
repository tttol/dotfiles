return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = { theme = 'gruvbox' },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                    }
                },
                lualine_x = {
                    {
                        function()
                            return _G.get_lsp_progress()
                        end,
                        cond = function()
                            return _G.get_lsp_progress() ~= ''
                        end,
                    },
                    'encoding',
                    'fileformat',
                    'filetype'
                },
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
        })
    end,
}
