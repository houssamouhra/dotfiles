return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'kdheepak/tabline.nvim',
    { 'folke/tokyonight.nvim' },
  },

  config = function()
    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_lsp' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = true,
      update_in_insert = false,
      always_visible = true,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = true,
      symbols = { added = '+', modified = '~', removed = '-' },
      cond = hide_in_width,
    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        section_separators = { left = '', right = '' },
        component_separators = { '', '' },
        globalstatus = true,
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

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { { 'location', padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },

      extensions = { 'fugitive' },
    }
  end,
}
