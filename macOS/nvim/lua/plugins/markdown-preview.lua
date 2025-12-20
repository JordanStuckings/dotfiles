return {
  {
    "ellisonleao/glow.nvim",
    cmd = { "Glow" },
    ft = { "markdown" },
    keys = {
      { "<leader>um", "<cmd>Glow<cr>", desc = "Markdown Preview (Glow)" },
    },
    opts = {
      style = "dark",
      border = "none",
      width_ratio = 1.0,
      height_ratio = 1.0,
    },
  },
}
