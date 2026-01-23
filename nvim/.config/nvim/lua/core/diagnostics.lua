-- Main diagnostics behavior
vim.diagnostic.config {
  virtual_text = {
    prefix = '■',
    spacing = 2,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌵 ',
    },
  },
  underline = true,
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
