return {
  'folke/tokyonight.nvim',
  lazy = true,
  event = 'UIEnter',
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
        functions = {},
        variables = {},
        sidebars = 'transparent',
        floats = 'transparent',
      },
      day_brightness = 0.3,
      dim_inactive = false,
      lualine_bold = false,
    }

    vim.cmd.colorscheme 'tokyonight-night'
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        require('transparent').clear_prefix 'Lualine'
      end,
    })
  end,
}
