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

    -- :LintInfo command to show the configured linter
    vim.api.nvim_create_user_command('LintInfo', function()
      local ft = vim.bo.filetype
      local linters = lint.linters_by_ft[ft] or {}

      if #linters == 0 then
        vim.notify('No linters configured for ' .. ft, vim.log.levels.WARN)
        return
      end

      vim.notify('Filetype: ' .. ft .. '\nLinters: ' .. table.concat(linters, ', '), vim.log.levels.INFO)
    end, {})
  end,
}
