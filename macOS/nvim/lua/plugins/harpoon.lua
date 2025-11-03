return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.loop.cwd()
        end,
      },
    })

    -- Basic keymaps
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Add file" })

    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle menu" })

    -- Navigate to files
    -- vim.keymap.set("n", "<C-H>", function()
    --   harpoon:list():select(1)
    -- end, { desc = "Harpoon: Go to file 1" })
    vim.keymap.set("n", "<C-H>", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: Go to file 1" })
    vim.keymap.set("n", "<C-T>", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: Go to file 2" })
    vim.keymap.set("n", "<C-N>", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: Go to file 3" })
    vim.keymap.set("n", "<C-S>", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: Go to file 4" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-[>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon: Previous file" })
    vim.keymap.set("n", "<C-]>", function()
      harpoon:list():next()
    end, { desc = "Harpoon: Next file" })
  end,
}
