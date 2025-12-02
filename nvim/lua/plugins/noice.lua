return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        cmdline = {
            enabled = true,
            view = "cmdline_popup", -- または "cmdline" でクラシカルなスタイル
        },
        messages = {
            enabled = false,
        },
        popupmenu = {
            enabled = false,
        },
        notify = {
            enabled = false,
        },
        lsp = {
            progress = {
                enabled = false,
            },
            hover = {
                enabled = false,
            },
            signature = {
                enabled = false,
            },
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function(_, opts)
        require("noice").setup(opts)
        require("notify").setup({
            stages = "fade",
            timeout = 3000,
            top_down = false,
            max_width = 30,
        })
    end,
}
