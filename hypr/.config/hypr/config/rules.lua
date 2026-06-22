-- Helpers
local function rule(opts)
  return hl.window_rule(opts)
end

local suppressMaximizeRule = rule {
  name = 'suppress-maximize-events',
  match = {
    xwayland = true,
  },
  suppress_event = 'maximize',
}

suppressMaximizeRule:set_enabled(false)

rule {
  name = 'fix-xwayland-drags',
  match = {
    xwayland = true,
    float = true,
    class = '^$',
    title = '^$',
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
}

-- Layout rules
rule {
  name = 'move-hyprland-run',
  match = { class = 'hyprland-run' },
  float = true,
  move = '20 monitor_h-120',
}

-- Zen browser
rule {
  name = 'zen-browser',
  match = {
    class = 'zen',
  },
  workspace = '1',
  float = false,
  fullscreen = false,
}

-- Spotify
rule {
  name = 'spotify',
  match = { class = 'spotify' },
  float = false,
  fullscreen = true,
}
