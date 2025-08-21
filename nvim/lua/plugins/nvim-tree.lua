return {
  git = {
      unstaged = "•", -- 未保存の変更
      staged = "✓",   -- ステージ済みの変更
      untracked = "?",-- 未追跡のファイル
      renamed = "→",  -- 名前が変更されたファイル
      deleted = "✗",  -- 削除されたファイル
  },
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
        git = {
            ignore = false
        },
        -- focus the file when opening a file
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
    }
  end,
}
