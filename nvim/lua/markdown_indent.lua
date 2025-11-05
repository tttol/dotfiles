local M = {}

-- Check if the current line is a bullet list item
local function is_bullet_line(line)
    return line:match("^%s*[%-%*%+]%s") ~= nil
end

-- Indent bullet list item
function M.indent_bullet()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()
    if is_bullet_line(line) then
        local new_line = "  " .. line
        vim.api.nvim_set_current_line(new_line)
        vim.api.nvim_win_set_cursor(0, {line_num, vim.api.nvim_win_get_cursor(0)[2] + 2})
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end
end

-- Unindent bullet list item
function M.unindent_bullet()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()
    if is_bullet_line(line) then
        local new_line = line:gsub("^  ", "", 1)
        if new_line ~= line then
            vim.api.nvim_set_current_line(new_line)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            vim.api.nvim_win_set_cursor(0, {line_num, math.max(0, col - 2)})
        end
    end
end

return M
