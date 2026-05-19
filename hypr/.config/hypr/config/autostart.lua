local HOME = os.getenv 'HOME'

-- Scripts
local scripts = {
  wallpaper = string.format('%s/.config/hypr/scripts/wallpaper.sh', HOME),
}

-- Helpers
local function exec(cmd)
  hl.exec_cmd(cmd)
end

hl.on('hyprland.start', function()
  -- Session / environment sync
  exec 'systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP'
  exec 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP'

  -- UI services
  local services = { 'waybar', 'swaync', 'hypridle' }

  for _, service in ipairs(services) do
    exec(service)
  end

  -- Display / system services
  local display = { 'shikane', 'gammastep' }

  for _, service in ipairs(display) do
    exec(service)
  end

  -- Clipboard manager
  exec 'wl-paste --watch cliphist store'

  -- Wallpaper
  exec(scripts.wallpaper .. ' restore')

  -- Audio defaults
  exec 'pactl set-sink-mute @DEFAULT_SINK@ 0'
  exec 'pactl set-source-mute @DEFAULT_SOURCE@ 1'
end)
