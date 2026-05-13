hl.config({
	general = {
		-- Inner gaps between windows
		gaps_in = 0,

		-- Outer gaps between windows and screen edges
		gaps_out = 2,

		-- Border color configuration
		col = {
			-- Active window border
			active_border = {
				colors = { "rgba(255,255,255,0.03)" },
				angle = 45,
			},

			-- Inactive window border
			inactive_border = "rgba(255,255,255,0.015)",
		},

		-- Allow resizing windows via borders
		resize_on_border = true,

		-- Enable tearing support
		allow_tearing = true,

		-- Default tiling layout
		layout = "dwindle",
	},

	decoration = {
		-- Window corner rounding radius
		rounding = 16,

		-- Controls rounding curve intensity
		rounding_power = 2,

		-- Opacity for focused windows
		active_opacity = 1.0,

		-- Opacity for unfocused windows
		inactive_opacity = 0.92,

		shadow = {
			-- Disable window shadows
			enabled = false,
		},

		blur = {
			-- Disable blur effects
			enabled = false,
		},
	},

	animations = {
		-- Enable animations globally
		enabled = true,
	},

	dwindle = {
		-- Preserve split orientation when adding windows
		preserve_split = true,
	},

	misc = {
		-- Disable default Hyprland wallpaper
		force_default_wallpaper = -1,

		-- Disable Hyprland logo on startup
		disable_hyprland_logo = true,

		-- Focus windows when they request activation
		focus_on_activate = true,
	},
})
