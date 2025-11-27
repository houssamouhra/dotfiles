return {
  {
    'houssamouhra/pinkcodes.nvim',
    priority = 1000,
    config = function()
      require('pinkcodes').setup {
        transparent = false,
      }
      require('pinkcodes').load()

      vim.keymap.set('n', '<leader>bg', function()
        require('pinkcodes').toggle_transparency()
      end, { desc = 'Toggle Pinkcodes background transparency' })
    end,
  },
}
