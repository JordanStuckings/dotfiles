-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local strudel = require("strudel")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>ul", strudel.launch, { desc = "Launch Strudel" })
vim.keymap.set("n", "<leader>uq", strudel.quit, { desc = "Quit Strudel" })
vim.keymap.set("n", "<leader>ut", strudel.toggle, { desc = "Strudel Toggle Play/Stop" })
vim.keymap.set("n", "<leader>uu", strudel.update, { desc = "Strudel Update" })
vim.keymap.set("n", "<leader>us", strudel.stop, { desc = "Strudel Stop Playback" })
vim.keymap.set("n", "<leader>ub", strudel.set_buffer, { desc = "Strudel set current buffer" })
vim.keymap.set("n", "<leader>ux", strudel.execute, { desc = "Strudel set current buffer and update" })
