-- Input configuration
hl.config({
	input = {
		-- Keyboard layout
		kb_layout = "us",

		-- Keyboard repeat delay in milliseconds
		repeat_delay = 300,

		-- Keyboard repeat rate
		repeat_rate = 50,

		-- Enable mouse focus follow
		follow_mouse = 1,

		-- Mouse acceleration profile
		accel_profile = "flat",

		-- Mouse sensitivity
		sensitivity = 0,

		-- Touchpad settings
		touchpad = {
			natural_scroll = true,
		},
	},
})

-- Device-specific configuration
hl.device({
	name = "pixart-hp-usb-optical-mouse",
	sensitivity = 0,
})
