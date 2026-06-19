-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core config
require 'core.options'
require 'core.keymaps'
require 'core.diagnostics'

-- Set up plugins
require('lazy').setup {
  -- Load theme
  require 'themes.tokyonight',

  -- Load plugins
  require 'plugins.dashboard',
  require 'plugins.autocompletion',
  require 'plugins.bufferline',
  require 'plugins.cmdline',
  require 'plugins.trouble',
  require 'plugins.comment',
  require 'plugins.nvim-ts-autotag',
  require 'plugins.dadbod',
  require 'plugins.nvim-autopairs',
  require 'plugins.nvim-colorizer',
  require 'plugins.nvim-surround',
  require 'plugins.nvim-lint',
  require 'plugins.debugging',
  require 'plugins.diffview',
  require 'plugins.gitsigns',
  require 'plugins.icons',
  require 'plugins.oil',
  require 'plugins.inline-diagnostic',
  require 'plugins.indent-blankline',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.markdown',
  require 'plugins.misc',
  require 'plugins.undotree',
  require 'plugins.neo-scroll',
  require 'plugins.neo-tree',
  require 'plugins.conform',
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
