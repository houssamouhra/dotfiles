return {
  'folke/tokyonight.nvim',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('tokyonight').setup {
      priority = 1000,
      style = 'night',
      light_style = 'day',
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { fg = '#565f89', italic = true },
        NormalFloat = { bg = '#1a1b26' },
        keywords = { italic = true },
        sidebars = 'transparent',
        floats = 'transparent',
      },
      day_brightness = 0.3,
      dim_inactive = false,
      lualine_bold = false,

      on_colors = function(colors)
        colors.bg_statusline = colors.none -- forces statusline / tabline fill to transparent
        -- Optional extras if you still see issues:
        -- colors.bg_dark     = colors.none
        -- colors.bg_float    = colors.none
      end,
    }

    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
