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
      json = { 'eslint_d' },
      python = { 'ruff', 'mypy' },
      sh = { 'shellcheck' },
      markdown = { 'vale' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      group = lint_augroup,
      callback = function()
        vim.defer_fn(function()
          require('lint').try_lint()
        end, 50)
      end,
    })
  end,
}
