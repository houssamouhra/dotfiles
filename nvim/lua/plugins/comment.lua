return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  config = function()
    require('Comment').setup()

    local api = require 'Comment.api'
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- NORMAL mode: Toggle comment on current line
    map('n', '<C-/>', api.toggle.linewise.current, opts)

    -- VISUAL mode: Toggle comment on selection
    map('v', '<C-/>', function()
      api.toggle.linewise(vim.fn.visualmode())
    end, opts)

    -- fallback for terminals that send <C-_>
    map('n', '<C-_>', api.toggle.linewise.current, opts)
    map('v', '<C-_>', function()
      api.toggle.linewise(vim.fn.visualmode())
    end, opts)
  end,
}
