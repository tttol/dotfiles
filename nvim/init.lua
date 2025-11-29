-- lazy.vim
require("config.lazy")

------------------------------------------------
--- GENERAL
------------------------------------------------
vim.opt.clipboard = "unnamedplus" -- Sync with OS clipboard
vim.opt.number = true             -- Show line numbers
vim.opt.encoding = "utf-8"
vim.opt.tabstop = 4               -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4            -- Number of spaces for auto-indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.ignorecase = true         -- Ignore case in search patterns
vim.opt.smartcase = true          -- Override ignorecase if search pattern contains uppercase
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
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.bo.formatoptions = vim.bo.formatoptions .. "ro"
        vim.bo.comments = "b:-,b:*,b:+,b:1."
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

-- Ensure listchars is applied after plugins load
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.opt.list = true
        vim.opt.listchars = { lead = "·", trail = "·", tab = "→ " }
    end,
})

-- Enable relative row number when normal mode
vim.opt.relativenumber = true -- enable relative row number
vim.opt.number = true -- show absolute row number at current row
-- Enable relative row number when switching to normal mode
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = true
    end,
})
-- Disable relative row number when switching to insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = false
    end,
})

------------------------------------------------
--- COLOR
------------------------------------------------

-- ColorScheme適用後にハイライトを設定
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Diagnostic colors
        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#FFB3BA" })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#878103" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#b30000" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#878103" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#b30000", undercurl = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = "#878103", undercurl = true })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#020026" })

        -- Markdown heading colors
        vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#5BA3D0", bold = true })
        vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#5BA3D0", bold = true })
        vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#5BA3D0", bold = true })
        vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#5BA3D0", bold = true })
        vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#5BA3D0", bold = true })
        vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#5BA3D0", bold = true })
 
        -- Highlight current row number
        vim.opt.cursorline = true
        vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ff9e64', bold = true })
    end,
})
-- colorschema
vim.cmd.colorscheme("tokyonight")

------------------------------------------------
--- KEYBINDINGS
------------------------------------------------

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
vim.api.nvim_set_keymap('n', '<leader>ntf', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true }) -- [:terminal] switch to normal mode with <ESC>

------------------------------------------------
--- AUTOCMD
------------------------------------------------

--- [jq] prettier JSON
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function ()
        -- normal mode
        vim.api.nvim_set_keymap('n', '<leader>jq', ':%!jq .<CR>', {buffer = true, desc = "Format JSON strings"})
        -- visual mode
        vim.api.nvim_set_keymap('v', '<leader>jq', ":'<,'>!jq .<CR>", {buffer = true, desc = "Format JSON strings"})
    end,
})

-- [IME] Turn off IME when normal mode
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*.md",
    callback = function()
        vim.fn.system("osascript -e 'tell application \"System Events\" to key code 102'")
    end,
})

-- [:terminal] Start with insert mode
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd("startinsert")
    end,
})

------------------------------------------------
--- SETUP
------------------------------------------------
-- lualine setup
require('lualine').setup {
    options = { theme = 'onedark' }
}

-- LSP(lsp/init.lua)
require('lsp')

-- nvim-colorizer setup
require'colorizer'.setup()
