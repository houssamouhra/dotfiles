return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
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
    }

    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd({
      'BufEnter',
      'BufWritePost',
      'InsertLeave',
    }, {
      group = lint_augroup,
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
