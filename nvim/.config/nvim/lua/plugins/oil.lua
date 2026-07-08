return {
  'stevearc/oil.nvim',
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },

  keys = {
    {
      '-',
      '<cmd>Oil<CR>',
      desc = 'Open parent directory',
    },
  },
  opts = {},
}
