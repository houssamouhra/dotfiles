require 'core.options'
require 'core.keymaps'
require 'core.diagnostics'

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require('lazy').setup {
  -- Load theme
  require 'themes.tokyonight',
  -- require 'themes.night-owl',

  -- Load plugins
  require 'plugins.dashboard',
  require 'plugins.autocompletion',
  require 'plugins.bufferline',
  require 'plugins.cmdline',
  require 'plugins.trouble',
  require 'plugins.comment',
  require 'plugins.nvim-colorizer',
  require 'plugins.debugging',
  require 'plugins.diffview',
  require 'plugins.git',
  require 'plugins.icons',
  require 'plugins.indent-blankline',
  require 'plugins.mason',
  require 'plugins.lualine',
  require 'plugins.markdown',
  require 'plugins.misc',
  require 'plugins.nvim-surround',
  require 'plugins.neo-scroll',
  require 'plugins.neo-tree',
  require 'plugins.linting',
  require 'plugins.formatting',
  require 'plugins.plenary',
  require 'plugins.snacks',
  require 'plugins.telescope-fzf-native',
  require 'plugins.telescope-ui-select',
  require 'plugins.telescope',
  require 'plugins.tmux-navigator',
  require 'plugins.treesitter',
  require 'plugins.vim-test',
  require 'plugins.window-picker',
}
