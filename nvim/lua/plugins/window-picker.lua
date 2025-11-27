return {
  's1n7ax/nvim-window-picker',
  version = '2.*',
  event = 'VeryLazy',
  config = function()
    require('window-picker').setup {
      autoselect_one = true,
      include_current_win = false,
      filter_rules = {
        bo = {
          filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
          buftype = { 'terminal', 'quickfix' },
        },
      },
      highlights = {
        statusline = 'WindowPickerStatusLine',
        winbar = 'WindowPickerStatusLine',
      },
    }
  end,
}
