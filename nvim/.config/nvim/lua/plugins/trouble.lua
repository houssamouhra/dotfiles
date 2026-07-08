return {
  'folke/trouble.nvim',
  cmd = 'Trouble',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics' },
    { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'Symbols' },
    { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP Definitions / References' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<CR>', desc = 'Location List' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix List' },
  },

  opts = {
    auto_close = false,
    auto_open = false,
    auto_preview = true,
    auto_refresh = true,
    auto_jump = false,

    focus = false,
    restore = true,
    follow = true,

    indent_guides = true,
    multiline = true,
    pinned = false,

    max_items = 200,

    warn_no_results = true,
    open_no_results = false,

    win = {},

    preview = {
      type = 'main',
      scratch = true,
    },

    throttle = {
      refresh = 20,
      update = 10,
      render = 10,
      follow = 100,
      preview = {
        ms = 100,
        debounce = true,
      },
    },

    keys = {
      ['?'] = 'help',
      ['<esc>'] = 'cancel',
      ['<cr>'] = 'jump',
      ['<2-leftmouse>'] = 'jump',
      ['<c-s>'] = 'jump_split',
      ['<c-v>'] = 'jump_vsplit',

      q = 'close',
      o = 'jump_close',

      r = 'refresh',
      R = 'toggle_refresh',

      ['}'] = 'next',
      [']]'] = 'next',
      ['{'] = 'prev',
      ['[['] = 'prev',

      dd = 'delete',
      d = { action = 'delete', mode = 'v' },

      i = 'inspect',
      p = 'preview',
      P = 'toggle_preview',

      zo = 'fold_open',
      zO = 'fold_open_recursive',
      zc = 'fold_close',
      zC = 'fold_close_recursive',
      za = 'fold_toggle',
      zA = 'fold_toggle_recursive',
      zm = 'fold_more',
      zM = 'fold_close_all',
      zr = 'fold_reduce',
      zR = 'fold_open_all',
      zx = 'fold_update',
      zX = 'fold_update_all',
      zn = 'fold_disable',
      zN = 'fold_enable',
      zi = 'fold_toggle_enable',
    },

    modes = {
      lsp_references = {
        params = {
          include_declaration = true,
        },
      },

      lsp_base = {
        params = {
          include_current = false,
        },
      },

      symbols = {
        desc = 'Document Symbols',
        mode = 'lsp_document_symbols',
        focus = false,

        win = {
          position = 'right',
        },

        filter = {
          ['not'] = {
            ft = 'lua',
            kind = 'Package',
          },

          any = {
            ft = {
              'help',
              'markdown',
            },

            kind = {
              'Class',
              'Constructor',
              'Enum',
              'Field',
              'Function',
              'Interface',
              'Method',
              'Module',
              'Namespace',
              'Package',
              'Property',
              'Struct',
              'Trait',
            },
          },
        },
      },
    },

    icons = {
      indent = {
        top = '│ ',
        middle = '├╴',
        last = '└╴',
        fold_open = ' ',
        fold_closed = ' ',
        ws = '  ',
      },

      folder_closed = ' ',
      folder_open = ' ',

      kinds = {
        Array = ' ',
        Boolean = '󰨙 ',
        Class = ' ',
        Constant = '󰏿 ',
        Constructor = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Function = '󰊕 ',
        Interface = ' ',
        Key = ' ',
        Method = '󰊕 ',
        Module = ' ',
        Namespace = '󰦮 ',
        Null = ' ',
        Number = '󰎠 ',
        Object = ' ',
        Operator = ' ',
        Package = ' ',
        Property = ' ',
        String = ' ',
        Struct = '󰆼 ',
        TypeParameter = ' ',
        Variable = '󰀫 ',
      },
    },
  },
}
