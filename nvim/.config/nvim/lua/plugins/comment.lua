return {
  'numToStr/Comment.nvim',
  event = 'BufReadPost',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }

    require('Comment').setup {
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }

    local api = require 'Comment.api'
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    map('n', '<C-/>', api.toggle.linewise.current, opts)
    map('n', '<C-_>', api.toggle.linewise.current, opts)

    map('v', '<C-/>', function()
      api.toggle.linewise(vim.fn.visualmode())
    end, opts)
    map('v', '<C-_>', function()
      api.toggle.linewise(vim.fn.visualmode())
    end, opts)
  end,
}
