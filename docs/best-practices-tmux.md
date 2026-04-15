# Tmux 使用技巧

基于 `tmux/.config/tmux/tmux.conf` 的自包含配置。无框架依赖，仅使用 tpm + 精选插件。

---

## 架构

```
~/.config/tmux/
  tmux.conf          # 唯一配置文件（~155 行）
  plugins/           # tpm 运行时安装（.gitignore 忽略）
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
| status-keys | `emacs` | 命令行提示符用 emacs 模式 |
| base-index | `1` | 窗口和窗格从 1 开始编号 |
| history-limit | `50000` | 大容量 scrollback |
| set-clipboard | `on` | OSC 52 剪贴板，SSH 远程也能复制到本地 |
| allow-passthrough | `all` | 所有 pane 都可绕过 tmux（OSC 52、图片预览等） |
| aggressive-resize | `on` | 多显示器 grouped session 更好用 |
| display-time | `4000` | 消息显示 4 秒，看清提示 |
| display-panes-time | `2000` | pane 编号显示 2 秒，看清编号 |

### 终端能力

- **True color**: `terminal-overrides` 启用 `Tc` 标志
- **Hyperlinks**: `terminal-features` 启用 OSC 8 超链接协议
- **Undercurl**: `Smulx` + `Setulc` overrides，让 Neovim 诊断波浪线正确显示
- **OSC 52**: `set-clipboard on` + `allow-passthrough all`，SSH 远程也能写入本地剪贴板

## 快捷键速查

### 基础操作

| 快捷键 | 功能 |
|--------|------|
| `prefix + r` | 重载配置 |
| `prefix + C-c` | 新建 session |
| `prefix + d` | detach 当前 session（tmux 内置） |

### 窗格（Pane）

| 快捷键 | 功能 |
|--------|------|
| `C-h/j/k/l` | **无 prefix** vim↔tmux 无缝导航 |
| `prefix + -` | 水平分屏（保持当前路径） |
| `prefix + _` | 垂直分屏（保持当前路径） |
| `prefix + H/J/K/L` | 调整窗格大小（步长 5，可重复） |
| `prefix + q` | 显示 pane 编号（2 秒内按数字跳转） |
| `prefix + x` | 关闭当前 pane（tmux 内置） |
| `prefix + z` | 最大化/还原当前 pane（tmux 内置） |

### 窗口（Window）

| 快捷键 | 功能 |
|--------|------|
| `prefix + c` | 新窗口（保持当前路径） |
| `prefix + C-h` | 上一个窗口（可重复） |
| `prefix + C-l` | 下一个窗口（可重复） |
| `prefix + Tab` | 切换到上一个活跃窗口 |
| `prefix + < / >` | 左右交换窗口位置（可重复） |
| `prefix + 1-9` | 跳转到指定编号窗口（tmux 内置） |
| `prefix + ,` | 重命名当前窗口（tmux 内置） |
| `prefix + &` | 关闭当前窗口（tmux 内置） |

### Session

| 快捷键 | 功能 |
|--------|------|
| `prefix + s` | session 树选择 |
| `prefix + o` | session 模糊搜索（tmux-sessionx，基于 fzf） |
| `prefix + Space` | 切换到上一个 session |
| `prefix + $` | 重命名当前 session（tmux 内置） |


### 复制模式

进入方式：`prefix + Enter` 或鼠标滚轮向上滚动。

| 快捷键 | 功能 |
|--------|------|
| `v` | 开始选择 |
| `C-v` | 矩形选择 |
| `y` | 复制并退出 |
| `Escape` | 取消 |
| `H` | 跳到行首 |
| `L` | 跳到行尾 |
| `h/j/k/l` | vim 风格移动光标 |
| `/` | 向下搜索 |
| `?` | 向上搜索 |
| `n/N` | 下一个/上一个搜索结果 |
| 鼠标拖选 | 选中后松开自动复制到系统剪贴板 |

### 缓冲区

| 快捷键 | 功能 |
|--------|------|
| `prefix + b` | 列出所有缓冲区 |
| `prefix + p` | 粘贴最近缓冲区 |
| `prefix + P` | 选择缓冲区粘贴 |

### 插件快捷键

| 快捷键 | 插件 | 功能 |
|--------|------|------|
| `prefix + Tab` | extrakto | 模糊提取屏幕文本（路径/hash/单词），选中后插入或复制 |
| `prefix + u` | tmux-fzf-url | 提取屏幕 URL，fzf 选择后打开（支持跨行长链接） |
| `prefix + o` | tmux-sessionx | fzf 模糊搜索 session |
| `prefix + I` | tpm | 安装插件 |
| `prefix + U` | tpm | 更新插件 |

#### extrakto 使用技巧

`prefix + Tab` 触发后：
- 模糊搜索当前屏幕和 scrollback 中的所有文本片段
- **Tab** — 插入选中文本到当前 pane（适合补全路径、命令参数）
- **Enter** — 复制选中文本到剪贴板
- 典型场景：编译报错后提取文件路径、从 git log 提取 commit hash、从输出中提取 IP 地址

#### tmux-open 使用技巧（复制模式内）

在复制模式中选中文本后：
- `o` — 用系统默认程序打开（URL 用浏览器，文件用对应程序）
- `C-o` — 用 `$EDITOR` 打开
- `S` — 用搜索引擎搜索选中文本

## 插件列表

| 插件 | 用途 |
|------|------|
| tpm | 插件管理器 |
| vim-tmux-navigator | C-h/j/k/l 无缝切换 vim split 和 tmux pane |
| tmux-yank | 系统剪贴板集成 |
| tmux-open | 复制模式打开 URL/文件 |
| tmux-fzf-url | fzf 提取并打开 URL（支持跨行长链接） |
| extrakto | fzf 模糊提取屏幕文本（路径/hash/单词） |
| tmux-nerd-font-window-name | 窗口名自动加 Nerd Font 图标 |
| tmux-sessionx | session 模糊搜索（基于 fzf） |
| tmux-resurrect | 会话持久化（含 nvim session 恢复） |
| tmux-continuum | 自动保存/恢复会话 |
| tmux-tokyo-night | Tokyo Night 主题（night 变体） |

### Neovim 联动

vim-tmux-navigator 需要 Neovim 侧也安装对应插件。配置位于：

```
nvim/.config/nvim/lua/plugins/vim-tmux-navigator.lua
```

使用 lazy-loading（仅在按 `C-h/j/k/l` 时加载），不影响启动速度。

## 日常使用场景

### 场景 1：从命令输出中快速提取文本

```
# 运行命令后看到一个文件路径或 commit hash
$ git log --oneline -5

