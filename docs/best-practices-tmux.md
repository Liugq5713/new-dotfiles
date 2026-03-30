# Tmux 配置最佳实践审查

基于 `tmux/.config/tmux/tmux.conf.local` 的审查。框架为 oh-my-tmux (gpakosz/.tmux)。

---

## 强烈推荐（应尽快修复）

### 1. oh-my-tmux 与 tmux-tokyo-night 主题冲突

oh-my-tmux 有自己完整的 17 色主题系统（在 `.tmux.conf` 的 `_apply_theme` 中），而你又安装了 `tmux-tokyo-night` 插件。两个主题系统会互相覆盖，加载顺序不确定，最终效果取决于谁最后渲染。

**建议**：二选一。
- **保留 tmux-tokyo-night**：考虑去掉 oh-my-tmux 框架，直接用原生 tmux 配置 + tpm 插件管理。oh-my-tmux 的 1900 行配置大部分被你的插件覆盖了。
- **保留 oh-my-tmux**：去掉 tmux-tokyo-night 插件，在 `tmux.conf.local` 中用 oh-my-tmux 的主题变量定义 TokyoNight 配色。

### 2. tmux-copycat 已废弃

tmux-copycat 的 GitHub 明确标注已废弃。tmux 3.1+ 原生支持正则搜索（`prefix + /` 在复制模式下已内置）。

```bash
# 删除
set -g @plugin 'tmux-plugins/tmux-copycat'
```

tmux 3.6a 原生用法：`prefix + [` 进入复制模式，然后 `/` 搜索（支持正则）。

### 3. continuum_auto_save 硬编码插件路径

```bash
continuum_auto_save='#(~/.config/tmux/plugins/tmux-continuum/scripts/continuum_save.sh)'
```

这个变量在 oh-my-tmux 的 `_apply_configuration` 中并不会被自动使用。tmux-continuum 自身会注册 hooks 来实现自动保存，不需要手动定义这个变量。

**建议**：删除此行。tmux-continuum 的 `@continuum-restore 'on'` 已经足够。

### 4. `tmux_conf_copy_to_os_clipboard=false` 但装了 tmux-yank

oh-my-tmux 自身有剪贴板集成（通过 `tmux_conf_copy_to_os_clipboard`），同时你又装了 tmux-yank 插件做同样的事。

**建议**：
- 如果用 tmux-yank，删除 `tmux_conf_copy_to_os_clipboard` 这行（让 oh-my-tmux 不管剪贴板）。
- 如果用 oh-my-tmux 的剪贴板，设为 `true` 并去掉 tmux-yank。

---

## 比较推荐（显著提升体验）

### 5. 缺少 `set -g default-terminal` 和 true color 配置

没有看到终端类型和 true color 的显式配置。oh-my-tmux 虽然会设置基础的 256 色，但 true color (24-bit) 需要额外配置：

```bash
# 确保 tmux 内的颜色正确（和 alacritty 配合）
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
```

否则 nvim 在 tmux 内的配色可能失真。

### 6. 缺少 `set -g focus-events on`

oh-my-tmux 的主配置可能已经设置了，但如果你自定义覆盖了某些选项，focus-events 对 nvim 的 auto-save（FocusLost 触发）至关重要：

```bash
set -g focus-events on
```

没有这个，你的 nvim auto-save 在 tmux 内切换 pane 时不会触发。

### 7. `escape-time` 未显式设置

vi 模式用户在 tmux 中按 Esc 会有明显延迟（默认 500ms）。oh-my-tmux 设了 10ms，但确认一下：

```bash
set -sg escape-time 10  # 或 0，减少 Esc 延迟
```

### 8. tmux-resurrect 缺少进程恢复配置

只装了 tmux-resurrect 但没有配置要恢复哪些进程。默认只恢复少数几个命令。

```bash
# 恢复 nvim 会话
set -g @resurrect-strategy-nvim 'session'
# 恢复 pane 内容
set -g @resurrect-capture-pane-contents 'on'
```

### 9. 窗口编号不连续（未设置 renumber-windows）

关闭中间的窗口后，编号会出现空洞（1, 2, 4, 5）。oh-my-tmux 可能已默认开启，但建议显式确认：

```bash
set -g renumber-windows on
```

---

## 推荐（锦上添花）

### 10. tmux-cpu 插件已安装但未在状态栏使用

```bash
set -g @plugin 'tmux-plugins/tmux-cpu'
```

装了但状态栏没有引用 `#{cpu_percentage}` 等变量，属于无效负载。要么在状态栏用上，要么删除。

### 11. 考虑添加 tmux-fzf 或 extrakto

作为 fzf 用户，[tmux-fzf](https://github.com/sainnhe/tmux-fzf) 和 [extrakto](https://github.com/laktak/extrakto) 是很好的补充：
- tmux-fzf：用 fzf 管理 session/window/pane
- extrakto：用 fzf 从 tmux pane 输出中提取文本（URL、路径、哈希等）

### 12. oh-my-tmux 作为普通目录而非 Git 子模块

你移除了 `.gitmodules`，oh-my-tmux 现在是一个普通目录。这意味着它不会自动更新。这有利有弊：
- 好处：不会因为上游更新而导致配置突然不兼容
- 坏处：安全补丁和 bug 修复不会自动获得

**建议**：如果想保持更新能力，在 dotfiles 仓库中重新添加为 git submodule：

```bash
cd ~/growth/dotfiles
git submodule add https://github.com/gpakosz/.tmux.git tmux/.config/tmux/oh-my-tmux
```
