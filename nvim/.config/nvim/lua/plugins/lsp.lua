return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  dependencies = {
    {
      'mason-org/mason.nvim',
      config = true,
    },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            winblend = 0,
          },
        },
      },
    },
    'hrsh7th/cmp-nvim-lsp',
  },

  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('K', vim.lsp.buf.hover, 'Hover')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- disabling formatting capabilities globally here.
        if client then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        -- Document highlight
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints toggle
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Capabilities (still needed for cmp)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Setup mason + mason-lspconfig
    require('mason-lspconfig').setup {
      ensure_installed = {
        'emmet_language_server',
        'html',
        'cssls',
        'ts_ls',
        'tailwindcss',
        'basedpyright',
        'dockerls',
        'sqlls',
        'jsonls',
        'yamlls',
        'lua_ls',
        'prismals',
      },
      automatic_installation = true,
    }

    require('mason-tool-installer').setup {
      ensure_installed = { 'stylua' },
    }

    vim.lsp.config('emmet_language_server', {
      capabilities = capabilities,
      filetypes = {
        'html',
        'css',
        'scss',
        'sass',
        'less',
        'javascriptreact',
        'typescriptreact',
        'vue',
        'svelte',
        'astro',
      },
      init_options = {
        html = {
          options = {
            ['output.selfClosingStyle'] = 'xhtml',
          },
        },
        javascript = {
          options = {
            ['output.selfClosingStyle'] = 'xhtml',
          },
        },
        typescript = {
          options = {
            ['output.selfClosingStyle'] = 'xhtml',
          },
        },
      },
    })
    vim.lsp.enable 'emmet_language_server'
  end,
}
