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
    pattern = { "markdown", "mdx" },
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

-- Register mdx as a filetype and use markdown parser
vim.filetype.add({
  extension = {
    mdx = 'mdx',
  },
})
vim.treesitter.language.register('markdown', 'mdx')
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

        -- Java syntax colors
        vim.api.nvim_set_hl(0, "@lsp.type.annotation.java", { fg = "#bfbc80" })
        vim.api.nvim_set_hl(0, "@keyword.import.java", { fg = "#ff9e64" })

        -- JavaScript and TypeScript syntax colors
        local script_languages = { "javascript", "typescript", "tsx" }
        local script_lsp_filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        }
        for _, language in ipairs(script_languages) do
            vim.api.nvim_set_hl(0, "@keyword." .. language, { fg = "#bb9af7", italic = true })
            vim.api.nvim_set_hl(0, "@keyword.import." .. language, { fg = "#ff9e64", italic = true })
            vim.api.nvim_set_hl(0, "@keyword.type." .. language, { fg = "#2ac3de", italic = true })
            vim.api.nvim_set_hl(0, "@keyword.modifier." .. language, { fg = "#bb9af7", italic = true })
            vim.api.nvim_set_hl(0, "@keyword.operator." .. language, { fg = "#bb9af7" })
            vim.api.nvim_set_hl(0, "@keyword.return." .. language, { fg = "#bb9af7", italic = true })
            vim.api.nvim_set_hl(0, "@operator." .. language, { fg = "#bb9af7" })
            vim.api.nvim_set_hl(0, "@type." .. language, { fg = "#2ac3de" })
            vim.api.nvim_set_hl(0, "@type.builtin." .. language, { fg = "#2ac3de", italic = true })
            vim.api.nvim_set_hl(0, "@constructor." .. language, { fg = "#2ac3de" })
            vim.api.nvim_set_hl(0, "@function." .. language, { fg = "#7aa2f7" })
            vim.api.nvim_set_hl(0, "@function.call." .. language, { fg = "#7aa2f7" })
            vim.api.nvim_set_hl(0, "@function.method." .. language, { fg = "#e0af68" })
            vim.api.nvim_set_hl(0, "@function.method.call." .. language, { fg = "#e0af68" })
            vim.api.nvim_set_hl(0, "@variable." .. language, { fg = "#7aa2f7" })
            vim.api.nvim_set_hl(0, "@variable.parameter." .. language, { fg = "#e0af68" })
            vim.api.nvim_set_hl(0, "@variable.member." .. language, { fg = "#9ece6a" })
            vim.api.nvim_set_hl(0, "@module." .. language, { fg = "#7aa2f7" })
        end
        for _, language in ipairs(script_lsp_filetypes) do
            vim.api.nvim_set_hl(0, "@lsp.type.keyword." .. language, { fg = "#bb9af7", italic = true })
            vim.api.nvim_set_hl(0, "@lsp.type.type." .. language, { fg = "#2ac3de" })
            vim.api.nvim_set_hl(0, "@lsp.type.class." .. language, { fg = "#2ac3de" })
            vim.api.nvim_set_hl(0, "@lsp.type.enum." .. language, { fg = "#2ac3de" })
            vim.api.nvim_set_hl(0, "@lsp.type.interface." .. language, { fg = "#2ac3de" })
            vim.api.nvim_set_hl(0, "@lsp.type.typeParameter." .. language, { fg = "#2ac3de" })
            vim.api.nvim_set_hl(0, "@lsp.type.function." .. language, { fg = "#7aa2f7" })
            vim.api.nvim_set_hl(0, "@lsp.type.method." .. language, { fg = "#e0af68" })
            vim.api.nvim_set_hl(0, "@lsp.type.variable." .. language, { fg = "#7aa2f7" })
            vim.api.nvim_set_hl(0, "@lsp.type.parameter." .. language, { fg = "#e0af68" })
            vim.api.nvim_set_hl(0, "@lsp.type.property." .. language, { fg = "#9ece6a" })
            vim.api.nvim_set_hl(0, "@lsp.type.namespace." .. language, { fg = "#7aa2f7" })
            vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly." .. language, { fg = "#7aa2f7" })
        end
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

-- Floating terminal function
local floating_term_buf = nil
local floating_term_win = nil

local function toggle_floating_terminal()
    if floating_term_win and vim.api.nvim_win_is_valid(floating_term_win) then
        vim.api.nvim_win_close(floating_term_win, true)
        floating_term_win = nil
        return
    end
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    if not floating_term_buf or not vim.api.nvim_buf_is_valid(floating_term_buf) then
        floating_term_buf = vim.api.nvim_create_buf(false, true)
    end
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded'
    }
    floating_term_win = vim.api.nvim_open_win(floating_term_buf, true, opts)
    if vim.bo[floating_term_buf].buftype ~= 'terminal' then
        vim.fn.jobstart(vim.o.shell, {term = true})
    end
    vim.api.nvim_buf_set_keymap(floating_term_buf, 't', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
    vim.cmd('startinsert')
end

-- Map Ctrl+z to toggle floating terminal in normal, insert, and visual modes
vim.keymap.set('n', '<C-z>', toggle_floating_terminal, { noremap = true, silent = true })
vim.keymap.set('i', '<C-z>', toggle_floating_terminal, { noremap = true, silent = true })
vim.keymap.set('v', '<C-z>', toggle_floating_terminal, { noremap = true, silent = true })
vim.keymap.set('t', '<C-z>', toggle_floating_terminal, { noremap = true, silent = true })

-- fzf-lua
vim.cmd('cnoreabbrev fzf FzfLua')
vim.cmd('cnoreabbrev ff FzfLua files')
vim.cmd('cnoreabbrev fg FzfLua grep')
vim.cmd('cnoreabbrev fb FzfLua buffers')

-- oil.nvim
vim.cmd('cnoreabbrev oil Oil')
vim.keymap.set('n', '<C-h>', ':bp<CR>', {desc = 'Move to previous buffer'})
vim.keymap.set('n', '<C-l>', ':bn<CR>', {desc = 'Move to next buffer'})

-- lazy
vim.cmd('cnoreabbrev lazy Lazy')

-- lazygit
vim.cmd('cnoreabbrev lg LazyGit')

-- diffview.nvim
vim.cmd('cnoreabbrev do DiffviewOpen')
vim.cmd('cnoreabbrev dc DiffviewClose')
vim.cmd('cnoreabbrev df DiffviewFileHistory')

------------------------------------------------
--- AUTOCMD
------------------------------------------------

--- [jq] prettier JSON
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function ()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
        -- normal mode
        vim.api.nvim_set_keymap('n', '<leader>jq', ':%!jq .<CR>', {buffer = true, desc = "Format JSON strings"})
        -- visual mode
        vim.api.nvim_set_keymap('v', '<leader>jq', ":'<,'>!jq .<CR>", {buffer = true, desc = "Format JSON strings"})
    end,
})

-- [IME] Turn off IME when normal mode
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
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
