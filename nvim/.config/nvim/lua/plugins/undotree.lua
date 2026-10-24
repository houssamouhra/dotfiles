return {
  'jiaoshijie/undotree',
  opts = {
    float_diff = true,
    --- @type "left_bottom" | "left_left_bottom"
    layout = 'left_bottom',
    --- @type "left" | "right"
    position = 'left',
    window = {
      width = 0.15,
      height = 0.15,
    },
  },
  keys = {
    { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
