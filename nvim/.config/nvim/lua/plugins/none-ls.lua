return {
  'nvimtools/none-ls.nvim',

  event = 'VeryLazy',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, {})

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = { 'prettier', 'eslint_d', '', 'shfmt' },
      automatic_installation = true,
    }

    local sources = {
      formatting.prettier.with {
        extra_args = function(params)
          return { '--stdin-filepath', params.bufname }
        end,
      },
      formatting.stylua,
      diagnostics.eslint_d,
      formatting.shfmt.with { args = { '-i', '4' } },
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client:supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
  end,
}
