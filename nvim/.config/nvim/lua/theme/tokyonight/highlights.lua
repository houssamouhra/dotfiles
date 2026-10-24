return function(hl, c)
  hl['@tag.tsx'] = { fg = c.red }

  hl['@type'] = { fg = c.blue, bold = true }
  hl['@type.builtin'] = { fg = c.cyan, bold = true }
  hl['@type.definition'] = { fg = c.yellow, bold = true }

  hl['@lsp.type.interface'] = { fg = c.teal, bold = true }

  hl['@keyword'] = { fg = c.magenta, italic = true }
  hl['@keyword.function'] = { fg = c.magenta, italic = true }

  hl['@keyword.import.typescript'] = { fg = c.cyan }
  hl['@keyword.export.typescript'] = { fg = c.cyan }

  hl['@function'] = { fg = c.blue }
  hl['@function.method'] = { fg = c.cyan }
  hl['@function.call'] = { fg = c.cyan }
end
