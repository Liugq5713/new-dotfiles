# Alacritty 配置最佳实践审查

基于 `alacritty/.config/alacritty/alacritty.toml` 的审查。

---

## 强烈推荐（应尽快修复）

### 1. 主题内联定义 → 应使用 `import` 引用主题文件

你已经有 `themes/` 目录（148 个主题文件），其中就有 `tokyo_night_storm.toml`，但颜色配置是手动内联在 `alacritty.toml` 中的。这导致：
- 主题不可一键切换
- 手动维护颜色值容易出错
- themes 目录变成了无效负载

而且你当前内联的背景色 `#23283a` 和标准 tokyo_night_storm 的 `#24283b` 有微小差异（`3a` vs `3b`），不确定是有意为之还是手误。

**建议**：使用 `import` 引用主题文件，将颜色配置从主文件中移除：

```toml
# alacritty.toml 顶部
import = [
  "~/.config/alacritty/themes/themes/tokyo_night_storm.toml"
]

# 然后删除所有 [colors.*] 段
# 如果需要微调，在 import 之后覆盖单个值
[colors.primary]
background = '#23283a'  # 如果确实是有意调整
```

### 2. `TERM = "xterm-256color"` 可能导致 tmux 内颜色问题

在 alacritty 中设置 `TERM = "xterm-256color"` 是常见做法，但更准确的值是 `alacritty` 或 `xterm-256color`。关键是要和 tmux 的 `default-terminal` 配合：

- alacritty 内直接运行程序：`TERM=xterm-256color` 没问题
- 通过 tmux 运行：tmux 会覆盖 TERM 为自己的 `default-terminal` 值

**建议**：当前设置可以保留，但确保 tmux 中配置了 `set -g default-terminal "tmux-256color"` + `terminal-overrides` 以启用 true color。

---

## 比较推荐（显著提升体验）

### 3. 缺少窗口配置

没有设置窗口的 padding、opacity、startup_mode 等。默认 padding 为 0，文字紧贴窗口边缘。

```toml
[window]
padding = { x = 8, y = 4 }
dynamic_padding = true        # 动态调整保持文字居中
opacity = 0.95                # 微透明，可选
option_as_alt = "Both"        # macOS 上让 Option 键作为 Alt（vi 模式用户常需要）
```

**`option_as_alt`** 尤其重要 — 如果你在 nvim 中用了 Meta/Alt 键绑定（如 `<M-j>`），没有这个设置在 macOS 上 Alt 键会输入特殊字符而不是发送 escape sequence。

### 4. 缺少滚动缓冲区配置

默认 scrollback 行数为 10000，对于长时间构建日志可能不够。

```toml
[scrolling]
history = 50000
multiplier = 3  # 每次滚动的行数
```

### 5. 键盘绑定可精简

当前绑定：

```toml
[[keyboard.bindings]]
action = "ReceiveChar"
key = "Back"         # 这是默认行为，没必要显式声明

[[keyboard.bindings]]
action = "Paste"
key = "Paste"        # 同上

[[keyboard.bindings]]
action = "Copy"
key = "Copy"         # 同上
```

前三个绑定都是 alacritty 的默认行为，删除不影响功能。只保留有实际意义的绑定：

```toml
# 禁用 Cmd+T（防止误触新建标签页）
[[keyboard.bindings]]
key = "t"
mods = "Command"
action = "None"
```

### 6. 缺少 `live_config_reload`

```toml
[general]
live_config_reload = true  # 修改配置文件后自动重新加载
```

默认就是 true，但显式声明是文档化的好习惯，也方便调试时临时关闭。

---

## 推荐（锦上添花）

### 7. themes 目录体积过大

148 个主题文件但你只用 1 个。整个 themes 目录约 200+ KB，在 dotfiles 仓库中增加了不必要的体积和 git 历史。

**建议**：
- 方案 A：只保留你用的主题文件（如 `tokyo_night_storm.toml`），删除其余
- 方案 B：把 themes 加入 `.gitignore`，在 `install.sh` 中自动 clone
- 方案 C：恢复为 git submodule（保持完整但不占仓库空间）

### 8. 字体 fallback 配置

你只配置了 FiraCode Nerd Font，没有设置 fallback 字体。如果 Nerd Font 缺少某些字符（如 CJK 字符），会显示为方块。

```toml
# Alacritty 0.13+ 支持 fallback 字体列表（通过多个 font 段实现）
# 但当前版本需要靠系统字体 fallback
# 建议确认：FiraCode Nerd Font 是否已包含你常用的所有字符
```

### 9. 考虑添加 cursor 配置

```toml
[cursor]
style = { shape = "Beam", blinking = "On" }
vi_mode_style = { shape = "Block", blinking = "Off" }
blink_interval = 500
blink_timeout = 0  # 0 = 永不停止闪烁
```

这和 zsh vi 模式的光标形状配合使用效果更好。

### 10. `selection.semantic_escape_chars` 含多余空白

```toml
semantic_escape_chars = ",│`|:\"' ()[]{}<>    "
```

末尾有多个空格和制表符，不确定是有意为之。默认值是 `,│`|:\"' ()[]{}<>\t`，通常够用。
