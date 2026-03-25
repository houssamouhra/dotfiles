return {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
  config = function(_, opts)
    require('nvim-ts-autotag').setup {
      opts = opts,
    }
  end,
}
