# Zsh 配置最佳实践审查

基于 `zsh/.zshrc` 的逐项审查，按优先级分类。

---

## 强烈推荐（应尽快修复）

### 1. LANG 重复设置且互相矛盾

**现状**：第 9 行设置 `LANG=zh_CN.UTF-8`，第 179 行又覆盖为 `LANG=en_US.UTF-8`。最终生效的是 `en_US.UTF-8`，但前面的设置造成了误导。

**建议**：删除第 9 行，只保留一处。如果你希望终端输出英文（推荐，方便搜索报错信息），只留 `en_US.UTF-8`。

```bash
# 删除第 9 行: export LANG=zh_CN.UTF-8
# 保留第 179 行
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"  # 补充：确保所有 locale 一致
```

### 2. 硬编码的绝对路径 — 跨机器必挂

多处硬编码了 `/Users/liuguangqi/`，换机器后全部失效：

| 行号 | 内容 |
|------|------|
| 142 | `alias ss="code -n /Users/liuguangqi/growth/..."` |
| 173 | `export PNPM_HOME="/Users/liuguangqi/Library/pnpm"` |

**建议**：统一使用 `$HOME`：

```bash
alias ss="code -n $HOME/growth/juejin/front-end-debugger"
export PNPM_HOME="$HOME/Library/pnpm"
```

### 3. nvm 启动速度问题 — 每次开 shell 卡 200-500ms

nvm 是 zsh 启动最大的性能杀手。`load-nvmrc` 在每次 `cd` 时都调用 `nvm version` 和 `nvm_find_nvmrc`，很慢。

**建议**：改用 nvm 的懒加载模式，或者迁移到 [fnm](https://github.com/Schniz/fnm)（Rust 实现，启动 <5ms）：

```bash
# 方案 A：fnm 替代 nvm（推荐）
eval "$(fnm env --use-on-cd)"

# 方案 B：nvm 懒加载（不想换工具时的折中）
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true  # 需配合 zsh-nvm 插件
```

### 4. `gq` 和 `gsac` 别名 — 危险的盲提交

```bash
alias gq="git add .&& git commit -m 'feat: quick commit'&&git push"
alias gsac="git add . && git commit -m 'feat: sac run' && git push"
```

`git add .` + 固定 message + 直接 push，极易把不该提交的文件推上去（临时文件、.env、调试代码）。

**建议**：至少加 `git status` 确认步骤，或者用 `git add -p`：

```bash
alias gq="git add . && git status && echo '确认提交? (Ctrl+C 取消)' && read && git commit -m 'feat: quick commit' && git push"
```

### 5. P10k source 路径异常

```bash
source .oh-my-zsh/custom/themes/powerlevel10k  # 相对路径，依赖 cwd
```

这是一个相对路径，只有当 `cwd` 恰好是 `$HOME` 时才能工作。应该用绝对路径：

```bash
source "$ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"
```

不过实际上 `ZSH_THEME="powerlevel10k/powerlevel10k"` 已经让 oh-my-zsh 加载了主题，这行可能是多余的。检查删除后是否正常。

---

## 比较推荐（显著提升体验）

### 6. 历史记录配置缺失

未配置历史记录的去重、大小和共享。多个终端窗口的历史会互相覆盖。

```bash
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS  # 去除重复命令
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS    # 去除多余空格
setopt SHARE_HISTORY         # 多终端共享历史
setopt INC_APPEND_HISTORY    # 实时追加而非退出时写入
```

### 7. 大量注释模板噪音

第 29-106 行是 oh-my-zsh 的默认模板注释，从未启用。占了文件 1/3 的篇幅，影响阅读。

**建议**：删除所有 `# Uncomment the following line...` 模板注释，只保留你实际使用的配置。如需参考，看 oh-my-zsh 文档。

### 8. `autojump` → 考虑迁移到 `zoxide`

autojump 已停止维护（最后一次发布是 2018 年）。[zoxide](https://github.com/ajeetdsouza/zoxide) 是 Rust 实现的替代品，更快且活跃维护。

```bash
# 替换 autojump
eval "$(zoxide init zsh)"
# 用法: z foo  (等同于原来的 j foo)
```

### 9. fzf 配置可增强

当前 fzf 配置只有基础搜索，缺少 Ctrl+R 历史搜索和 Alt+C 目录跳转的增强绑定。

```bash
# 推荐补充
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --exclude node_modules --exclude .git"
# 如果使用 fzf 0.48+，改用新版集成
source <(fzf --zsh)  # 替代 [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

### 10. vi 模式的光标形状未配置

你开启了 `set -o vi`，但没有配置不同模式下的光标形状，很难分辨当前是 insert 还是 normal 模式。

```bash
# 在 vi 模式下切换光标形状
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]] || [[ $1 == 'block' ]]; then
    echo -ne '\e[2 q'  # block cursor for normal mode
  else
    echo -ne '\e[6 q'  # beam cursor for insert mode
  fi
}
zle -N zle-keymap-select
echo -ne '\e[6 q'  # 默认 beam cursor
```

---

## 推荐（锦上添花）

### 11. 文件结构拆分

234 行的单文件 `.zshrc` 已经偏长。建议按功能拆分：

```
zsh/
├── .zshrc            # 主入口，只做 source
├── .zsh/
│   ├── aliases.sh    # 所有别名
│   ├── functions.sh  # note() 等自定义函数
│   ├── exports.sh    # 环境变量
│   └── plugins.sh    # 插件配置
```

### 12. `alias ranger="joshuto"` 语义混淆

把 `ranger` 映射到 `joshuto` 会让肌肉记忆产生混乱，尤其在别人的机器上。建议直接用 `joshuto` 或简写 `j`。

### 13. 废弃别名清理

以下别名看起来是特定项目或旧习惯，考虑清理：

| 别名 | 疑问 |
|------|------|
| `tol` | 路径用了大写 `Growth`，和实际 `growth` 可能不一致 |
| `tohr` | 特定项目 ehr-core |
| `grush` | rush 相关，commit message 有拼写错误 `udpate` → `update` |
| `chcors` | Chrome CORS 调试，使用频率？ |
| `ss` | 硬编码路径，见上文 |

### 14. `bindkey '  ' autosuggest-accept` 空格接受建议

双空格接受自动建议可能导致误触，尤其在快速打字时。更常见的做法是用右箭头或 `Ctrl+Space`。
