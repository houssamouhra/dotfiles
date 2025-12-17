-- Main diagnostics behavior
vim.diagnostic.config {
  virtual_text = {
    prefix = '■',
    spacing = 2,
  },
  underline = true,
  signs = true,
  update_in_insert = false,
}

-- Styling
local function set_diagnostic_hls()
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { italic = true })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { italic = true })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { italic = true })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { italic = true })
end

-- Apply once
set_diagnostic_hls()

-- Keymaps for navigation
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics list' })
