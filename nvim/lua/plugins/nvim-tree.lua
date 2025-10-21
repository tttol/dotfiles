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
            update_cwd = false,
            ignore_list = {},
        },
        on_attach = function(bufnr)
            local api = require('nvim-tree.api')
            
            -- Default mappings
            api.config.mappings.default_on_attach(bufnr)
            
            -- Remove q mapping
            vim.keymap.del('n', 'q', { buffer = bufnr })

            -- Custom buffer navigation
            vim.keymap.set('n', '<C-h>', '<C-w>h', { buffer = bufnr, desc = 'Move to left buffer' })
            vim.keymap.set('n', '<C-l>', '<C-w>l', { buffer = bufnr, desc = 'Move to right buffer' })
        end
    }
  end,
}