# 按 prefix + Tab，模糊搜索，选中后 Tab 插入到命令行
```

### 场景 2：打开终端输出中的 URL

```
# 看到一个 URL（哪怕跨行了）
$ curl -v https://example.com

# 按 prefix + u，fzf 列出所有 URL，选择后自动打开浏览器
```

### 场景 3：多项目并行开发

```
# 每个项目一个 session
tmux new -s project-a
tmux new -s project-b

# prefix + o 模糊搜索切换 session
# prefix + Space 快速切回上一个 session
# 关闭终端后 tmux-continuum 自动恢复所有 session
```

### 场景 4：复制模式高效操作

```
# prefix + Enter 进入复制模式
# / 搜索关键词，n/N 跳转
# v 选择，y 复制
# 或者直接鼠标拖选，松开自动复制到系统剪贴板
```

### 场景 5：临时最大化某个 pane

```
# 正在多 pane 布局中工作，需要临时看全屏
# prefix + z 最大化当前 pane
# 看完后 prefix + z 还原
```

## 首次安装

```bash
# 1. stow 链接配置
cd ~/growth/dotfiles && stow tmux

# 2. 打开 tmux，tpm 会自动 bootstrap
tmux

# 3. 安装所有插件
# prefix + I
```

## 变更历史

- **2026-04-09**: 新增 extrakto（屏幕文本模糊提取）、tmux-fzf-url（URL 提取打开）、tmux-nerd-font-window-name（窗口图标）。allow-passthrough 升级为 all，display-panes-time 调整为 2000ms。修复 vim-tmux-navigator 覆盖 prefix+C-l 的问题。
- **2026-04-02**: 增强配置。添加 vim-tmux-navigator（无缝 pane 切换）、OSC 52 剪贴板、undercurl 支持、tmux-sessionx（session 模糊搜索）、last-session 快捷键、鼠标复制优化、pane resize 步长调整。
- **2026-04-02**: 全面重写。移除 oh-my-tmux 框架，改为自包含 tmux.conf。消除框架与主题的冲突，配置从 ~1200 行降到 ~110 行。
