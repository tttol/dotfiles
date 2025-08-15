-- lazy.vim
require("config.lazy")

-- General
vim.opt.clipboard = "unnamedplus" -- Sync with OS clipboard
vim.opt.number = true      -- Show line numbers
vim.opt.encoding = "utf-8"
vim.opt.tabstop = 4        -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4     -- Number of spaces for auto-indent
vim.opt.expandtab = true   -- Use spaces instead of tabs
-- Indent
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript",
  "javascriptreact", "typescriptreact" },
    callback = function()
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab = true
    end,
})

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Show leading whitespace
vim.opt.list = true
vim.opt.listchars = { lead = "·", trail = "·", tab = "→ " }

-- Colorscheme
-- vim.cmd.colorscheme("unokai")
vim.cmd.colorscheme("habamax")

-- Keybindings
vim.api.nvim_set_keymap('n', 'e', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'e', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-[>', '<C-o>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-]>', '<C-i>', { silent = true })

-- lualine setup
require('lualine').setup {
  options = { theme  = 'onedark' }
}

