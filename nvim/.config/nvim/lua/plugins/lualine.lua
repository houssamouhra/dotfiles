return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'kdheepak/tabline.nvim',
  },

  config = function()
    local filename = {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 0,
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local ok, pomo = pcall(require, 'pomo')
    local pomo_timer = function()
      return ''
    end

    if ok then
      pomo_timer = function()
        local timer = pomo.get_first_to_finish()
        if timer then
          return '󰄉 ' .. tostring(timer)
        end
        return ''
      end
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_lsp' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = true,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = true,
      symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
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
      refresh = { -- sets how often lualine should refresh it's contents (in ms)
        statusline = 100,
        tabline = 100,
        winbar = 100,
        refresh_time = 16, -- ~60fps the time after which refresh queue is processed. Mininum refreshtime for lualine
        events = { -- The auto command events at which lualine refreshes
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
        lualine_b = { 'branch' },
        lualine_c = { filename },

        lualine_x = {
          pomo_timer,
          diagnostics,
          diff,
          'encoding',
          'fileformat',
          'filetype',
        },

        lualine_y = { 'progress' },
        lualine_z = { 'location' },
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
