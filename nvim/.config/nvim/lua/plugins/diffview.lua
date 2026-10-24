return {
  'sindrets/diffview.nvim',
  cmd = {
    'DiffviewOpen',
    'DiffviewFileHistory',
  },

  opts = {
    diff_binaries = false,
    enhanced_diff_hl = false,

    git_cmd = { 'git' },
    hg_cmd = { 'hg' },

    use_icons = true,
    show_help_hints = true,
    watch_index = true,

    icons = {
      folder_closed = '',
      folder_open = '',
    },

    signs = {
      fold_closed = '',
      fold_open = '',
      done = '✓',
    },

    view = {
      default = {
        layout = 'diff2_horizontal',
        disable_diagnostics = false,
        winbar_info = false,
      },

      merge_tool = {
        layout = 'diff3_horizontal',
        disable_diagnostics = true,
        winbar_info = true,
      },

      file_history = {
        layout = 'diff2_horizontal',
        disable_diagnostics = false,
        winbar_info = false,
      },
    },

    file_panel = {
      listing_style = 'tree',

      tree_options = {
        flatten_dirs = true,
        folder_statuses = 'only_folded',
      },

      win_config = {
        position = 'left',
        width = 35,
        win_opts = {},
      },
    },

    file_history_panel = {
      log_options = {
        git = {
          single_file = {
            diff_merges = 'combined',
          },

          multi_file = {
            diff_merges = 'first-parent',
          },
        },
      },

      win_config = {
        position = 'bottom',
        height = 16,
        win_opts = {},
      },
    },
  },
}
