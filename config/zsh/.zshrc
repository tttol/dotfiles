########################################################
# ZINIT
########################################################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# install zinit if not exist
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

########################################################
# ALIAS
########################################################

alias sync-fork="~/Documents/workspace/sync-fork.sh"
alias nv='nvim'
mkfile() { mkdir -p "$(dirname "$1")" && touch "$1"; }
alias ll='eza --icons -al'
alias lg='lazygit'
alias history='eval "$(fc -l -n 1  | fzf)"'

########################################################
# COMPLETION
########################################################

# zsh-completions setting
# Lazy load compinit with zinit
zinit ice wait lucid atload'
autoload -Uz compinit && compinit -C
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"
zstyle ":completion:*" ignore-parents parent pwd ..
zstyle ":completion:*:default" menu select=1
zstyle ":completion:*:cd:*" ignore-parents parent pwd
'
zinit light zdharma-continuum/null

. "$HOME/.local/bin/env"

# zsh-autosuggestions (lazy load after prompt)
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
########################################################
# FUZZY FIND
########################################################
unalias nvf 2>/dev/null
nvf() {
    local dir
    cd
    dir=$(fzf)
    [ -n "$dir" ] && nvim "$dir"
}

nvd() {
    local dir
    cd
    dir=$(fd | fzf \
        --preview 'eza --tree --level=2 --icons --git {} 2>/dev/null || tree -L 2 {} 2>/dev/null || ls -la {}' \
        --preview-window=right:60%)
    [ -n "$dir" ] && cd "$dir" && nvim .
}

########################################################
# KEYBIND
########################################################
bindkey -v

function zle-keymap-select zle-line-init {
    case $KEYMAP in
        vicmd)
            # block cursor
            echo -ne '\e[1 q'
            ;;
        viins|main)
            # line cursor
            echo -ne '\e[5 q'
            ;;
    esac

    # show current mode(NORMAL)
    VIM_PROMPT="%{$fg_bold[yellow]%} [NORMAL]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

# コマンド実行前にビームカーソルに戻す
preexec() {
    echo -ne '\e[5 q'
}

########################################################
# LOCAL SETTINGS
########################################################

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

########################################################
# TOOL
########################################################

# starship
eval "$(starship init zsh)"

# bun completions
[ -s "/Users/tttol/.bun/_bun" ] && source "/Users/tttol/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# zoxide
eval "$(zoxide init zsh)"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude .claude --exclude .cache --exclude node_modules --exclude .venv --exclude .next --exclude .local/share --exclude .local/state --exclude Library --exclude .vscode --exclude .cursor --exclude Movies'
