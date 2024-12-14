## 表示名
PROMPT='%K{green}%n@%30<...<%~%k'

## alias
alias ll='ls -la'
alias history='history -100'

## zsh-completions setting
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
compinit -u

## completion option
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # 補完候補で、大文字・小文字を区別しないで補完出来るようにするが、大文字を入力した場合は区別する
zstyle ':completion:*' ignore-parents parent pwd ..    # ../ の後は今いるディレクトリを補間しない
zstyle ':completion:*:default' menu select=1           # 補間候補一覧上で移動できるように
zstyle ':completion:*:cd:*' ignore-parents parent pwd  # 補間候補にカレントディレクトリは含めない
