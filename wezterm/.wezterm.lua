-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

------------------------------------
--- GENERAL
------------------------------------
config.initial_cols = 120
config.initial_rows = 28
config.color_scheme = 'Tokyo Night'

--- Open link by mouse click
config.mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'SUPER',
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}
-- font
config.font_size =14
-- config.font = wezterm.font 'CommitMono Nerd Font'
config.font = wezterm.font_with_fallback({
    'CommitMono Nerd Font',
    'Hiragino Sans',
    'Arial',
})

------------------------------------
--- TAB
------------------------------------
-- tab appearance
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
local BACKGROUD_COLOR = "#5c6d74"
local FOREGROUND_COLOR = "#fff"
local BACKGROUD_COLOR_ACTIVE = "#72a7fc"

config.tab_max_width = 50

local function determine_tab_backgoround(current_tab)
    if current_tab.is_active then
        return BACKGROUD_COLOR_ACTIVE
    end

    return BACKGROUD_COLOR
end

local function determine_tab_title(tab)
    local pane = tab.active_pane
    local cwd = pane.current_working_dir

    if cwd then
        local path = cwd.file_path or cwd.path or tostring(cwd)
        local home = os.getenv('HOME')

        if path == home then
            return "~"
        end

        -- get last element from path
        local basename = path:match("([^/]+)/?$")

        if basename then
            return basename
        end
    end

    return tab.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = determine_tab_backgoround(tab)
    local foreground = FOREGROUND_COLOR
    local edge_background = "none"
    local edge_foreground = background


    local title = determine_tab_title(tab)
    local title_text = string.format("⌘%s:%s" , tab.tab_index + 1, title)

    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title_text },
        { Background = { Color = edge_background } },
        { Foreground = { Color = background } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)


-- tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false


------------------------------------
--- WINDOW, PANE
------------------------------------
config.keys = {
    -- Horizontal split (split into top and bottom)
    {
        key = '\'',
        mods = 'SUPER|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    -- Vertical split (split into left and right)
    {
        key = '\'',
        mods = 'SUPER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },

    -- move to other pane
    {
        key = 'h',
        mods = 'SUPER',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'l',
        mods = 'SUPER',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = 'k',
        mods = 'SUPER',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = 'j',
        mods = 'SUPER',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },

    -- close pane
    {
        key = 'w',
        mods = 'SUPER',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },

    -- pane size
    {
        key = 'LeftArrow',
        mods = 'SUPER',
        action = wezterm.action.AdjustPaneSize { 'Left', 5 },
    },
    {
        key = 'RightArrow',
        mods = 'SUPER',
        action = wezterm.action.AdjustPaneSize { 'Right', 5 },
    },
    {
        key = 'UpArrow',
        mods = 'SUPER',
        action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    {
        key = 'DownArrow',
        mods = 'SUPER',
        action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
}

return config
