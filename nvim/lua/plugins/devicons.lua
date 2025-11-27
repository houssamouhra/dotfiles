return {
  "echasnovski/mini.icons",
  lazy = true,
  opts = {},

  specs = {
    {
      "nvim-tree/nvim-web-devicons",
      enabled = false,
      optional = true,
    },
  },

  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}

