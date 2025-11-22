-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Window size
config.initial_cols = 80
config.initial_rows = 20

-- Font
config.font = wezterm.font("MonoLisa Variable")
config.font_size = 13.5
config.line_height = 1.05
config.harfbuzz_features = {'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss07', 'ss14', 'ss18', 'ss19', 'ss20', 'calt', 'cv01', 'cv06', 'cv14'}

-- Theme
config.color_scheme = "Tokyo Night Storm"
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

-- Tokyo Night palette colors
local neon = {
  blue = "#7aa2f7",
  purple = "#bb9af7",
}

-- Neon border effect
config.window_frame = {
  border_left_width = "3px",
  border_right_width = "3px",
  border_bottom_height = "3px",
  border_top_height = "3px",

  border_left_color = neon.blue,
  border_right_color = neon.blue,
  border_bottom_color = neon.purple,
  border_top_color = neon.purple,
}

-- Window Appearance
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.enable_scroll_bar = false
config.enable_tab_bar = false

-- GPU accelerated rendering
config.front_end = "WebGpu"
config.animation_fps = 120
config.max_fps = 120

--  Default to WSL Ubuntu
config.default_domain = "WSL:Ubuntu"

config.set_environment_variables = {
  SHELL = "/usr/bin/zsh",
}

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
