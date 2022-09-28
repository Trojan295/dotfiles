# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY

autoload bashcompinit && bashcompinit

# zplug
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "zsh-users/zsh-syntax-highlighting"
zplug "jimeh/zsh-peco-history", defer:2
zplug "mdumitru/git-aliases"
zplug "plugins/debian", from:oh-my-zsh
zplug "plugins/asdf", from:oh-my-zsh
zplug "johnhamelink/env-zsh"
zplug "plugins/kubectl", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

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

