return {
  'mfussenegger/nvim-dap',

  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        'nvim-neotest/nvim-nio',
      },
      opts = {},
    },

    'mfussenegger/nvim-dap-python',
  },

  keys = {
    {
      '<leader>dt',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = '[d]ebug [t]oggle breakpoint',
    },

    {
      '<leader>dn',
      function()
        require('dap').continue()
      end,
      desc = '[d]ebug co[n]tinue',
    },

    {
      '<leader>do',
      function()
        require('dap').step_over()
      end,
      desc = '[d]ebug step [o]ver',
    },

    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = '[d]ebug step [i]nto',
    },

    {
      '<leader>du',
      function()
        require('dap').step_out()
      end,
      desc = '[d]ebug step o[u]t',
    },

    {
      '<leader>dr',
      function()
        require('dap').restart()
      end,
      desc = '[d]ebug [r]estart',
    },

    {
      '<leader>dq',
      function()
        require('dap').terminate()
      end,
      desc = '[d]ebug [q]uit',
    },

    {
      '<leader>dp',
      function()
        require('dapui').toggle()
      end,
      desc = '[d]ebug da[p] UI',
    },
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('dap-python').setup 'python3'

    local icons = {
      breakpoint = ' ',
      breakpoint_condition = ' ',
      log_point = ' ',
      stopped = ' ',
      breakpoint_rejected = ' ',
    }

    vim.fn.sign_define('DapBreakpoint', {
      text = icons.breakpoint,
    })

    vim.fn.sign_define('DapBreakpointCondition', {
      text = icons.breakpoint_condition,
    })

    vim.fn.sign_define('DapLogPoint', {
      text = icons.log_point,
    })

    vim.fn.sign_define('DapStopped', {
      text = icons.stopped,
    })

    vim.fn.sign_define('DapBreakpointRejected', {
      text = icons.breakpoint_rejected,
    })

    dap.listeners.after.event_initialized.dapui_config = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end

    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
