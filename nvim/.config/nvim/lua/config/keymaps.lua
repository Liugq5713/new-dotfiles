-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- #8: 删除了 C-j/C-k 的 pumvisible 映射（由 blink.lua 统一管理补全菜单导航）
-- #14: 删除了无意义的 '/' → '/' 映射

vim.keymap.set("n", "<leader>ox", function()
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd("!code . && code -g " .. vim.fn.expand("%") .. ":" .. r .. ":" .. c)
end, { desc = "[O]pen E[x]ternal editor" })
