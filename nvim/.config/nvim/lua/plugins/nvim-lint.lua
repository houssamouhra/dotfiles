return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },

  opts = {
    linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      vue = { 'eslint_d' },
      python = { 'ruff' },
      sh = { 'shellcheck' },
      markdown = { 'vale' },
      dockerfile = { 'hadolint' },
      sql = { 'sqruff' },
    },
  },

  config = function(_, opts)
    local lint = require 'lint'

    lint.linters_by_ft = opts.linters_by_ft

    local group = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd({
      'BufEnter',
      'BufWritePost',
      'InsertLeave',
    }, {
      group = group,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
