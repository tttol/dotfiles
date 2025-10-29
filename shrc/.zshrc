# prompt
PROMPT='%K{#00820d}%n@%30<...<%~%k'

# oh my zsh!
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=''
plugins=(
    git
    zsh-autosuggestions
    aliases
)

source $ZSH/oh-my-zsh.sh

# alias
# ※Oh My Zshの後にaliasを書かないと反映されない
alias ll='ls -la'
alias history='history -100'
alias sync-fork="~/Documents/workspace/sync-fork.sh"
alias nv='nvim'
mkfile() { mkdir -p "$(dirname "$1")" && touch "$1"; }

# zsh-completions setting
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
compinit -u

# completion option
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # 補完候補で、大文字・小文字を区別しないで補完出来るようにするが、大文字を入力した場合は区別する
zstyle ':completion:*' ignore-parents parent pwd ..    # ../ の後は今いるディレクトリを補間しない
zstyle ':completion:*:default' menu select=1           # 補間候補一覧上で移動できるように
zstyle ':completion:*:cd:*' ignore-parents parent pwd  # 補間候補にカレントディレクトリは含めない

. "$HOME/.local/bin/env"

# PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home
export SPRING_PROFILES_ACTIVE=local
export PATH="$PATH:$HOME/.cargo/bin"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# starship
eval "$(starship init zsh)"

# bun completions
[ -s "/Users/tttol/.bun/_bun" ] && source "/Users/tttol/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

