HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY

export ZSH_CACHE_DIR=/tmp

autoload bashcompinit && bashcompinit

# zplug
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zdharma/history-search-multi-word"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "mdumitru/git-aliases"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/debian", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# theme
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir pyenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MODE='awesome-fontconfig'

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
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="/usr/local/kubebuilder/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

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

# pyenv completion
if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# awsume completion
if which awsume > /dev/null; then
    alias awsume=". awsume"
    complete -C 'awsume-autocomplete' awsume
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/damian/Pobrane/google-cloud-sdk/path.zsh.inc' ]; then . '/home/damian/Pobrane/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/damian/Pobrane/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/damian/Pobrane/google-cloud-sdk/completion.zsh.inc'; fi
