return {
  -- main telescope plugin
  'nvim-telescope/telescope.nvim',
  branch = 'master',

  -- lazy loading triggers
  cmd = 'Telescope',

  -- load on keypress
  keys = {
    -- search help
    {
      '<leader>sh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = '[s]earch [h]elp',
    },

    -- search keymaps
    {
      '<leader>sk',
      function()
        require('telescope.builtin').keymaps()
      end,
      desc = '[s]earch [k]eymaps',
    },

    -- find files
    {
      '<leader>sf',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = '[s]earch [f]iles',
    },

    -- list telescope pickers
    {
      '<leader>ss',
      function()
        require('telescope.builtin').builtin()
      end,
      desc = '[s]earch [s]elect telescope',
    },

    -- search word under cursor
    {
      '<leader>sw',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = '[s]earch current [w]ord',
    },

    -- live grep search
    {
      '<leader>sg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = '[s]earch by [g]rep',
    },

    -- diagnostics
    {
      '<leader>sd',
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = '[s]earch [d]iagnostics',
    },

    -- resume last telescope screen
    {
      '<leader>sr',
      function()
        require('telescope.builtin').resume()
      end,
      desc = '[s]earch [r]esume',
    },

    -- recent files
    {
      '<leader>s.',
      function()
        require('telescope.builtin').oldfiles()
      end,
      desc = '[s]earch recent files',
    },

    -- buffer switcher
    {
      '<leader><leader>',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'find existing buffers',
    },

    -- fuzzy search inside current buffer
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      desc = '[/] search in current buffer',
    },

    -- live grep in open files only
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'live grep in open files',
        }
      end,
      desc = '[s]earch [/] in open files',
    },

    -- Pomodoro
    {
      '<leader>pt',
      function()
        require('telescope').load_extension 'pomodori'
        require('telescope').extensions.pomodori.timers()
      end,
      desc = 'Manage Pomodoro Timers',
    },
  },

  -- plugin setup
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'

    telescope.setup {
      -- default telescope behavior
      defaults = {
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous, -- move selection up
            ['<C-j>'] = actions.move_selection_next, -- move selection down
            ['<C-l>'] = actions.select_default, -- open selected file
          },
        },
      },

      -- configure individual pickers
      pickers = {
        find_files = {
          hidden = true, -- include hidden files
          file_ignore_patterns = { 'node_modules', '^%.git/', '%.venv' }, -- only ignore the .git folder
        },
        live_grep = {
          file_ignore_patterns = { 'node_modules', '%.git/', '%.venv' },
          additional_args = function()
            return { '--hidden' }
          end, -- grep hidden files too
        },
      },

      -- configure telescope extensions
      extensions = {
        ['ui-select'] = require('telescope.themes').get_dropdown(),
      },
    }
  end,
}
