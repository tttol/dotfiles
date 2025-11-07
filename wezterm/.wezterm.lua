-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- font
config.font_size =14
config.font = wezterm.font 'CommitMono Nerd Font'

---- tab appearance ----

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#5c6d74"
    local foreground = "#FFFFFF"

    -- highlight active tab
    if tab.is_active then
        background = "#4287f5"
        foreground = "#FFFFFF"
    end


    local icon = wezterm.nerdfonts.md_console_network
    if tab.active_pane.title == "nv" then
        icon = wezterm.nerdfonts.linux_neovim
    elseif tab.active_pane.title == "zsh" then
        icon = wezterm.nerdfonts.dev_terminal
    elseif tab.active_pane.title == "Python" or string.find(tab.active_pane.title, "python") then
        icon = wezterm.nerdfonts.dev_python
    elseif tab.active_pane.title == "node" or string.find(tab.active_pane.title, "node") then
        icon = wezterm.nerdfonts.md_language_typescript
    elseif tab.active_pane.title == "docker" or string.find(tab.active_pane.title, "docker") then
        icon = wezterm.nerdfonts.md_docker
    end
    return {
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text =  "  " .. "⌘".. (tab.tab_index + 1) .. " " .. icon .. ": " .. tab.active_pane.title .. " " },
    }
end)


config.initial_cols = 120
config.initial_rows = 28
-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'Tokyo Night'

return config
