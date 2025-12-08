-- Set completion options for all LSPs
vim.cmd [[set completeopt+=menuone,noselect,popup]]

-- LSP progress handler
local progress = {}

-- Global function to get LSP progress status for statusline
function _G.get_lsp_progress()
    local messages = {}
    for _, p in pairs(progress) do
        local msg = string.format("[%s] %s", p.client_name, p.title)
        if p.message ~= '' then
            msg = msg .. ': ' .. p.message
        end
        if p.percentage then
            msg = msg .. string.format(' (%d%%)', p.percentage)
        end
        table.insert(messages, msg)
    end
    return table.concat(messages, ' | ')
end

vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local token = args.data.params.token
        local value = args.data.params.value

        if value.kind == 'begin' then
            progress[token] = {
                title = value.title,
                message = value.message or '',
                percentage = value.percentage or 0,
                client_name = client.name
            }
        elseif value.kind == 'report' then
            if progress[token] then
                progress[token].message = value.message or progress[token].message
                progress[token].percentage = value.percentage or progress[token].percentage
            end
        elseif value.kind == 'end' then
            progress[token] = nil
        end

        vim.cmd('redrawstatus')
    end
})

-- Show LSP client status on attach
-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         if client then
--             vim.notify(string.format('LSP attached: %s', client.name), vim.log.levels.INFO, {
--                 title = 'LSP Status',
--                 timeout = 2000,
--                 animate = false,
--                 stage = 'static'
--             })
--         end
--     end
-- })

-- LSP attach autocmd for common configuration
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method('textDocument/completion') then
            if client.server_capabilities.completionProvider then
                -- Optional: trigger autocompletion on EVERY keypress. May be slow!
                local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
                client.server_capabilities.completionProvider.triggerCharacters = chars

                -- Extend existing trigger characters
                local existing_chars = client.server_capabilities.completionProvider.triggerCharacters or {}
                local additional_chars = { '.', ':', '->', '::', '(', '[', '{', ' ' }
                for _, char in ipairs(additional_chars) do
                    table.insert(existing_chars, char)
                end
                client.server_capabilities.completionProvider.triggerCharacters = existing_chars
            end

            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
                convert = function(item)
                    return { abbr = item.label:gsub('%b()', '') }
                end,
            })
        end

        -- Auto-format on save
        -- if not client:supports_method('textDocument/willSaveWaitUntil')
        --     and client:supports_method('textDocument/formatting') then
        --     vim.api.nvim_create_autocmd('BufWritePre', {
        --         group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        --         buffer = args.buf,
        --         callback = function()
        --             vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        --         end,
        --     })
        -- end

        -- Common keymaps
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float,
            vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Jump to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
            vim.tbl_extend("force", opts, { desc = "Jump to declaration" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts, { desc = "Jump to implementation" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition,
            vim.tbl_extend("force", opts, { desc = "Jump to type definition" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls,
            vim.tbl_extend("force", opts, { desc = "Show incoming calls" }))
        vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls,
            vim.tbl_extend("force", opts, { desc = "Show outgoing calls" }))

        -- Tab completion keymaps
        vim.keymap.set("i", "<Tab>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-n>"
            else
                return "<Tab>"
            end
        end, vim.tbl_extend("force", opts, { expr = true, desc = "Tab completion" }))

        vim.keymap.set("i", "<S-Tab>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-p>"
            else
                return "<S-Tab>"
            end
        end, vim.tbl_extend("force", opts, { expr = true, desc = "Shift-Tab completion" }))

        vim.keymap.set("i", "<CR>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-y>"
            else
                return "<CR>"
            end
        end, vim.tbl_extend("force", opts, { expr = true, desc = "Enter completion confirm" }))

        vim.opt_local.pumheight = 10 -- Limit popup menu height
    end,
})

-- Common on_attach function for LSPs (kept for compatibility)
-- local common_on_attach = function(client, bufnr)
    -- This function is now mostly handled by LspAttach autocmd above
-- end

local current_dir = vim.fn.stdpath('config') .. '/lua/lsp'
local lsp_names = {}

-- ```
-- vim.lsp.config("jdtls")
-- vim.lsp.enable("jdtls")
-- ```
--
-- 上記2行分の設定をlsp/*.luaを満たす全てのluaファイルに対して実行する
-- https://zenn.dev/kawarimidoll/books/6064bf6f193b51/viewer/018161
for file, ftype in vim.fs.dir(current_dir) do
    -- end with `.lua` except init.lua
    if ftype == 'file' and vim.endswith(file, '.lua') and file ~= 'init.lua' then
        local lsp_name = file:sub(1, -5) -- fname without '.lua'
        local ok, result = pcall(require, 'lsp.' .. lsp_name)
        if ok then
            -- Merge common on_attach with LSP-specific config
            if result.on_attach then
                local original_on_attach = result.on_attach
                result.on_attach = function(client, bufnr)
                    -- common_on_attach(client, bufnr)
                    original_on_attach(client, bufnr)
                end
            -- else
                -- result.on_attach = common_on_attach
            end

            -- Load LSP configuration
            vim.lsp.config(lsp_name, result)
            table.insert(lsp_names, lsp_name)
        else
            vim.notify('Error loading LSP: ' .. lsp_name .. '\n' .. result, vim.log.levels.WARN)
        end
    end
end

vim.lsp.enable(lsp_names)

-- Force override Tab completion for all filetypes after all plugins load
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
        vim.schedule(function()
            local opts = { buffer = args.buf, noremap = true, silent = true }
            vim.keymap.set("i", "<Tab>", function()
                if vim.fn.pumvisible() == 1 then
                    return "<C-n>"
                else
                    return "<Tab>"
                end
            end, vim.tbl_extend("force", opts, { expr = true, desc = "LSP Tab completion override" }))

            vim.keymap.set("i", "<S-Tab>", function()
                if vim.fn.pumvisible() == 1 then
                    return "<C-p>"
                else
                    return "<S-Tab>"
                end
            end, vim.tbl_extend("force", opts, { expr = true, desc = "LSP Shift-Tab completion override" }))

            -- vim.keymap.set("i", "<CR>", function()
            --     if vim.fn.pumvisible() == 1 then
            --         return "<C-y>"
            --     else
            --         return "<CR>"
            --     end
            -- end, vim.tbl_extend("force", opts, { expr = true, desc = "LSP Enter completion override" }))
        end)
    end,
})
