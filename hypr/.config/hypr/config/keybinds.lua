local terminal = 'ghostty'
local fileManager = 'ghostty -e yazi'
local menu = 'rofi -show drun'
local powermenu = table.concat({
  'rofi -show power-menu',
  '-modi power-menu:$HOME/.local/bin/rofi-power-menu',
  '--choices=shutdown/reboot/suspend/logout',
  '--confirm=shutdown/reboot/suspend/logout',
}, ' ')
local home = os.getenv 'HOME'
local scripts = home .. '/.config/hypr/scripts/'
local screenshots = home .. '/Screenshots/'

local mainMod = 'SUPER' -- Sets "Windows" key as main modifier

hl.bind(mainMod .. ' + Q', hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. ' + E', hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. ' + SPACE', hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. ' + TAB', hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. ' + L', hl.dsp.exec_cmd 'hyprlock')
hl.bind(mainMod .. ' + S', hl.dsp.exec_cmd 'swaync-client -t')
hl.bind(mainMod .. ' + W', hl.dsp.window.close())
hl.bind(mainMod .. ' + F', hl.dsp.window.fullscreen())
hl.bind(mainMod .. ' + V', hl.dsp.window.float { action = 'toggle' })
hl.bind(mainMod .. ' + P', hl.dsp.window.pseudo())
hl.bind(mainMod .. ' + J', hl.dsp.layout 'togglesplit') -- dwindle only

-- Screenshots
-- Region
hl.bind('CTRL' .. ' + Print', hl.dsp.exec_cmd 'hyprshot -m region -z --clipboard-only')
-- Window
hl.bind('Print', hl.dsp.exec_cmd('hyprshot -m window -z -o' .. screenshots))
-- Monitor
hl.bind('ALT' .. ' + Print', hl.dsp.exec_cmd('hyprshot -m output -z -o' .. screenshots))

-- Emojis
hl.bind(mainMod .. ' + I', hl.dsp.exec_cmd 'rofimoji')

-- Clipboard
hl.bind(mainMod .. ' + C', hl.dsp.exec_cmd(scripts .. 'clipboard.sh'), { locked = true, repeating = true })

-- Toggle Blur
hl.bind(mainMod .. ' + B', function()
  local value = hl.get_config 'decoration.blur.enabled'
  local enabled = value == true or value == 'true' or value == 1

  hl.config {
    decoration = {
      blur = {
        enabled = not enabled,
      },
    },
  }
end)

-- Move focus with mainMod + arrow keys
for _, dir in ipairs { 'left', 'right', 'up', 'down' } do
  hl.bind(mainMod .. ' + ' .. dir, hl.dsp.focus { direction = dir })
end

-- Refresh waybar
hl.bind('ALT' .. ' + A', hl.dsp.exec_cmd(scripts .. 'refresh-waybar.sh'))

-- Load Wallpapers menu/random
-- locked=true allows execution while input inhibitors are active
-- repeating=true enables key-repeat when holding volume keys
hl.bind('ALT' .. ' + W', hl.dsp.exec_cmd(scripts .. 'wallpaper.sh menu'), { locked = true, repeating = true })
hl.bind('ALT' .. ' + SHIFT + W', hl.dsp.exec_cmd(scripts .. 'wallpaper.sh manual'), { locked = true, repeating = true })

-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. ' + ' .. key, hl.dsp.focus { workspace = i })
  hl.bind(mainMod .. ' + SHIFT + ' .. key, hl.dsp.window.move { workspace = i })
end

-- Special workspace
hl.bind(mainMod .. ' + A', hl.dsp.workspace.toggle_special 'magic')

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd(scripts .. 'volume-control.sh --inc'), { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd(scripts .. 'volume-control.sh --dec'), { locked = true, repeating = true })
hl.bind('XF86AudioMute', hl.dsp.exec_cmd(scripts .. 'volume-control.sh --toggle'), { locked = true, repeating = true })
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd(scripts .. 'volume-control.sh --toggle-mic'), { locked = true, repeating = true })
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd(scripts .. 'brightness.sh --inc'), { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd(scripts .. 'brightness.sh --dec'), { locked = true, repeating = true })

-- Control monitor brightness
hl.bind(mainMod .. ' + F5', hl.dsp.exec_cmd(scripts .. 'brightness.sh --dec'), { locked = true, repeating = true })
hl.bind(mainMod .. ' + F6', hl.dsp.exec_cmd(scripts .. 'brightness.sh --inc'), { locked = true, repeating = true })

-- Requires playerctl
local mediaKeys = {
  { key = 'XF86AudioNext', cmd = 'playerctl next' },
  { key = 'XF86AudioPause', cmd = 'playerctl play-pause' },
  { key = 'XF86AudioPlay', cmd = 'playerctl play-pause' },
  { key = 'XF86AudioPrev', cmd = 'playerctl previous' },
}

for _, bind in ipairs(mediaKeys) do
  hl.bind(bind.key, hl.dsp.exec_cmd(bind.cmd), { locked = true })
end
