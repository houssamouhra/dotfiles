local MOD = 'SUPER'
local CTRL = 'CTRL'
local ALT = 'ALT'

-- PATHS
local HOME = os.getenv 'HOME'

local paths = {
  scripts = HOME .. '/.config/hypr/scripts/',
  bin = HOME .. '/.local/bin/',
  quickshell = HOME .. '/.config/quickshell/',
  screenshots = HOME .. '/Screenshots/',
}

-- APPS
local apps = {
  terminal = 'foot',
  menu = 'fuzzel',
  yazi = 'foot -e yazi',
}

-- HELPERS
local function bind(key, action, opts)
  hl.bind(key, action, opts or {})
end

local function exec(key, cmd, opts)
  bind(key, hl.dsp.exec_cmd(cmd), opts or {})
end

local function repeatable(opts)
  opts = opts or {}
  opts.locked = true
  opts.repeating = true
  return opts
end

-- APPLICATIONS
exec(MOD .. ' + Q', apps.terminal, { desc = 'Open terminal' })
exec(MOD .. ' + E', apps.yazi, { desc = 'Open yazi' })
exec(MOD .. ' + SPACE', apps.menu, { desc = 'Open app launcher' })
exec(MOD .. ' + TAB', paths.scripts .. 'powermenu.sh', { desc = 'Open power menu' })
exec(MOD .. ' + L', paths.scripts .. 'lock.sh', { desc = 'Lock screen' })
exec(MOD .. ' + I', paths.bin .. 'bemoji-fuzzel', { desc = 'Open emoji picker' })

-- WINDOW MANAGEMENT
bind(MOD .. ' + W', hl.dsp.window.close(), { desc = 'Close window' })
bind(MOD .. ' + F', hl.dsp.window.fullscreen(), { desc = 'Toggle fullscreen' })
bind(MOD .. ' + V', hl.dsp.window.float { action = 'toggle' }, { desc = 'Toggle floating' })
bind(MOD .. ' + P', hl.dsp.window.pseudo(), { desc = 'Toggle pseudo tile' })
bind(MOD .. ' + J', hl.dsp.layout 'togglesplit', { desc = 'Toggle split' })

-- FOCUS & MOVEMENT
local directions = { 'left', 'right', 'up', 'down' }

for _, dir in ipairs(directions) do
  bind(MOD .. ' + ' .. dir, hl.dsp.focus { direction = dir }, { desc = 'Focus ' .. dir })
  bind(MOD .. ' + SHIFT + ' .. dir, hl.dsp.window.move { direction = dir }, { desc = 'Move window ' .. dir })
end

-- WORKSPACES
for i = 1, 10 do
  local key = i % 10
  bind(MOD .. ' + ' .. key, hl.dsp.focus { workspace = i }, { desc = 'Switch to workspace ' .. i })
  bind(MOD .. ' + SHIFT + ' .. key, hl.dsp.window.move { workspace = i }, { desc = 'Move window to workspace ' .. i })
end

bind(MOD .. ' + A', hl.dsp.workspace.toggle_special 'magic', { desc = 'Toggle special workspace' })

-- MOUSE
bind(MOD .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true, desc = 'Drag window' })
bind(MOD .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true, desc = 'Resize window' })

-- SCREENSHOTS
exec(CTRL .. ' + Print', 'hyprshot -m region -z --clipboard-only', { desc = 'Region screenshot → clipboard' })
exec('Print', 'hyprshot -m window -z -o ' .. paths.screenshots, { desc = 'Window screenshot' })
exec(ALT .. ' + Print', 'hyprshot -m output -z -o ' .. paths.screenshots, { desc = 'Monitor screenshot' })

-- UTILITIES
exec(MOD .. ' + C', paths.scripts .. 'clipboard.sh', { locked = true, desc = 'Clipboard history' })
exec(ALT .. ' + W', 'quickshell -c hyprquickpaper', { locked = true, desc = 'Wallpaper menu' })
exec(ALT .. ' + SHIFT + W', paths.quickshell .. 'hyprquickpaper/commands.sh random', { locked = true, desc = 'Random wallpaper' })
exec('ALT + A', paths.scripts .. 'refresh-waybar.sh', { desc = 'Refresh waybar' })

-- SYSTEM
exec(MOD .. ' + SHIFT + R', 'hyprctl reload', { desc = 'Reload Hyprland' })

-- VOLUME & MEDIA
exec('XF86AudioRaiseVolume', paths.scripts .. 'volume-control.sh --inc', repeatable { desc = 'Volume up' })
exec('XF86AudioLowerVolume', paths.scripts .. 'volume-control.sh --dec', repeatable { desc = 'Volume down' })
exec('XF86AudioMute', paths.scripts .. 'volume-control.sh --toggle', repeatable { desc = 'Toggle mute' })
exec('XF86AudioMicMute', paths.scripts .. 'volume-control.sh --toggle-mic', repeatable { desc = 'Toggle mic mute' })

-- BRIGHTNESS
exec('XF86MonBrightnessUp', paths.scripts .. 'brightness.sh --inc', repeatable { desc = 'Brightness up' })
exec('XF86MonBrightnessDown', paths.scripts .. 'brightness.sh --dec', repeatable { desc = 'Brightness down' })
exec(MOD .. ' + F6', paths.scripts .. 'brightness.sh --inc', repeatable { desc = 'Brightness up' })
exec(MOD .. ' + F5', paths.scripts .. 'brightness.sh --dec', repeatable { desc = 'Brightness down' })

-- MEDIA CONTROLS
local mediaKeys = {
  { key = 'XF86AudioNext', cmd = 'playerctl next', desc = 'Next track' },
  { key = 'XF86AudioPrev', cmd = 'playerctl previous', desc = 'Previous track' },
  { key = 'XF86AudioPause', cmd = 'playerctl play-pause', desc = 'Play/Pause' },
  { key = 'XF86AudioPlay', cmd = 'playerctl play-pause', desc = 'Play/Pause' },
}

for _, media in ipairs(mediaKeys) do
  exec(media.key, media.cmd, { locked = true, desc = media.desc })
end
