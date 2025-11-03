return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = { enabled = true },
    notifier = { enabled = true },
    terminal = {
      enabled = false,
    },
    picker = {
      hidden = true,
      ignored = true,
      exclude = { "node_modules", ".git" },

      enabled = true,
      sources = {
        explorer = {
          -- win = {
          --   position = "current",
          -- },
          -- focus = "input",
          auto_close = true,
          -- open = {
          --   replace_current = true,
          -- },
        },
      },
    },
    -- explorer = {
    --   git_status = false,
    --   layout = "current",
    --   focus = "input",
    --   auto_close = true,
    --   open = {
    --     replace_current = true,
    --   },
    -- },
  },
}
