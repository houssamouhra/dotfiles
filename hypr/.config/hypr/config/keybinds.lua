local HOME = os.getenv 'HOME'

-- Variables
local MOD = 'SUPER'
local CTRL = 'CTRL'
local ALT = 'ALT'

local scripts = string.format('%s/.config/hypr/scripts/', HOME)
local screenshots = string.format('%s/Screenshots/', HOME)

local terminal = 'ghostty'
local yazi = terminal .. ' -e yazi'

local menu = 'rofi -show drun'

local powermenu = table.concat({
  'rofi -show power-menu',
  '-modi power-menu:$HOME/.local/bin/rofi-power-menu',
  '--choices=shutdown/reboot/suspend/logout',
  '--confirm=shutdown/reboot/suspend/logout',
}, ' ')

-- Helpers
local function bind(key, action, opts)
  hl.bind(key, action, opts or {})
end

local function exec(key, cmd, opts)
  bind(key, hl.dsp.exec_cmd(cmd), opts)
end

local function repeatable(opts)
  opts = opts or {}
  opts.locked = true
  opts.repeating = true

  return opts
end

-- Applications
exec(MOD .. ' + Q', terminal, { desc = 'Open terminal' })
exec(MOD .. ' + E', yazi, { desc = 'Open yazi' })
exec(MOD .. ' + SPACE', menu, { desc = 'Open app launcher' })
exec(MOD .. ' + TAB', powermenu, { desc = 'Open power menu' })
exec(MOD .. ' + L', 'hyprlock', { desc = 'Lock screen' })
exec(MOD .. ' + S', 'swaync-client -t', { desc = 'Toggle notifications' })
exec(MOD .. ' + I', 'rofimoji', { desc = 'Open emoji picker' })

-- Window Management
bind(MOD .. ' + W', hl.dsp.window.close(), { desc = 'Close window' })
bind(MOD .. ' + F', hl.dsp.window.fullscreen(), { desc = 'Toggle fullscreen' })
bind(MOD .. ' + V', hl.dsp.window.float { action = 'toggle' }, { desc = 'Toggle floating' })
bind(MOD .. ' + P', hl.dsp.window.pseudo(), { desc = 'Toggle pseudo tile' })
bind(MOD .. ' + J', hl.dsp.layout 'togglesplit', { desc = 'Toggle split' })

-- Focus Movement
local directions = { 'left', 'right', 'up', 'down' }

for _, dir in ipairs(directions) do
  bind(MOD .. ' + ' .. dir, hl.dsp.focus { direction = dir }, { desc = 'Focus ' .. dir })
  bind(MOD .. ' + SHIFT + ' .. dir, hl.dsp.window.move { direction = dir }, { desc = 'Move window ' .. dir })
end

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  bind(MOD .. ' + ' .. key, hl.dsp.focus { workspace = i }, { desc = 'Workspace ' .. i })
  bind(MOD .. ' + SHIFT + ' .. key, hl.dsp.window.move { workspace = i }, { desc = 'Move window to workspace ' .. i })
end

bind(MOD .. ' + A', hl.dsp.workspace.toggle_special 'magic', { desc = 'Toggle special workspace' })

-- Mouse Actions
bind(MOD .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true, desc = 'Drag window' })
bind(MOD .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true, desc = 'Resize window' })

-- Screenshots
exec(CTRL .. ' + Print', 'hyprshot -m region -z --clipboard-only', { desc = 'Region screenshot' })
exec('Print', 'hyprshot -m window -z -o ' .. screenshots, { desc = 'Window screenshot' })
exec(ALT .. ' + Print', 'hyprshot -m output -z -o ' .. screenshots, { desc = 'Monitor screenshot' })

-- Clipboard
exec(MOD .. ' + C', scripts .. 'clipboard.sh', { locked = true, desc = 'Clipboard history' })

-- Wallpapers
exec(ALT .. ' + W', scripts .. 'wallpaper.sh menu', { locked = true, desc = 'Wallpaper menu' })
exec(ALT .. ' + SHIFT + W', scripts .. 'wallpaper.sh manual', { locked = true, desc = 'Random wallpaper' })

-- Waybar
exec('ALT' .. ' + A', scripts .. 'refresh-waybar.sh', { desc = 'Refresh waybar' })

-- Blur Toggle
bind(MOD .. ' + B', function()
  local enabled = hl.get_config 'decoration.blur.enabled'

  hl.config {
    decoration = {
      blur = {
        enabled = not enabled,
      },
    },
  }
end, {
  desc = 'Toggle blur',
})

-- System Controls
exec(MOD .. ' + SHIFT + R', 'hyprctl reload', { desc = 'Reload Hyprland' })

-- Volume
exec('XF86AudioRaiseVolume', scripts .. 'volume-control.sh --inc', repeatable { desc = 'Volume up' })
exec('XF86AudioLowerVolume', scripts .. 'volume-control.sh --dec', repeatable { desc = 'Volume down' })
exec('XF86AudioMute', scripts .. 'volume-control.sh --toggle', repeatable { desc = 'Toggle mute' })
exec('XF86AudioMicMute', scripts .. 'volume-control.sh --toggle-mic', repeatable { desc = 'Toggle mic mute' })

-- Brightness
exec('XF86MonBrightnessUp', scripts .. 'brightness.sh --inc', repeatable { desc = 'Brightness up' })
exec('XF86MonBrightnessDown', scripts .. 'brightness.sh --dec', repeatable { desc = 'Brightness down' })
exec(MOD .. ' + F6', scripts .. 'brightness.sh --inc', repeatable { desc = 'Brightness up' })
exec(MOD .. ' + F5', scripts .. 'brightness.sh --dec', repeatable { desc = 'Brightness down' })

-- Media Controls
local mediaKeys = {
  { key = 'XF86AudioNext', cmd = 'playerctl next', desc = 'Next track' },
  { key = 'XF86AudioPrev', cmd = 'playerctl previous', desc = 'Previous track' },
  { key = 'XF86AudioPause', cmd = 'playerctl play-pause', desc = 'Play/Pause' },
  { key = 'XF86AudioPlay', cmd = 'playerctl play-pause', desc = 'Play/Pause' },
}

for _, media in ipairs(mediaKeys) do
  exec(media.key, media.cmd, {
    locked = true,
    desc = media.desc,
  })
end
