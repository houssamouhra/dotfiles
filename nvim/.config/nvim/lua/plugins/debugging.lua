return {
  'mfussenegger/nvim-dap',
  cmd = {
    'DapToggleBreakpoint',
    'DapContinue',
  },

  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        'nvim-neotest/nvim-nio',
      },
      opts = {},
    },
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
      '<leader>dv',
      function()
        require('dap').continue()
      end,
      desc = '[d]ebug continue',
    },
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

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
