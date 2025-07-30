require("config.lazy")

-- Global settings
vim.opt.encoding = "utf-8"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true    -- Automatically reload if file changes outside Neovim
vim.opt.hidden = true      -- Allow opening other files even if buffer is modified
vim.opt.showcmd = true     -- Show input commands in status line
vim.opt.background = "dark"
vim.opt.guifont = "Menlo-Regular:h13" -- Font setting
vim.opt.number = true      -- Show line numbers
vim.opt.cursorline = true  -- Highlight current line
vim.opt.laststatus = 2     -- Always show status line
vim.opt.hlsearch = true    -- Highlight search matches
vim.opt.clipboard = "unnamedplus" -- Sync with OS clipboard

-- Keybindings
vim.api.nvim_set_keymap('n', 'e', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'e', '$', { noremap = true, silent = true })

-- Set line number color to gray
vim.api.nvim_set_hl(0, "LineNr", { fg = "gray"})
