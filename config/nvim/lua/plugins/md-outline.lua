return {
  'tttol/md-outline.nvim',
  config = function()
    require("md-outline").setup({
      auto_open = false
    })
  end,
}
-- return {
--   dir = "~/Documents/workspace/md-outline.nvim",
--   name = "md-outline",
--   dev = true,
--   -- lazy = false,  -- 即座に読み込む
--   -- config = function()
--   --   require("md-outline").setup({
--   --     -- オプション
--   --   })
--   -- end,
-- }
