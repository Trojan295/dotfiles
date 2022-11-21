# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY

. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-completions
zinit load zsh-users/zsh-syntax-highlighting
zinit load jimeh/zsh-peco-history
zinit load mdumitru/git-aliases
zinit load johnhamelink/env-zsh
zinit snippet OMZP::debian
zinit snippet OMZP::kubectl

autoload -Uz compinit bashcompinit
compinit
bashcompinit

zinit cdreplay -q

### End of Zinit's installer chunk

bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

alias ls='ls -G'
alias clipboard='xclip -selection clipboard'
alias rm='trash'

# execute after changing PWD
function chpwd() {
    emulate -L zsh
    ls
}

# system env variables
export PYTHONDONTWRITEBYTECODE=1
export TERM=xterm-256color
export VISUAL=vim
export EDITOR=$VISUAL

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/kubebuilder/bin:$PATH"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

export PATH=$PATH:$HOME/.pulumi/bin

# shell completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# helm complation
if which helm > /dev/null; then
    source <(helm completion zsh)
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

# awscli
if which aws > /dev/null; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

# awsume completion
if which awsume > /dev/null; then
    alias awsume=". awsume"
fi

# Scaleway CLI autocomplete initialization.
if which scw > /dev/null; then
    eval "$(scw autocomplete script shell=zsh | tail +2)"
fi
#
## Flux autocompletion
if which flux > /dev/null; then
    . <(flux completion zsh)
fi

## Azure CLI completion
if which az > /dev/null; then
    . /etc/bash_completion.d/azure-cli
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
