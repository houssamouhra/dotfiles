local highlights = require 'theme.tokyonight.highlights'

return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    style = 'night',
    light_style = 'day',
    transparent = true,
    terminal_colors = true,
    styles = {
      NormalFloat = { bg = '#1a1b26' },
      keywords = { italic = true },
      sidebars = 'transparent',
      floats = 'transparent',
    },
    day_brightness = 0.3,
    dim_inactive = false,
    lualine_bold = false,

    on_colors = function(colors)
      colors.bg_statusline = colors.none
    end,

    on_highlights = highlights,
  },

  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight-night'

    require 'theme.tokyonight.gitsigns'()
  end,
}
