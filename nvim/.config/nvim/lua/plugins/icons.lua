return {
  'nvim-mini/mini.icons',
  version = false,
  lazy = true,

  init = function()
    local icons = require 'mini.icons'

    icons.setup {
      directory = {
        ['.config'] = { glyph = '', hl = 'MiniIconsBlue' },
        ['.git'] = { glyph = '', hl = 'MiniIconsGit' },
        ['.github'] = { glyph = '', hl = 'MiniIconsGit' },
        ['node_modules'] = { glyph = '', hl = 'MiniIconsNpm' },
        ['public'] = { glyph = '󰉏', hl = 'MiniIconsGreen' },
        ['components'] = { glyph = '󰙅', hl = 'MiniIconsPurple' },
      },

      file = {
        -- General
        ['README.md'] = { glyph = '󰂺', hl = 'MiniIconsGreen' },
        ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },

        -- Environment
        ['.env'] = { glyph = '', hl = 'MiniIconsYellow' },
        ['.env.local'] = { glyph = '', hl = 'MiniIconsYellow' },
        ['.env.example'] = { glyph = '', hl = 'MiniIconsGreen' },

        -- Git
        ['.gitignore'] = { glyph = '', hl = 'MiniIconsGit' },
        ['.gitattributes'] = { glyph = '', hl = 'MiniIconsGit' },
        ['commitlint.config.js'] = { glyph = '', hl = 'MiniIconsAzure' },

        -- Formatting & Linting
        ['.prettierrc'] = { glyph = '', hl = 'MiniIconsYellow' },
        ['eslint.config.js'] = { glyph = '', hl = 'MiniIconsEslint' },
        ['eslint.config.mjs'] = { glyph = '', hl = 'MiniIconsEslint' },
        ['postcss.config.mjs'] = { glyph = '', hl = 'MiniIconsPostCSS' },

        -- TypeScript
        ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.app.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.node.json'] = { glyph = '', hl = 'MiniIconsAzure' },

        -- Vite
        ['vite.config.js'] = { glyph = '󱐋', hl = 'MiniIconsVite' },
        ['vite.config.ts'] = { glyph = '󱐋', hl = 'MiniIconsVite' },
        ['vite.config.mjs'] = { glyph = '󱐋', hl = 'MiniIconsVite' },

        -- Next.js
        ['next.config.ts'] = { glyph = '', hl = 'MiniIconsWhite' },
        ['next-env.d.ts'] = { glyph = '', hl = 'MiniIconsWhite' },

        -- Prisma
        ['prisma.config.ts'] = { glyph = '', hl = 'MiniIconsWhite' },

        -- Node.js
        ['package.json'] = { glyph = '', hl = 'MiniIconsNpm' },

        -- pnpm
        ['pnpm-lock.yaml'] = { glyph = '', hl = 'MiniIconsPnpm' },
        ['pnpm-workspace.yaml'] = { glyph = '', hl = 'MiniIconsPnpm' },

        -- Docker
        ['Dockerfile'] = { hl = 'MiniIconsDocker' },
        ['docker-compose.yml'] = { glyph = '', hl = 'MiniIconsDocker' },

        -- Development
        ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },

        -- Infrastructure
        ['nginx.conf'] = { glyph = '', hl = 'MiniIconsNginx' },
        ['tmux.conf'] = { glyph = '', hl = 'MiniIconsTmux' },
      },

      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        zsh = { glyph = '', hl = 'MiniIconsGreen' },
        typescript = { hl = 'MiniIconsTS' },
        typescriptreact = { glyph = '󰜈', hl = 'MiniIconsTS' },
        javascriptreact = { glyph = '󰜈' },
      },
    }

    icons.mock_nvim_web_devicons()

    local highlights = {
      MiniIconsVite = '#9752FF',
      MiniIconsEslint = '#8181F2',
      MiniIconsGit = '#F05133',
      MiniIconsTmux = '#1BB91F',
      MiniIconsDocker = '#037CC7',
      MiniIconsPnpm = '#F9AD00',
      MiniIconsNpm = '#CB0000',
      MiniIconsNginx = '#009800',
      MiniIconsTS = '#2D79C7',
      MiniIconsPostCSS = '#DD3A0A',
    }

    local function set_highlights()
      for group, color in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, {
          fg = color,
        })
      end
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = set_highlights,
    })

    set_highlights()
  end,
}
