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

-- Load theme & plugins
require('lazy').setup {
  require 'theme.tokyonight',
  require 'plugins.autocompletion',
  require 'plugins.bufferline',
  require 'plugins.cmdline',
  require 'plugins.comment',
  require 'plugins.conform',
  require 'plugins.dashboard',
  require 'plugins.debugging',
  require 'plugins.diffview',
  require 'plugins.gitsigns',
  require 'plugins.icons',
  require 'plugins.indent-blankline',
  require 'plugins.inline-diagnostic',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.markdown',
  require 'plugins.misc',
  require 'plugins.neo-scroll',
  require 'plugins.neo-tree',
  require 'plugins.nvim-autopairs',
  require 'plugins.nvim-colorizer',
  require 'plugins.nvim-lint',
  require 'plugins.nvim-surround',
  require 'plugins.nvim-ts-autotag',
  require 'plugins.oil',
  require 'plugins.plenary',
  require 'plugins.snacks',
  require 'plugins.telescope-fzf-native',
  require 'plugins.telescope-ui-select',
  require 'plugins.telescope',
  require 'plugins.tmux-navigator',
  require 'plugins.treesitter',
  require 'plugins.trouble',
  require 'plugins.undotree',
  require 'plugins.vim-test',
}
