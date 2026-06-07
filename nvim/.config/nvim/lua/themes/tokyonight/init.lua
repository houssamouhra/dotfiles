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

      on_highlights = function(hl, c)
        hl['@tag.tsx'] = { fg = c.red }

        hl['@type'] = { fg = c.blue, bold = true }
        hl['@type.builtin'] = { fg = c.cyan, bold = true }
        hl['@type.definition'] = { fg = c.yellow, bold = true }

        hl['@lsp.type.interface'] = { fg = c.teal, bold = true }

        hl['@keyword'] = { fg = c.magenta, italic = true }
        hl['@keyword.function'] = { fg = c.magenta, italic = true }

        hl['@keyword.import.typescript'] = { fg = c.cyan }
        hl['@keyword.export.typescript'] = { fg = c.cyan }

        hl['@function'] = { fg = c.blue }
        hl['@function.method'] = { fg = c.cyan }
        hl['@function.call'] = { fg = c.cyan }

        hl['@parameter'] = { fg = c.fg, italic = true }

        hl['@lsp.type.property'] = { fg = c.fg_dark, italic = true }
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
