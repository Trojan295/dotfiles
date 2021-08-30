# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY

export ZSH_CACHE_DIR=/tmp

autoload bashcompinit && bashcompinit

# zplug
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "jimeh/zsh-peco-history", defer:2
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "mdumitru/git-aliases"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/debian", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# execute after changing PWD
function chpwd() {
    emulate -L zsh
    ls --color
}

alias ls='ls --color'
alias clipboard='xclip -selection clipboard'

# system env variables
export PYTHONDONTWRITEBYTECODE=1
export TERM=xterm-256color
export VISUAL=vim
export EDITOR=$VISUAL

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/kubebuilder/bin:$PATH"

export GOPATH="$HOME/go"

# shell completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# aws-cli completion
if which aws > /dev/null ; then
    complete -C 'aws_completer' aws
fi

# kubectl complation
if which kubectl > /dev/null; then
    source <(kubectl completion zsh)
fi

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

# awsume completion
if which awsume > /dev/null; then
    alias awsume=". awsume"
    complete -C 'awsume-autocomplete' awsume
fi

# Scaleway CLI autocomplete initialization.
if which scw > /dev/null; then
    eval "$(scw autocomplete script shell=zsh)"
fi

