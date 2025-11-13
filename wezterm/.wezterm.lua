-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

------------------------------------
--- GENERAL
------------------------------------
config.initial_cols = 120
config.initial_rows = 28
-- config.color_scheme = 'AdventureTime'
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
config.font = wezterm.font 'CommitMono Nerd Font'

------------------------------------
--- TAB
------------------------------------
-- tab appearance
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
local BACKGROUD_COLOR = "#5c6d74"
local FOREGROUND_COLOR = "#fff"
local BACKGROUD_COLOR_ACTIVE = "#72a7fc"

local function determine_tab_backgoround(current_tab)
    if current_tab.is_active then
        return BACKGROUD_COLOR_ACTIVE
    end

    return BACKGROUD_COLOR
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = determine_tab_backgoround(tab)
    local foreground = FOREGROUND_COLOR
    local edge_background = "none"
    local edge_foreground = background


    local title = string.format("%s:%s" , tab.tab_index + 1, tab.active_pane.title)

    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = edge_background } },
        { Foreground = { Color = background } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)


-- tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false


return config
