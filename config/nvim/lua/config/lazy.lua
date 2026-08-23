-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
local lazy = require("lazy")
lazy.setup({
    spec = {
        -- import your plugins from `lua/plugins/*.lua`
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- Disable periodic checks because plugins are updated once at launch.
    checker = { enabled = false },
    -- Use writable path for lockfile (Nix store symlink is read-only)
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
    -- disable luarocks support to fix the error
    rocks = {
        enabled = false,
    },
})

vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("lazy_auto_update", { clear = true }),
    pattern = "VeryLazy",
    once = true,
    callback = function()
        if #vim.api.nvim_list_uis() > 0 then
            lazy.update({ show = false })
        end
    end,
})
