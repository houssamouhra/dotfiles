return {
  'windwp/nvim-autopairs',
  event = 'VeryLazy',
  config = function()
    require('nvim-autopairs').setup {
      config = true,
      opts = {},
    }
  end,
}
