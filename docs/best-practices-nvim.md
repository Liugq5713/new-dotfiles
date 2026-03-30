# Neovim 配置最佳实践审查

基于 `nvim/.config/nvim/` 的逐项审查，框架为 LazyVim v8 + lazy.nvim。

---

## 强烈推荐（应尽快修复）

### 1. Copilot Node 路径硬编码到特定版本

`init.lua:4`：

```lua
vim.g.copilot_node_command = "~/.nvm/versions/node/v20.17.0/bin/node"
```

nvm 切换 Node 版本后这个路径就失效了。

**建议**：用动态路径或直接去掉（Copilot 会自动检测）：

```lua
-- 方案 A：使用 nvm 的 default alias
vim.g.copilot_node_command = vim.fn.expand("~/.nvm/alias/default")

-- 方案 B：直接使用系统 PATH 中的 node（推荐）
-- 不设置此变量，让 Copilot 自己找
```

### 2. ESLint resolvePluginsRelativeTo 硬编码

`lua/plugins/nvim-lspconfig.lua:10`：

```lua
resolvePluginsRelativeTo="/Users/liuguangqi/.nvm/versions/node/v18.20.2/lib/node_modules/@xhs/formula-cli"
```

双重问题：绝对路径 + 特定 Node 版本。

**建议**：如果这是公司内部工具要求，至少用 `vim.fn.expand` 或环境变量：

```lua
resolvePluginsRelativeTo = vim.fn.expand("~") .. "/.nvm/versions/node/v18.20.2/lib/node_modules/@xhs/formula-cli"
-- 或通过环境变量
resolvePluginsRelativeTo = os.getenv("FORMULA_CLI_PATH") or ""
```

### 3. markdownlint 配置路径硬编码

`lua/plugins/lint.lua:7`：

```lua
args = { "--config", "/Users/liuguangqi/.config/nvim/.markdownlint-cli2.yaml", "--" },
```

**建议**：使用 `vim.fn.stdpath`：

```lua
args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml", "--" },
```

### 4. `vim.loop` 已废弃

`lua/config/lazy.lua:2`：

```lua
if not vim.loop.fs_stat(lazypath) then
```

从 Neovim 0.10 起，`vim.loop` 已改名为 `vim.uv`。`vim.loop` 仍可用但会有废弃警告。

```lua
if not (vim.uv or vim.loop).fs_stat(lazypath) then
```

### 5. autoformat 全局关闭方式过于暴力

`lua/config/autocmds.lua:6-10`：

```lua
vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    vim.b.autoformat = false
  end,
})
```

这对**所有文件类型**关闭了自动格式化，没有 pattern 过滤。如果你确实想全局关闭，LazyVim 有更规范的方式：

```lua
-- 在 options.lua 中
vim.g.autoformat = false  -- LazyVim 原生支持的全局开关
```

然后对想开启的文件类型单独打开：

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "json" },
  callback = function() vim.b.autoformat = true end,
})
```

---

## 比较推荐（显著提升体验）

### 6. vim-sandwich 与 LazyVim 内置 mini-surround 冲突

你同时启用了 `vim-sandwich`（`lua/plugins/vim-sandwich.lua`）和 LazyVim extra `mini-surround`（`lazyvim.json` 中）。两者功能完全重叠。

**建议**：选一个。mini-surround 是 LazyVim 生态内的，配置一致性更好。vim-sandwich 功能更强但学习成本更高。如果没有特别依赖 vim-sandwich 的高级功能，建议只用 mini-surround，删除 `vim-sandwich.lua`。

### 7. disabled.lua 文件名有歧义但内容不匹配

```lua
-- lua/plugins/disabled.lua
return {
  { "saghen/blink.cmp", enabled = true },
}
```

文件名叫 "disabled" 但实际在 **启用** blink.cmp。看起来像是调试残留。

**建议**：如果 blink.cmp 需要保持启用，这行没有意义（默认就是启用的），直接删除此文件。如果要禁用插件，集中在一个文件里管理：

```lua
-- lua/plugins/disabled.lua（只放真正要禁用的）
return {
  { "bufferline.nvim", enabled = false },
  { "folke/edgy.nvim", enabled = false },
}
```

### 8. 补全菜单的 C-j/C-k 绑定重复

`keymaps.lua:10-11` 用 `vim.api.nvim_set_keymap` 设置了 pumvisible 判断的 C-j/C-k，同时 `blink.lua:17-18` 也设置了 C-j/C-k。blink.cmp 有自己的补全菜单，前者可能已经无效。

**建议**：删除 `keymaps.lua` 中的 C-j/C-k pumvisible 映射，只保留 blink.lua 中的配置。

### 9. 缺少 LazyVim extras: copilot

你在 `init.lua` 中配置了 Copilot 相关变量，在 `lazyvim.json` extras 中有 codeium，但没有 `lazyvim.plugins.extras.ai.copilot`。

如果你在用 GitHub Copilot，建议添加对应的 extra：

```json
"lazyvim.plugins.extras.ai.copilot"
```

如果已经不用了，清理 `init.lua` 中的 `copilot_proxy_strict_ssl` 和 `copilot_node_command`。

### 10. `version = '*'` 在 nvim-lspconfig 上可能导致旧版本

`lua/plugins/nvim-lspconfig.lua:3`：

```lua
version = '*',
```

LazyVim 的 lazy.lua 默认设置 `version = false`（使用最新 commit），而这里单独给 lspconfig 锁定到最新 tag。nvim-lspconfig 的 tag 更新经常滞后于 main 分支的 LSP server 支持。

**建议**：去掉 `version = '*'`，跟随 LazyVim 默认策略使用最新 commit。

### 11. `vim.opt.spell` 和 `vim.o.spell` 重复设置

`lua/config/options.lua:6-7`：

```lua
vim.opt.spell = false
vim.o.spell = false
```

两行作用完全相同，保留一行即可。

---

## 推荐（锦上添花）

### 12. 考虑启用 inlay hints（按需）

`nvim-lspconfig.lua:5`：`inlay_hints = { enabled = false }`

Neovim 0.10+ 原生支持 inlay hints，对 TypeScript 开发体验提升明显（显示推断的类型、参数名等）。可以试试开启，不喜欢再关。LazyVim 支持 `<leader>uh` 快捷键切换。

### 13. obsidian.nvim 注释模板噪音

`lua/plugins/obsidian.lua` 中有大量来自插件 README 的注释模板（`-- see below for full list...`），建议清理只保留实际配置。

### 14. keymaps.lua 中 `/` 映射意义不明

```lua
vim.api.nvim_set_keymap('i', '/', '/', { noremap = true, silent = true })
```

把 `/` 映射到 `/`，没有改变行为。看起来像是调试残留或防止某个插件拦截 `/`。如果没有实际用途，建议删除。

### 15. open-browser.vim 可能已被替代

LazyVim 的 `gx` 默认会调用系统打开 URL。如果你没有用 open-browser.vim 的其他命令（如 `:OpenBrowser`），这个插件可能多余了。

### 16. wildfire.vim 可考虑替代

`wildfire.vim` 最后更新是 2020 年。Treesitter 的增量选择（`<CR>` 在 LazyVim 中默认绑定）功能类似且更精准。如果你主要用 wildfire 做快速选择，试试 LazyVim 内置的 treesitter incremental selection。
