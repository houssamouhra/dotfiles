return {
  'mhinz/vim-startify',
  config = function()
    local function pad(str, len)
      local pad_len = math.max(0, len - vim.fn.strdisplaywidth(str))
      return str .. string.rep(' ', pad_len)
    end

    local function center_text(lines)
      -- Use a realistic max width; many people use 100–140 range
      local width = math.min(vim.o.columns or 100, 140)
      local centered = {}
      for _, line in ipairs(lines) do
        local visible_width = vim.fn.strdisplaywidth(line)
        local left_pad = math.floor((width - visible_width) / 2)
        table.insert(centered, string.rep(' ', left_pad) .. line)
      end
      return centered
    end

    local raw_header = {
      '', -- top margin
      '███╗   ██╗██╗   ██╗██╗███╗   ███╗',
      '████╗  ██║██║   ██║██║████╗ ████║',
      '██╔██╗ ██║██║   ██║██║██╔████╔██║',
      '██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
      '██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
      '╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
      '',
      'Welcome back, Houssam!  🚀',
      '',
      'Let’s build something great today.',
    }

    vim.g.startify_custom_header = center_text(raw_header)

    vim.g.startify_fortune_use_unicode = 0
    vim.g.startify_enable_special = 0
  end,
}
