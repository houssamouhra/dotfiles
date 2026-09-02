require 'config.env'
require 'config.settings'
require 'config.animations'
require 'config.rules'
require 'config.keybinds'
require 'config.autostart'

-- Added by hyprmoncfg: its generated monitor rules load last, so nothing before this can override the applied layout.
do
  local path = os.getenv 'HOME' .. '/.config/hypr/hyprmoncfg-monitors.lua'
  local file = io.open(path, 'r')
  if file then
    file:close()
    dofile(path)
  end
end
