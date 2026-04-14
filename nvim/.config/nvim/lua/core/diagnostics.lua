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
