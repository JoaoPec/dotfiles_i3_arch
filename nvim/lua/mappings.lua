local map = vim.keymap.set

-- LSP Diagnostics
map("n", "gl", function() vim.diagnostic.open_float() end, { desc = "Show diagnostic" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "gr", function() vim.lsp.buf.references() end, { desc = "Show references" })
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover docs" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })

-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })

-- Window navigation
map("n", "<M-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<M-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<M-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<M-k>", "<C-w>k", { desc = "Go to upper window" })

-- Save
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Copy to clipboard
map("n", "<leader>y", function()
  vim.cmd('normal! "+y')
  vim.notify("yanked to +", vim.log.levels.INFO, { title = "Clipboard" })
end, { desc = "Copy to clipboard" })

-- Clear highlights
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- Floating terminal
map("n", "<C-h>", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map("t", "<C-h>", "<cmd>ToggleTerm<CR>", { desc = "Close floating terminal" })
