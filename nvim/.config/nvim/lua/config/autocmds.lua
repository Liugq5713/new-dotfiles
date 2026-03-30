-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- #5: 全局 autoformat 已在 options.lua 中用 vim.g.autoformat = false 关闭
-- 删除了对所有 FileType 暴力设置 vim.b.autoformat = false 的 autocmd

vim.api.nvim_create_user_command("DiagnosticToggle", function()
  local config = vim.diagnostic.config
  local vt = config().virtual_text
  config({
    virtual_text = not vt,
    underline = not vt,
    signs = not vt,
  })
end, { desc = "toggle diagnostic" })
