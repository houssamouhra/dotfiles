return {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),

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
}
