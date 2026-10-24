return {
  'karb94/neoscroll.nvim',
  lazy = false,

  opts = {
    mappings = {
      '<C-u>',
      '<C-d>',
      '<C-b>',
      '<C-f>',
      '<C-y>',
      '<C-e>',
      'zt',
      'zz',
      'zb',
    },

    hide_cursor = true,
    stop_eof = true,
    cursor_scrolls_alone = true,
    duration_multiplier = 0,
    easing_function = 'cubic',
  },
}
