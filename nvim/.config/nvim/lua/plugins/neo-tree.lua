return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  lazy = true,
  cmd = 'Neotree',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-mini/mini.icons',
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },

  keys = {
    {
      '<C-n>',
      '<cmd>Neotree toggle position=left<CR>',
      desc = 'Toggle Neo-tree',
    },
    {
      '\\',
      '<cmd>Neotree reveal<CR>',
      desc = 'Reveal current file',
    },
    {
      '<leader>ngs',
      '<cmd>Neotree float git_status<CR>',
      desc = 'Git status',
    },
  },

  opts = {
    log_level = 'error',
    close_if_last_window = false,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    enable_winbar = false,
    use_libuv_file_watcher = true,
    open_files_do_not_replace_types = {
      'terminal',
      'trouble',
      'qf',
    },

    -- Components
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
        provider = function(icon, node)
          local mini_icons = require 'mini.icons'

          if node.type == 'directory' then
            local glyph, hl = mini_icons.get('directory', node.name)
            icon.text = glyph
            icon.highlight = hl
          elseif node.type == 'file' then
            local glyph, hl = mini_icons.get('file', node.path)
            icon.text = glyph
            icon.highlight = hl
          end
        end,
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

    -- Main Window
    window = {
      position = 'left',
      width = 28,

      mapping_options = {
        noremap = true,
        nowait = true,
      },

      -- keybindings inside neotree window
      mappings = {
        ['<space>'] = 'toggle_node',
        ['<2-LeftMouse>'] = 'open',
        ['<cr>'] = 'open',
        ['P'] = { 'toggle_preview', config = { use_float = true } },
        ['H'] = 'toggle_hidden',
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

    -- Filesystem
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_name = {
          '.next',
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

    -- Buffers Source
    buffers = {
      follow_current_file = { enabled = true, leave_dirs_open = false },
      group_empty_dirs = true,
      show_unloaded = true,
    },

    -- Git Status Source
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
  },
}
