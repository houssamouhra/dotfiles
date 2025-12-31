return {
  'epwalsh/pomo.nvim',

  version = '*', -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { 'TimerStart', 'TimerRepeat', 'TimerSession' },
  dependencies = {
    'rcarriga/nvim-notify',
  },
  config = function()
    require('pomo').setup {
      update_interval = 1000,
      notifiers = {
        {
          name = 'Default',
          opts = {
            sticky = false,
            -- Configure the display icons:
            title_icon = '󱎫',
            text_icon = '󰄉',
          },
        },
        { name = 'System' },
      },

      -- Override the notifiers for specific timer names.
      timers = {
        Break = {
          { name = 'System' },
        },
      },
      sessions = {
        pomo = {
          { name = 'Work', duration = '25m' },
          { name = 'Short Break', duration = '5m' },
          { name = 'Work', duration = '25m' },
          { name = 'Short Break', duration = '5m' },
          { name = 'Work', duration = '25m' },
          { name = 'Long Break', duration = '15m' },
        },
        deep_work = {
          { name = 'Deep Work', duration = '50m' },
          { name = 'Break', duration = '10m' },
        },
        study = {
          { name = 'Study', duration = '90m' },
          { name = 'Rest', duration = '20m' },
        },
      },
    }
  end,
}
