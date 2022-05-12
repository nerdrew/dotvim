vim.keymap.set("n", "<leader>h", "<C-W><cr><C-W>K", { buffer = true })
vim.keymap.set("n", "<leader>H", "<C-W><cr><C-W>K<C-W>b", { buffer = true })
vim.keymap.set("n", "q", ":close<cr>", { buffer = true })
vim.keymap.set("n", "<leader>t", "<C-W><cr><C-W>T", { buffer = true })
vim.keymap.set("n", "<leader>T", "<C-W><cr><C-W>TgT<C-W><C-W>", { buffer = true })
vim.keymap.set("n", "<leader>v", "<C-W><cr><C-W>H<C-W>b<C-W>J<C-W>t", { buffer = true })
vim.keymap.set("n", "<leader>?", ":echo getqflist({'title' : 1})<cr>", { buffer = true })
vim.wo.scrolloff = 1
