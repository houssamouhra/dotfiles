return {
  'stevearc/oil.nvim',

  config = function()
    require('oil').setup {
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- Optional dependencies
      dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
      -- Oil.nvim
      vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' }),
    }
  end,
}
