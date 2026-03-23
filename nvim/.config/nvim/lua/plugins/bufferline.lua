return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        close_command = 'Bdelete! %d',
        buffer_close_icon = '✗',
        close_icon = '✗',
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        path_components = 1,
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        diagnostics = 'nvim_lsp',
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true,
        separator_style = 'thin',
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
        indicator = {
          style = 'none',
        },
        icon_pinned = '󰐃',
        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = 'insert_at_end',
      },
      highlights = {
        separator = {
          fg = '#434C5E',
        },
        buffer_selected = {
          bold = true,
          italic = true,
          fg = '#FFFFFF',
          bg = 'none',
        },
        fill = {
          bg = 'none',
          fg = 'none',
        },
        background = {
          bg = 'none',
          fg = 'none',
        },
        buffer_visible = {
          bg = 'none',
          fg = 'none',
        },
        separator_visible = {
          bg = 'none',
          fg = 'none',
        },
      },
    }
  end,
}
