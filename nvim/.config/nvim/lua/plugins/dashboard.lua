return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',

  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  opts = {
    theme = 'doom',

    config = {
      header = {
        '',
        '',
        '',
        '▗▖  ▗▖▗▄▄▄▖ ▗▄▖ ▗▖  ▗▖▗▄▄▄▖▗▖  ▗▖',
        '▐▛▚▖▐▌▐▌   ▐▌ ▐▌▐▌  ▐▌  █  ▐▛▚▞▜▌',
        '▐▌ ▝▜▌▐▛▀▀▘▐▌ ▐▌▐▌  ▐▌  █  ▐▌  ▐▌',
        '▐▌  ▐▌▐▙▄▄▖▝▚▄▞▘ ▝▚▞▘ ▗▄█▄▖▐▌  ▐▌',
        '',
        '',
        '',
      },

      center = {
        {
          icon = '󰈞 ',
          desc = '  Find file',
          desc_hl = 'Normal',
          key = 'f',
          key_format = ' [%s]',
          action = 'Telescope find_files',
        },

        {
          icon = ' ',
          desc = '  New file',
          desc_hl = 'Normal',
          key = 'n',
          key_format = ' [%s]',
          action = 'enew',
        },

        {
          icon = '󰚰 ',
          desc = '  Update',
          desc_hl = 'Normal',
          key = 'u',
          key_format = ' [%s]',
          action = 'Lazy update',
        },

        {
          icon = ' ',
          desc = '  Quit',
          desc_hl = 'Normal',
          key = 'q',
          key_format = ' [%s]',
          action = 'qa',
        },
      },

      footer = function()
        local stats = require('lazy').stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100

        return {
          '',
          '',
          ('Loaded %d/%d plugins in %.2f ms'):format(stats.loaded, stats.count, ms),
        }
      end,

      vertical_center = false,
    },
  },

  config = function(_, opts)
    require('dashboard').setup(opts)

    vim.api.nvim_set_hl(0, 'DashboardFooter', {
      fg = '#6c7086',
      italic = true,
    })
  end,
}
