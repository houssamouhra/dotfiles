hl.config {
  input = {
    kb_layout = 'us',
    repeat_rate = 50,
    repeat_delay = 300,
    numlock_by_default = true,
    follow_mouse = 2,
    accel_profile = 'flat',
    sensitivity = 0,

    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      disable_while_typing = true,
    },
  },
  cursor = {
    sync_gsettings_theme = true,
    no_hardware_cursors = false,
    inactive_timeout = 3,
    no_warps = false,
  },

  general = {
    gaps_in = 0,
    gaps_out = 2,
    col = {
      active_border = 'rgba(255,255,255,0.03)',
      inactive_border = 'rgba(255,255,255,0.015)',
    },

    resize_on_border = true,
    allow_tearing = true,
    layout = 'dwindle',
  },

  decoration = {
    rounding = 16,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 0.92,
    shadow = {
      enabled = false,
    },

    blur = {
      enabled = false,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = true,
    focus_on_activate = true,
  },
}
