return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      ensure_installed = {
        'lua',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'jsdoc',
        'python',
        'vue',
        'tsx',
        'json',
        'yaml',
        'html',
        'css',
        'gitignore',
        'prisma',
        'regex',
        'bash',
        'dockerfile',
        'toml',
        'query',
        'markdown',
        'markdown_inline',
      },
      sync_install = false,
      auto_install = true,
      indent = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'html', 'sh', 'markdown', 'dockerfile', 'yaml', 'yml', 'css', 'prisma', 'javascriptreact', 'typescriptreact', 'javascript', 'typescript' },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
