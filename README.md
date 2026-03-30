# Dotfiles

使用 [GNU Stow](https://www.gnu.org/software/stow/) 管理的个人配置文件。通过符号链接将本仓库中的配置映射到 `$HOME` 对应位置，修改仓库中的文件即可立即生效。

## 目录结构

```
dotfiles/
├── install.sh                        # 一键部署脚本
├── nvim/.config/nvim/                 # → ~/.config/nvim
├── tmux/.config/tmux/                 # → ~/.config/tmux
├── alacritty/.config/alacritty/       # → ~/.config/alacritty
└── zsh/.zshrc                         # → ~/.zshrc
```

每个顶级目录是一个 Stow "包"，内部结构镜像 `$HOME`。

## 新机器部署

```bash
git clone <your-repo-url> ~/growth/dotfiles
cd ~/growth/dotfiles
./install.sh
```

## 日常管理

所有 stow 命令都需要在 `~/growth/dotfiles` 目录下执行：

```bash
cd ~/growth/dotfiles
```

### 修改配置

直接编辑本仓库中的文件即可，符号链接确保改动立即生效：

```bash
vim nvim/.config/nvim/init.lua    # 等同于编辑 ~/.config/nvim/init.lua
vim zsh/.zshrc                     # 等同于编辑 ~/.zshrc
```

### 新增一个配置包

以 kitty 为例：

```bash
# 1. 创建包目录（镜像 $HOME 下的路径结构）
mkdir -p kitty/.config/kitty

# 2. 将现有配置移入
mv ~/.config/kitty/kitty.conf kitty/.config/kitty/

# 3. 创建符号链接
stow -t $HOME kitty

# 4. 提交
git add kitty && git commit -m "add kitty config"
```

对于直接放在 `$HOME` 下的配置文件（如 `.bashrc`）：

```bash
mkdir -p bash
mv ~/.bashrc bash/.bashrc
stow -t $HOME bash
```

### 移除一个配置包

```bash
# 删除符号链接（不会删除仓库中的文件）
stow -D -t $HOME <package>

# 例：暂时禁用 alacritty 配置
stow -D -t $HOME alacritty
```

### 重新链接（修改了包的目录结构后）

```bash
stow -R -t $HOME <package>
```

### 一次操作所有包

```bash
# 链接所有
stow -t $HOME */

# 取消所有
stow -D -t $HOME */
```

## 注意事项

- **目标位置必须为空**：stow 在创建链接前，目标位置不能已有同名文件/目录，否则会报冲突。用 `--adopt` 可以先吸收现有文件再链接，但之后务必 `git diff` 检查。
- **tmux 插件**：`tmux/.config/tmux/plugins/` 已在 `.gitignore` 中排除，插件由 tpm 在运行时安装（`prefix + I`）。
- **nvim 插件**：由 lazy.nvim 管理，首次打开 nvim 会自动安装。
