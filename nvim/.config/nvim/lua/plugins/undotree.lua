return {
  'jiaoshijie/undotree',
  opts = {
    float_diff = true,
    --- @type "left_bottom" | "left_left_bottom"
    layout = 'left_bottom',
    --- @type "left" | "right"
    position = 'left',
    window = {
      width = 0.15, -- the `undotree` window width percentage related to the editor
      height = 0.15, -- the `preview`(not floating) window height percentage related to the editor
    },
  },
  keys = {
    { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
