return {
  'akinsho/bufferline.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },

  opts = {
    options = {
      mode = 'buffers',
      themable = true,
      numbers = 'none',
      close_command = 'Bdelete! %d',
      right_mouse_command = 'Bdelete! %d',
      left_mouse_command = 'buffer %d',

      buffer_close_icon = '✗',
      close_icon = '✗',
      modified_icon = '●',
      icon_pinned = '󰐃',

      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },

      left_trunc_marker = '',
      right_trunc_marker = '',

      max_name_length = 30,
      max_prefix_length = 15,
      maximum_length = 20,
      tab_size = 21,
      truncate_names = true,

      diagnostics = 'nvim_lsp',

      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = false,

      persist_buffer_sort = true,
      sort_by = 'insert_at_end',

      separator_style = 'thin', -- or "slant", "slope", "thick", or { "▕", "▕" }

      indicator = {
        style = 'none', -- "icon" | "underline" | "none"
      },

      enforce_regular_tabs = true,
      always_show_bufferline = false,

      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Neo-tree',
          highlight = 'Directory',
          text_align = 'left',
          separator = true,
        },
      },
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

      fill = { bg = 'none' },
      background = { bg = 'none' },
      buffer_visible = { bg = 'none' },
      separator_visible = { bg = 'none' },
    },
  },
}
