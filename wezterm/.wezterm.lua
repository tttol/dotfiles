-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- font
config.font_size =14
config.font = wezterm.font 'CommitMono Nerd Font'

---- tab appearance ----

-- 平行四辺形のタブスタイル用の傾いた境界線文字
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#5c6d74"
    local foreground = "#FFFFFF"
    local edge_background = "#1a1b26"  -- 背景色（Tokyo Nightのベース色）

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

    local title = "⌘" .. (tab.tab_index + 1) .. " " .. icon .. ": " .. tab.active_pane.title

    -- 平行四辺形のタブデザイン with gaps
    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = background } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = " " .. title .. " " },
        { Background = { Color = edge_background } },
        { Foreground = { Color = background } },
        { Text = SOLID_RIGHT_ARROW },
        { Background = { Color = edge_background } },
        { Text = " " },  -- タブ間の隙間
    }
end)


-- タブバーの設定
config.use_fancy_tab_bar = false  -- カスタムタブスタイルを有効化
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false

config.initial_cols = 120
config.initial_rows = 28
-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'Tokyo Night'

return config
