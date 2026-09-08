-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

------------------------------------
--- GENERAL
------------------------------------
-- Attach every new WezTerm window to the same persistent tmux session.
config.default_prog = { '/opt/homebrew/bin/tmux', 'new-session', '-A', '-s', 'main' }
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
config.font_size =15
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
config.hide_tab_bar_if_only_one_tab = true


------------------------------------
--- WINDOW, PANE
------------------------------------
config.keys = {
    -- Cmd+T creates a tmux window in the attached session.
    -- Send Ctrl+B (\x02), followed by c, to invoke tmux's new-window binding.
    { key = 't', mods = 'SUPER', action = wezterm.action.SendString '\x02c' },
    -- Horizontal split (split into top and bottom)
    {
        key = '\'',
        mods = 'SUPER|SHIFT',
        action = wezterm.action.SendString '\x02"',
    },
    -- Vertical split (split into left and right)
    {
        key = '\'',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02%',
    },

    -- move to other pane
    {
        key = 'h',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:select-pane -L\r',
    },
    {
        key = 'l',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:select-pane -R\r',
    },
    {
        key = 'k',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:select-pane -U\r',
    },
    {
        key = 'j',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:select-pane -D\r',
    },

    -- close pane
    {
        key = 'w',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02x',
    },

    -- pane size
    {
        key = 'LeftArrow',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:resize-pane -L 5\r',
    },
    {
        key = 'RightArrow',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:resize-pane -R 5\r',
    },
    {
        key = 'UpArrow',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:resize-pane -U 5\r',
    },
    {
        key = 'DownArrow',
        mods = 'SUPER',
        action = wezterm.action.SendString '\x02:resize-pane -D 5\r',
    },
}

-- Select tmux windows using the familiar Cmd+number shortcuts.
for index = 1, 9 do
    table.insert(config.keys, {
        key = tostring(index),
        mods = 'SUPER',
        action = wezterm.action.SendString('\x02' .. tostring(index)),
    })
end

-- fullscreen
config.native_macos_fullscreen_mode = true

return config
