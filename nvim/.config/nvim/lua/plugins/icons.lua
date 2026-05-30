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
        ['.env'] = { glyph = '', hl = 'MiniIconsYellow' },
        ['.env.example'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['next.config.ts'] = { glyph = '', hl = 'MiniIconsWhite' },
        ['tmux.conf'] = { glyph = '', hl = 'MiniIconsTmux' },
        ['docker-compose.yml'] = { glyph = '', hl = 'MiniIconsDocker' },
        ['Dockerfile'] = { hl = 'MiniIconsDocker' },
        ['package.json'] = { glyph = '', hl = 'MiniIconsNpm' },
        ['pnpm-lock.yaml'] = { glyph = '', hl = 'MiniIconsPnpm' },
        ['pnpm-workspace.yaml'] = { glyph = '', hl = 'MiniIconsPnpm' },
        ['nginx.conf'] = { glyph = '', hl = 'MiniIconsNginx' },
      },

      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        zsh = { glyph = '', hl = 'MiniIconsGreen' },
        typescript = { hl = 'MiniIconsTS' },
        typescriptreact = { glyph = '󰜈', hl = 'MiniIconsTS' },
        javascriptreact = { glyph = '󰜈' },
      },
    }
    require('mini.icons').mock_nvim_web_devicons()
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.api.nvim_set_hl(0, 'MiniIconsVite', { fg = '#9752FF' })
        vim.api.nvim_set_hl(0, 'MiniIconsEslint', { fg = '#8181F2' })
        vim.api.nvim_set_hl(0, 'MiniIconsGit', { fg = '#F05133' })
        vim.api.nvim_set_hl(0, 'MiniIconsTmux', { fg = '#1BB91F' })
        vim.api.nvim_set_hl(0, 'MiniIconsDocker', { fg = '#037CC7' })
        vim.api.nvim_set_hl(0, 'MiniIconsPnpm', { fg = '#F9AD00' })
        vim.api.nvim_set_hl(0, 'MiniIconsNpm', { fg = '#CB0000' })
        vim.api.nvim_set_hl(0, 'MiniIconsNginx', { fg = '#009800' })
        vim.api.nvim_set_hl(0, 'MiniIconsTS', { fg = '#2D79C7' })
      end,
    })
  end,
}
