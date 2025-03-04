export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
export EDITOR=nvim

add_path_if_exists() {
  [[ -d "$1" ]] && export PATH="$PATH:$1"
}

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zinit ice depth"1"
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-completions
zinit load zsh-users/zsh-syntax-highlighting
zinit load jimeh/zsh-peco-history
zinit load mdumitru/git-aliases
zinit snippet OMZP::dotenv
zinit snippet OMZP::kubectl
zinit snippet OMZP::debian
[[ "$(uname -o)" == "Darwin" ]] && zinit snippet OMZP::brew

add_path_if_exists "/opt/nvim-linux64/bin"
add_path_if_exists "/usr/local/go/bin"
add_path_if_exists "$HOME/go/bin"
add_path_if_exists "$HOME/.local/bin"

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

zinit cdreplay -q

eval "$(zoxide init zsh --cmd cd)"
source <(fzf --zsh)

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# Pyenv
if which pyenv 2>&1 > /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  add_path_if_exists "$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# AWS
which aws_completer 2>&1 > /dev/null && complete -C '/usr/local/bin/aws_completer' aws

if which skaffold 2>&1 > /dev/null; then
  source <(skaffold completion zsh)
fi

if which kubectl 2>&1 > /dev/null; then
  source <(kubectl completion zsh)
fi

if which helm 2>&1 > /dev/null; then
  source <(helm completion zsh)
fi

if which kind 2>&1 > /dev/null; then
  source <(kind completion zsh)
fi

