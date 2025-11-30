return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    notify = {
      enabled = true,
    },
    views = {
      notify = {
        replace = true,
        size = {
          width = 50,
          max_width = 50,
        },
        win_options = {
          wrap = true,
        },
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
