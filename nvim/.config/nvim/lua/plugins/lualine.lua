return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
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

    local function mode()
      return {
        a = { fg = '#656c8b', bg = 'none' },
        b = { fg = '#656c8b', bg = 'none' },
        c = { fg = '#656c8b', bg = 'none' },
      }
    end

    local theme = {
      normal = mode(),
      insert = mode(),
      visual = mode(),
      replace = mode(),
      command = mode(),
      inactive = mode(),
    }

    require('lualine').setup {
      options = {
        theme = theme,
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { '', '' },
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
        lualine_b = {
          { 'branch', icon = '󰘬', color = { fg = '#6281c6' } },
          diff,
        },
        lualine_c = {
          {
            'filename',
            file_status = true,
            color = { fg = '#878da5' },
          },
        },
        lualine_x = {
          diagnostics,
          { 'filetype', color = { fg = '#545C7E' } },
          { 'encoding', color = { fg = '#545C7E' } },
          { 'fileformat', symbols = {
            unix = 'LF',
            dos = 'CRLF',
          }, color = { fg = '#545C7E' } },
        },
      },
    }
  end,
}
