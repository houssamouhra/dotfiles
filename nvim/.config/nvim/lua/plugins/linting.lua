return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      javascript = { 'eslint' },
      typescript = { 'eslint' },
      sh = { 'shellcheck' },
      markdown = { 'vale' },
    }

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
