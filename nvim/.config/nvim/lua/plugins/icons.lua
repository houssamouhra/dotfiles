return {
  'echasnovski/mini.icons',
  version = false,
  lazy = true,
  init = function()
    require('mini.icons').setup {
      file = {
        ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
        ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['vite.config.js'] = { glyph = '󱐋', hl = 'MiniIconsVite' },
        ['vite.config.ts'] = { glyph = '󱐋', hl = 'MiniIconsVite' },
        ['vite.config.mjs'] = { glyph = '󱐋', hl = 'MiniIconsVite' },
        ['README.md'] = { glyph = '󰂺', hl = 'MiniIconsGreen' },
        ['eslint.config.js'] = { glyph = '', hl = 'MiniIconsEslint' },
        ['tsconfig.app.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.node.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['commitlint.config.js'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['.prettierrc'] = { glyph = '', hl = 'MiniIconsYellow' },
        ['.gitignore'] = { glyph = '', hl = 'MiniIconsGit' },
        ['.gitattributes'] = { glyph = '', hl = 'MiniIconsGit' },
      },

      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        zsh = { glyph = '', hl = 'MiniIconsGreen' },
      },
    }
    require('mini.icons').mock_nvim_web_devicons()
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.api.nvim_set_hl(0, 'MiniIconsVite', { fg = '#9752FF' })
        vim.api.nvim_set_hl(0, 'MiniIconsEslint', { fg = '#8181F2' })
        vim.api.nvim_set_hl(0, 'MiniIconsGit', { fg = '#F05133' })
      end,
    })
  end,
}
