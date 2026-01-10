return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local dashboard = require 'alpha.themes.dashboard'

    -- Header
    dashboard.section.header.val = {
      [[                                                                   ]],
      [[ ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
      [[ ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
      [[ ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
      [[ ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
      [[ ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
      [[ ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ]],
      [[ ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ]],
      [[  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],
      [[                                                                   ]],
    }

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button('e', '   New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('f', '󰱼   Find file', ":lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files' } })<CR>"),
      dashboard.button('F', '󰥨   Find folder', ':lua search_and_scope_into_directory()<CR>'),
      dashboard.button('r', '   Recent', ':Telescope oldfiles<CR>'),
      dashboard.button('c', '   Config', ':cd ~/.config/nvim | Telescope find_files<CR>'),
      dashboard.button('l', '󰒲   Lazy', ':Lazy<CR>'),
      dashboard.button('h', '   Settings', ':cd ~/.config/hypr | Telescope find_files<CR>'),
      dashboard.button('q', '   Quit', ':qa<CR>'),
    }

    -- Footer
    dashboard.section.footer.val = {
      '',
      'Welcome back G!',
    }

    require('alpha').setup(dashboard.opts)
  end,
}
