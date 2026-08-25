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
      desc = 'Format buffer',
    },
  },

  opts = function()
    local prettier = {
      'prettierd',
      'prettier',
      stop_after_first = true,
    }

    return {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format' },
        javascript = prettier,
        typescript = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        vue = prettier,
        html = prettier,
        css = prettier,
        markdown = prettier,
        json = prettier,
        yaml = prettier,
        sql = { 'sqruff' },
        sh = { 'shfmt' },
        toml = { 'taplo' },
        tex = { 'tex-fmt' },
      },

      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false,
      },
    }
  end,
}
