return {
  'numToStr/Comment.nvim',
  event = 'BufReadPost',

  dependencies = {
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      opts = {
        enable_autocmd = false,
      },
    },
  },

  opts = function()
    return {
      mappings = {
        basic = false,
        extra = false,
      },

      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }
  end,

  keys = {
    { '<C-/>', 'gcc', mode = 'n', remap = true, desc = 'Toggle comment' },
    { '<C-_>', 'gcc', mode = 'n', remap = true, desc = 'Toggle comment' },

    { '<C-/>', 'gc', mode = 'x', remap = true, desc = 'Toggle comment' },
    { '<C-_>', 'gc', mode = 'x', remap = true, desc = 'Toggle comment' },
  },
}
