-- scripts
local home = os.getenv 'HOME'
local wallpaper = home .. '/.config/hypr/scripts/wallpaper.sh'
local battery = home .. '/.config/hypr/scripts/battery-low-notify.sh'

hl.on('hyprland.start', function()
  -- Wayland environment variables into systemd/dbus
  hl.exec_cmd 'systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP'
  hl.exec_cmd 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP'

  -- UI services
  hl.exec_cmd 'waybar'
  hl.exec_cmd 'swaync'

  -- Display / color temperature
  hl.exec_cmd 'shikane'
  hl.exec_cmd 'gammastep'

  -- Clipboard history
  hl.exec_cmd 'wl-paste --watch cliphist store'

  -- Load Wallpaper
  hl.exec_cmd(wallpaper .. ' restore')

  -- Audio defaults / mute mic
  hl.exec_cmd 'pactl set-sink-mute @DEFAULT_SINK@ 0'
  hl.exec_cmd 'pactl set-source-mute @DEFAULT_SOURCE@ 1'

  -- Battery notifications
  hl.exec_cmd(battery)
end)
