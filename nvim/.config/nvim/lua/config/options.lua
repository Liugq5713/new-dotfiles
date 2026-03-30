-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.spelllang = { "en", "cjk" }
vim.opt.spell = false -- #11: 删除了重复的 vim.o.spell
vim.opt.wrap = true
vim.g.autowriteall = true

-- #5: 用 LazyVim 原生全局开关关闭 autoformat，替代 autocmds.lua 中对所有 FileType 的暴力关闭
-- 需要对特定文件类型开启时，在 autocmds.lua 中用 vim.b.autoformat = true
vim.g.autoformat = false
