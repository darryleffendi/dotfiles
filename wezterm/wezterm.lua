local wez = require("wezterm")

local config = wez.config_builder()

-- General Options

config.enable_tab_bar = false
config.window_decorations = "RESIZE" -- "TITLE", "TITLE | RESIZE", "NONE"
config.debug_key_events = false
config.adjust_window_size_when_changing_font_size = false
config.animation_fps = 60
config.max_fps = 120
config.scrollback_lines = 2000
config.initial_rows = 48
config.initial_cols = 160

-- Font Options

config.font = wez.font("MesloLGS Nerd Font Mono")
config.font_size = 18

-- Color options

config.color_scheme = "rose-pine"

config.colors = {
	cursor_bg = "#e0def4", -- Cursor background color
	cursor_border = "#e0def4", -- Cursor border color
	cursor_fg = "#232136", -- Cursor foreground color
	selection_bg = "#393552", -- Selection background color
	selection_fg = "#e0def4", -- Selection foreground color
	ansi = {
		"#393552", -- Black
		"#eb6f92", -- Red
		"#9ccfd8", -- Green
		"#f6c177", -- Yellow
		"#3e8fb0", -- Blue
		"#c4a7e7", -- Magenta
		"#9ccfd8", -- Cyan
		"#e0def4", -- White
	},
	brights = {
		"#6e6a86", -- Bright Black
		"#eb6f92", -- Bright Red
		"#9ccfd8", -- Bright Green
		"#f6c177", -- Bright Yellow
		"#3e8fb0", -- Bright Blue
		"#c4a7e7", -- Bright Magenta
		"#9ccfd8", -- Bright Cyan
		"#e0def4", -- Bright White
	},
}

-- Dimmer for background
local dimmer = {
	brightness = 0.05,
	saturation = 0.75,
}

-- Define the two background options (wallpaper and transparent)
local background_with_wallpaper = {
	{
		source = {
			File = wez.config_dir .. "/backgrounds/chaeyoung-1.jpeg",
			-- File = wez.config_dir .. "/backgrounds/pain.jpg",
			-- File = wez.config_dir .. "/backgrounds/azumanga.gif",
		},
		width = "Cover",
		height = "Cover",
		vertical_align = "Middle",
		horizontal_align = "Center",
		repeat_x = "NoRepeat",
		repeat_y = "NoRepeat",
		opacity = 1,
		hsb = dimmer,
	},
}

local transparent_background = {
	{
		source = {
			Color = "#0a0a0a",
		},
		width = "100%",
		height = "100%",
		opacity = 0.8,
	},
}

-- Initialize with the wallpaper by default
config.background = background_with_wallpaper

-- config.background = transparent_background
-- config.macos_window_background_blur = 30

-- Toggle function between the two backgrounds
local current_background = "wallpaper"

wez.on("toggle-background", function(window)
	if current_background == "wallpaper" then
		-- Switch to transparent background
		config.background = transparent_background
		current_background = "transparent"
		config.window_background_opacity = 0
		config.macos_window_background_blur = 30
	else
		-- Switch to wallpaper
		config.background = background_with_wallpaper
		current_background = "wallpaper"
		config.window_background_opacity = 1
		config.macos_window_background_blur = 0
	end
	window:set_config_overrides(config)
end)

config.keys = {
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = wez.action.EmitEvent("toggle-background"),
	},
}

-- Window options
config.window_padding = {
	left = 40,
	right = 40,
	top = 40,
	bottom = 20,
}

config.native_macos_fullscreen_mode = false

return config
