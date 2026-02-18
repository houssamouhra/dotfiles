return {
  'echasnovski/mini.icons',
  version = false,
  lazy = true,
  init = function()
    require('mini.icons').setup {
      opts = {
        file = {
          ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
          ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        },
        filetype = {
          dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        },
      },
    }
    require('mini.icons').mock_nvim_web_devicons()
  end,
}
