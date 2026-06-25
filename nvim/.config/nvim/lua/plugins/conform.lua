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
    local prettier = { 'prettierd', 'prettier', stop_after_first = true }

    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format' },
        javascript = prettier,
        typescript = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        markdown = prettier,
        vue = prettier,
        html = prettier,
        css = prettier,
        json = prettier,
        sql = { 'sqruff' },
        yaml = prettier,
        sh = { 'shfmt' },
        toml = { 'taplo' },
      },

      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false,
      },
    }
  end,
}
