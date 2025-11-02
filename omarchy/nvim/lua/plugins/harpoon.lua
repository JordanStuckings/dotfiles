return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
    config = function(_, opts)
      local harpoon = require("harpoon")
      harpoon:setup(opts)

      local list = harpoon:list()
      local set = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      set("<leader>ha", function()
        list:append()
      end, "Harpoon Add File")

      set("<leader>hh", function()
        harpoon.ui:toggle_quick_menu(list)
      end, "Harpoon Menu")

      for i = 1, 5 do
        set(string.format("<leader>h%s", i), function()
          list:select(i)
        end, string.format("Harpoon File %d", i))
      end
    end,
  },
}
