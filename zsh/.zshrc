# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export LANG=zh_CN.UTF-8

set -o vi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/bin/bun:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

ZSH_DISABLE_COMPFIX="true"


# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git web-search copypath autojump history-substring-search zsh-syntax-highlighting zsh-autosuggestions nvm)

source $ZSH/oh-my-zsh.sh

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey -v
bindkey '  ' autosuggest-accept
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ssh-dev='ssh liuguangqi@xxx'
alias go-mysql='mycli -h xxx -P 3306 -u root entrance'

alias tol="cd ~/Growth/Liugq5713.github.io"


alias vi="nvim"
alias vim="nvim"
alias vjs="vi $HOME/temp/test.js"
alias vred="vi $HOME/growth/wiki/docs/work/red/README.md"
alias vq="vi  $HOME/growth/wiki/docs/daily/quick.md"

alias tohr='cd ~/workspace/ehr-core'
alias fvi='nvim $(fzf)'
alias fgco='git branch --sort=-committerdate | fzf | xargs git checkout'
alias fcd='cd $(find * -type d | fzf)'

alias glmaster="git checkout master && git pull"
alias gq="git add .&& git commit -m 'feat: quick commit'&&git push"
alias gcommit="git add . && formula lint --fix -p && git add . && git commit -m"
alias gwiki="cd ../.. && gq"
alias gsac="git add . && git commit -m 'feat: sac run' && git push"
alias grush="git add . && git commit -m 'chore(all): rush udpate' && git push"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chcors="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-web-security --user-data-dir='~/temp/chrome'"
alias ss="code -n /Users/liuguangqi/growth/juejin/front-end-debugger"

alias pkgs='jq .scripts package.json'

alias r='source ranger'
alias ranger="joshuto"
alias pn="pnpm"

export VISUAL=nvim;
export EDITOR=nvim;


source .oh-my-zsh/custom/themes/powerlevel10k


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
#export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 


# pnpm
export PNPM_HOME="/Users/liuguangqi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export LANG="en_US.UTF-8" 

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# tmux 窗口名跟随当前目录（只显示 basename）
# 用 chpwd 而不是 precmd，因为只需要在目录切换时更新，避免每次按回车都触发
_tmux_rename_window_to_dir() {
  if [[ -n "$TMUX" ]]; then
    tmux rename-window "$(basename "$PWD")"
  fi
}
add-zsh-hook chpwd _tmux_rename_window_to_dir
# 初始化一次，确保新开窗口也生效
_tmux_rename_window_to_dir

# note [内容] → 记录到 Apple 备忘录，无参数时打开 vim 编辑
note() {
  local body tmpfile
  if [[ $# -eq 0 ]]; then
    tmpfile=$(mktemp) && ${EDITOR:-vim} "$tmpfile" && body=$(<"$tmpfile"); rm -f "$tmpfile"
    [[ -z "$body" ]] && { echo "已取消"; return 1; }
  else
    body="$*"
  fi
  body="${body//\"/\\\"}" && body="${body//$'\n'/<br>}"
  osascript -e "tell application \"Notes\" to make new note at folder \"Notes\" with properties {body:\"${body}\"}" >/dev/null && echo "已记录"
}
alias n=note
alias oc=codewiz

export GOOGLE_CLOUD_PROJECT="charged-mind-187506"
