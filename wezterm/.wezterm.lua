-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Window size
config.initial_cols = 80
config.initial_rows = 20

-- Font
config.font = wezterm.font_with_fallback({
	{
		family = "MonoLisa",
		harfbuzz_features = {
			"ss01",
			"ss02",
			"ss03",
			"ss04",
			"ss05",
			"ss07",
			"ss14",
			"ss15",
			"ss16",
			"ss17",
			"ss18",
			"ss19",
			"ss20",
			"calt",
			"cv01",
			"cv06",
			"cv14",
		},
	},
	{
		family = "MonoLisa Variable",
		harfbuzz_features = { "liga", "clig", "calt" },
	},
})

config.font_size = 13
config.line_height = 1.05

-- Pinkcodes theme
local pinkcodes = {
	foreground = "#EAD7E9",
	background = "#0B010B",

	-- Cursor
	cursor_bg = "#d4d4d4",
	cursor_fg = "#0B010B",
	cursor_border = "#d4d4d4",

	selection_bg = "#55283F",
	selection_fg = "#EAD7E9",

	ansi = {
		"#1b1520", -- black
		"#ff6d8a", -- red
		"#8af38a", -- green
		"#ffcba7", -- yellow
		"#8fb3ff", -- blue
		"#ff9ace", -- magenta
		"#66e6d6", -- cyan
		"#f0e9f2", -- white
	},

	brights = {
		"#362b3c", -- black
		"#ff8ca4", -- red
		"#a7ffb0", -- green
		"#ffe1c7", -- yellow
		"#a8c8ff", -- blue
		"#ffb3de", -- magenta
		"#8ff7eb", -- cyan
		"#ffffff", -- white
	},
}

config.colors = pinkcodes

-- Border effect
local pinkcode = "#D58C9B"

config.window_frame = {
	border_left_width = "2px",
	border_right_width = "2px",
	border_bottom_height = "2px",
	border_top_height = "2px",

	border_left_color = pinkcode,
	border_right_color = pinkcode,
	border_top_color = pinkcode,
	border_bottom_color = pinkcode,
}

-- Remove bottom padding
config.window_padding = {
	bottom = 0,
}

-- Window Appearance
config.window_decorations = "TITLE | RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0
config.enable_scroll_bar = false
config.enable_tab_bar = false

-- Accelerated rendering
config.animation_fps = 120
config.max_fps = 120

-- Cursor animation
config.animation_fps = 120

-- Cursor style
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"

--  WSL
config.default_domain = "WSL:Ubuntu"

config.wsl_domains = {
	{
		name = "WSL:Ubuntu",
		distribution = "Ubuntu",
		default_cwd = "/home/houssam",
		default_prog = { "zsh" },
	},
}

-- Extra QoL
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.enable_csi_u_key_encoding = true

-- Keybindings
config.keys = {
	-- New tab
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	-- Ctrl+Tab → next tab
	{ key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },

	-- Ctrl+Shift+Tab → prev tab
	{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },

	-- Split vertically
	{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Split horizontally
	{ key = "_", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Close pane
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

	-- Navigate splits
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },

	-- Increase / decrease font size
	{ key = "+", mods = "CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "CTRL", action = "ResetFontSize" },

	-- Quake mode toggle
	{ key = "F12", action = wezterm.action.ToggleFullScreen },
}

return config
