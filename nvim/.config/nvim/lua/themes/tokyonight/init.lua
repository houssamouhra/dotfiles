return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  event = 'VeryLazy',
  config = function()
    require('tokyonight').setup {
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
    }

    vim.cmd.colorscheme 'tokyonight-night'
    vim.api.nvim_set_hl(0, 'CursorLineSign', { bg = '#1f2335' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

    vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#87ab6c' })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#E0AF68' })
    vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#db4b4b' })
    vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { fg = '#db4b4b' })
    vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { fg = '#E0AF68' })
    vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = '#7aa2f7' })
  end,
}
