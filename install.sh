#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES=(nvim tmux alacritty zsh codewiz)

info() { printf "\033[34m[INFO]\033[0m %s\n" "$1"; }
warn() { printf "\033[33m[WARN]\033[0m %s\n" "$1"; }
error() { printf "\033[31m[ERROR]\033[0m %s\n" "$1"; }

# 检查并安装 stow
if ! command -v stow &>/dev/null; then
    info "GNU Stow not found, installing..."
    if command -v brew &>/dev/null; then
        brew install stow
    elif command -v apt-get &>/dev/null; then
        sudo apt-get install -y stow
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm stow
    else
        error "Cannot install stow: no supported package manager found."
        error "Please install GNU Stow manually and re-run this script."
        exit 1
    fi
fi

info "Using dotfiles directory: $DOTFILES_DIR"
info "Target: $HOME"
echo ""

# 安装 alacritty 主题（在 .gitignore 中排除，需要单独 clone）
ALACRITTY_THEMES_DIR="$DOTFILES_DIR/alacritty/.config/alacritty/themes"
if [ ! -d "$ALACRITTY_THEMES_DIR" ]; then
    info "Cloning alacritty themes..."
    git clone --depth 1 https://github.com/alacritty/alacritty-theme.git "$ALACRITTY_THEMES_DIR"
else
    info "Alacritty themes already exist, skipping."
fi

# 逐个包执行 stow
for pkg in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        info "Stowing $pkg..."
        # --adopt: 如果目标位置已有文件，先吸收到 dotfiles 再链接
        # 这样不会因为目标已存在而报错
        # 使用后记得 git diff 检查是否有不期望的覆盖
        stow -v -t "$HOME" -d "$DOTFILES_DIR" "$pkg" 2>&1 || {
            warn "$pkg: target files already exist, trying with --adopt..."
            stow -v --adopt -t "$HOME" -d "$DOTFILES_DIR" "$pkg"
            warn "$pkg: adopted existing files. Run 'git diff' to check for unexpected changes."
        }
    else
        warn "Package '$pkg' directory not found, skipping."
    fi
done

echo ""
info "Done! All dotfiles have been stowed."
info "To unstow a package: stow -D -t \$HOME -d $DOTFILES_DIR <package>"
info "To restow a package:  stow -R -t \$HOME -d $DOTFILES_DIR <package>"
