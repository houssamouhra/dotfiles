return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_lsp' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = true,
      update_in_insert = false,
      always_visible = true,
    }

    local diff = {
      'diff',
      colored = true,
      symbols = { added = '+', modified = '~', removed = '-' },
    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        section_separators = { left = '', right = '' },
        component_separators = { '', '' },
        globalstatus = false,
        disabled_filetypes = {
          statusline = { 'neo-tree' },
          winbar = { 'neo-tree' },
        },
        ignore_focus = { 'neo-tree' },
      },
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
        refresh_time = 16,
        events = {
          'WinEnter',
          'BufEnter',
          'BufWritePost',
          'SessionLoadPost',
          'FileChangedShellPost',
          'VimResized',
          'Filetype',
          'CursorMoved',
          'CursorMovedI',
          'ModeChanged',
        },
      },

      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', diff },
        lualine_c = {
          {
            'filename',
            file_status = true,
            color = { fg = '#888888' },
          },
        },
        lualine_x = {
          diagnostics,
          { 'encoding', color = { fg = '#888888' } },
          { 'fileformat', color = { fg = '#888888' } },
          { 'filetype', color = { fg = '#888888' } },
        },
        lualine_y = {
          { 'progress' },
        },
        lualine_z = {
          { 'location' },
        },
      },
    }
  end,
}
