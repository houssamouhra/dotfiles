return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',

  opts = {
    ensure_installed = {
      'bash',
      'zsh',
      'css',
      'dockerfile',
      'gitignore',
      'html',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'prisma',
      'python',
      'query',
      'regex',
      'sql',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'vue',
      'yaml',
    },

    sync_install = false,
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
    },
  },

  config = function(_, opts)
    require('nvim-treesitter').setup(opts)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'html',
        'css',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'dockerfile',
        'markdown',
        'prisma',
        'python',
        'sh',
        'zsh',
        'sql',
        'yaml',
        'yml',
      },
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)

        if lang and pcall(vim.treesitter.start, args.buf, lang) then
          return
        end
      end,
    })
  end,
}
