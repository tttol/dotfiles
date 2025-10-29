return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
        require('render-markdown').setup({
            heading = {
                enabled = true,
                render_modes = false,
                atx = true,
                setext = true,
                sign = false,
                icons = {},
                position = 'overlay',
                width = 'full',
                left_margin = 0,
                left_pad = 0,
                right_pad = 0,
                min_width = 0,
                border = true,
                border_virtual = false,
                border_prefix = false,
                above = '▄',
                below = '▀',
                backgrounds = {
                    'RenderMarkdownH3Bg',
                    'RenderMarkdownH3Bg',
                    'RenderMarkdownH3Bg',
                    'RenderMarkdownH3Bg',
                    'RenderMarkdownH3Bg',
                    'RenderMarkdownH3Bg',
                },
                foregrounds = {
                    'RenderMarkdownH1',
                    'RenderMarkdownH2',
                    'RenderMarkdownH3',
                    'RenderMarkdownH4',
                    'RenderMarkdownH5',
                    'RenderMarkdownH6',
                },
                custom = {},
            },
        })
    end
}
