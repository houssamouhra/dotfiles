return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Open DAP UI when debugging starts
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    -- Close DAP UI when debugging ends
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Keymaps
    vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, { silent = true })
    vim.keymap.set('n', '<leader>dv', dap.continue, { silent = true })
  end,
}
