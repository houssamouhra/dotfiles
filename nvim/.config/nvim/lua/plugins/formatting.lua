return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = 'ConformInfo',
  event = { 'BufReadPre', 'BufNewFile' },

  keys = {
    {
      '<leader>f',
      function()
        require('conform').format()
      end,
      mode = { 'n', 'x' },
      desc = 'Format Injected Langs',
    },
  },

  config = function()
    local prettier = { 'prettier', stop_after_first = true }

    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = prettier,
        typescript = prettier,
        html = prettier,
        css = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        sh = { 'shfmt' },
      },

      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false,
      },
    }
  end,
}
