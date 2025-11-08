-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- font
config.font_size =14
config.font = wezterm.font 'CommitMono Nerd Font'

---- tab appearance ----
local ICONS = { 
    ['docker'] = wezterm.nerdfonts.linux_docker,
    ['docker-compose'] = wezterm.nerdfonts.linux_docker,
    ['psql'] = wezterm.nerdfonts.dev_postgresql,
    ['kuberlr'] = wezterm.nerdfonts.linux_docker,
    ['kubectl'] = wezterm.nerdfonts.linux_docker,
    ['stern'] = wezterm.nerdfonts.linux_docker,
    ['nv'] = wezterm.nerdfonts.dev_neovim,
    ['make'] = wezterm.nerdfonts.seti_makefile,
    ['vim'] = wezterm.nerdfonts.dev_vim,
    ['go'] = wezterm.nerdfonts.seti_go,
    ['zsh'] = wezterm.nerdfonts.dev_terminal,
    ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
    ['btm'] = wezterm.nerdfonts.mdi_chart_donut_variant,
    ['htop'] = wezterm.nerdfonts.mdi_chart_donut_variant,
    ['cargo'] = wezterm.nerdfonts.dev_rust,
    ['sudo'] = wezterm.nerdfonts.fa_hashtag,
    ['lazydocker'] = wezterm.nerdfonts.linux_docker,
    ['git'] = wezterm.nerdfonts.dev_git,
    ['lua'] = wezterm.nerdfonts.seti_lua,
    ['wget'] = wezterm.nerdfonts.mdi_arrow_down_box,
    ['curl'] = wezterm.nerdfonts.mdi_flattr,
    ['gh'] = wezterm.nerdfonts.dev_github_badge,
    ['node'] = wezterm.nerdfonts.dev_nodejs_small,
    ['java'] = wezterm.nerdfonts.dev_java,
}


local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
local BACKGROUD_COLOR = "#5c6d74"
local FOREGROUND_COLOR = "#fff"
local BACKGROUD_COLOR_ACTIVE = "#72a7fc"

local function determine_icon_from_process(current_tab)
    local process_name = string.gsub(current_tab.active_pane.foreground_process_name, '(.*[/\\])(.*)', '%2')
    return ICONS[process_name] or wezterm.nerdfonts.dev_terminal
end

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


    local icon = determine_icon_from_process(tab)
    local title = string.format("%s: %s %s", tab.tab_index + 1, tab.active_pane.title, icon)

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

config.initial_cols = 120
config.initial_rows = 28
-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'Tokyo Night'

return config
