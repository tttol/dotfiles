-- lazy.vim
require("config.lazy")

-- General
vim.opt.clipboard = "unnamedplus" -- Sync with OS clipboard
vim.opt.number = true             -- Show line numbers
vim.opt.encoding = "utf-8"
vim.opt.tabstop = 4               -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4            -- Number of spaces for auto-indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
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

-- Diagnostic colors (set after colorscheme to avoid override)
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#FFB3BA" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#878103" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#b30000" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#878103" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#b30000", undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = "#878103", undercurl = true })

-- Keybindings
-- vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<C-u>', '10<C-u>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-d>', '10<C-d>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'e', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'e', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-[>', '<C-o>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-]>', '<C-i>', { silent = true })
vim.api.nvim_set_keymap('n', '<Esc>', '<Nop>', { noremap = true, silent = true }) -- Not to go prev buffer when entering <Esc>
vim.api.nvim_set_keymap('n', '<leader>w', ':wa<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wq', ':wq<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':qa<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>', { noremap = true, silent = true })

-- -- Auto closing tag for HTML
-- vim.api.nvim_create_augroup("MyXML", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--     group = "MyXML",
--     pattern = "html",
--     callback = function()
--         vim.keymap.set("i", "</", "</<C-x><C-o><ESC>F>a<CR><ESC>O", { buffer = true })
--     end,
-- })

-- lualine setup
require('lualine').setup {
    options = { theme = 'onedark' }
}

-- LSP(lsp/init.lua)
require('lsp')
