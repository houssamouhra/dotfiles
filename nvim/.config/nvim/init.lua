require 'core.options' -- Load options
require 'core.keymaps' -- Load keymaps
require 'core.diagnostics' -- Load diagnostics

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
  -- require 'themes.catppuccin',
  require 'themes.tokyonight',
  -- require 'themes.kanagawa',
  -- require 'themes.nightfox',
  -- require 'themes.night-owl',
  -- require 'themes.rosepine',
  -- require 'themes.eldritch',

  -- Load plugins
  require 'plugins.alpha',
  require 'plugins.autocompletion',
  require 'plugins.autopair',
  require 'plugins.bufferline',
  require 'plugins.cmdline',
  require 'plugins.comment',
  require 'plugins.csscolors',
  require 'plugins.debugging',
  require 'plugins.pomodoro',
  require 'plugins.diffview',
  require 'plugins.git',
  require 'plugins.icons',
  require 'plugins.indent-blankline',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.markdown',
  require 'plugins.misc',
  require 'plugins.neo-scroll',
  require 'plugins.neo-tree',
  require 'plugins.none-ls',
  require 'plugins.plenary',
  require 'plugins.snacks',
  require 'plugins.telescope-fzf-native',
  require 'plugins.telescope-ui-select',
  require 'plugins.telescope',
  require 'plugins.tmux-navigator',
  require 'plugins.treesitter',
  require 'plugins.typr',
  require 'plugins.vim-test',
  require 'plugins.window-picker',
}
