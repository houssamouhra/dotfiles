return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },
  event = 'VeryLazy',
  -- lazy load: load only when opening neotree
  cmd = 'Neotree',
  keys = {
    { '<C-n>', ':Neotree toggle position=left<CR>', desc = 'toggle neotree (left)' },
    { '\\', ':Neotree reveal<CR>', desc = 'reveal current file in neotree' },
    { '<leader>ngs', ':Neotree float git_status<CR>', desc = 'show git status in floating neotree' },
  },

  -- plugin configuration
  config = function()
    require('neo-tree').setup {
      close_if_last_window = false, -- do not auto-close if last window
      popup_border_style = 'rounded',
      enable_git_status = true, -- show git icons
      enable_diagnostics = true, -- show lsp diagnostics
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },

      -- default component settings
      default_component_configs = {
        container = { enable_character_fade = true },

        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          expander_collapsed = '',
          expander_expanded = '',
        },

        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },

        modified = { symbol = '[+]', highlight = 'NeoTreeModified' },

        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },

        git_status = {
          symbols = {
            added = '',
            modified = '',
            deleted = '✖',
            renamed = '󰁕',
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
        },

        file_size = { enabled = true, required_width = 64 },
        type = { enabled = true, required_width = 122 },
        last_modified = { enabled = true, required_width = 88 },
        created = { enabled = true, required_width = 110 },
      },

      -- avoid error messages on slow systems
      use_libuv_file_watcher = true,

      -- main tree window settings
      window = {
        position = 'left',
        width = 30,

        mapping_options = { noremap = true, nowait = true },

        -- keybindings inside neotree window
        mappings = {
          ['<space>'] = 'toggle_node',
          ['<2-LeftMouse>'] = 'open',
          ['<cr>'] = 'open',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['l'] = 'open',
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          ['t'] = 'open_tabnew',
          ['w'] = 'open_with_window_picker',
          ['C'] = 'close_node',
          ['z'] = 'close_all_nodes',
          ['a'] = { 'add', config = { show_path = 'none' } },
          ['A'] = 'add_directory',
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy',
          ['m'] = 'move',
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          ['i'] = 'show_file_details',
        },
      },

      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          hide_by_name = {
            '.DS_Store',
            'thumbs.db',
            'node_modules',
            '__pycache__',
            '.venv',
            '.git',
            '.virtual_documents',
            '.python-version',
          },
        },

        follow_current_file = {
          enabled = false,
          leave_dirs_open = false,
        },

        group_empty_dirs = false,
        hijack_netrw_behavior = 'open_default',
      },

      buffers = {
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = true,
        show_unloaded = true,
      },

      git_status = {
        window = {
          position = 'float',
          mappings = {
            ['A'] = 'git_add_all',
            ['gu'] = 'git_unstage_file',
            ['ga'] = 'git_add_file',
            ['gr'] = 'git_revert_file',
            ['gc'] = 'git_commit',
            ['gp'] = 'git_push',
            ['gg'] = 'git_commit_and_push',
          },
        },
      },
    }
  end,
}
