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
    local oxfmt = {
      'oxfmt',
      stop_after_first = true,
    }

    return {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        javascript = oxfmt,
        typescript = oxfmt,
        javascriptreact = oxfmt,
        typescriptreact = oxfmt,
        vue = oxfmt,
        html = oxfmt,
        css = oxfmt,
        markdown = oxfmt,
        json = oxfmt,
        yaml = oxfmt,
        sql = { 'sqruff' },
        sh = { 'shfmt' },
        tex = { 'tex-fmt' },
      },

      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false,
      },
    }
  end,
}
