# Tmux 配置说明

基于 `tmux/.config/tmux/tmux.conf` 的自包含配置。无框架依赖，仅使用 tpm + 精选插件。

---

## 架构

```
~/.config/tmux/
  tmux.conf          # 唯一配置文件（~110 行）
  plugins/           # tpm 运行时安装（.gitignore 忽略）
  .gitignore         # 忽略 plugins/ 和 resurrect/
```

通过 GNU Stow 从 dotfiles 仓库链接到 `~/.config/tmux/`。

## 核心设置

| 设置 | 值 | 说明 |
|------|------|------|
| prefix | `C-a` | GNU Screen 习惯 |
| default-terminal | `tmux-256color` | 配合 terminal-overrides 实现 true color |
| escape-time | `0` | 无 Esc 延迟，nvim 必需 |
| focus-events | `on` | nvim FocusLost 自动保存 |
| mouse | `on` | 鼠标滚动、选择窗格、调整大小 |
| mode-keys | `vi` | vi 风格复制模式 |
| base-index | `1` | 窗口和窗格从 1 开始编号 |
| history-limit | `50000` | 大容量 scrollback |

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `prefix + -` | 水平分屏（保持当前路径） |
| `prefix + _` | 垂直分屏（保持当前路径） |
| `prefix + c` | 新窗口（保持当前路径） |
| `prefix + h/j/k/l` | vim 方向导航窗格 |
| `prefix + H/J/K/L` | 调整窗格大小 |
| `prefix + < / >` | 左右交换窗口位置 |
| `prefix + C-h / C-l` | 上/下一个窗口 |
| `prefix + Tab` | 切换到上一个活跃窗口 |
| `prefix + s` | session 树选择 |
| `prefix + Enter` | 进入复制模式 |
| `prefix + r` | 重载配置 |

## 插件

| 插件 | 用途 |
|------|------|
| tpm | 插件管理器 |
| tmux-yank | 系统剪贴板集成 |
| tmux-open | 复制模式打开 URL/文件 |
| tmux-resurrect | 会话持久化（含 nvim session 恢复） |
| tmux-continuum | 自动保存/恢复会话 |
| tmux-tokyo-night | Tokyo Night 主题（night 变体） |

首次使用需在 tmux 内按 `prefix + I` 安装插件（tpm 会自动 bootstrap）。

## 变更历史

- **2026-04-02**: 全面重写。移除 oh-my-tmux 框架，改为自包含 tmux.conf。消除框架与主题的冲突，配置从 ~1200 行降到 ~110 行。
