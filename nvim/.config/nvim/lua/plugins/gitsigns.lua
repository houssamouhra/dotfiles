return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },

  keys = {
    {
      '<leader>gp',
      '<cmd>Gitsigns preview_hunk<CR>',
      desc = '[g]it [p]review hunk',
    },
    {
      '<leader>gt',
      '<cmd>Gitsigns toggle_current_line_blame<CR>',
      desc = '[g]it [t]oggle blame',
    },
  },

  opts = function()
    local signs = {
      add = { text = '▐' },
      change = { text = '▐' },
      delete = { text = '▐' },
      topdelete = { text = '▐' },
      changedelete = { text = '▐' },
      untracked = { text = '▐' },
    }

    return {
      signs = signs,
      signs_staged = signs,
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,

      watch_gitdir = {
        follow_files = true,
        interval = 1000,
      },

      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false,

      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        virt_text_priority = 100,
        delay = 1000,
        ignore_whitespace = false,
        use_focus = true,
      },

      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 9,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    }
  end,
}
