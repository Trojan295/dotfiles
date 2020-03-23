HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY

source "${HOME}/.zgen/zgen.zsh"
autoload -U compinit && compinit

export ZSH_CACHE_DIR=/tmp

zgen load zsh-users/zsh-syntax-highlighting
zgen load zdharma/history-search-multi-word
zgen load bhilburn/powerlevel9k powerlevel9k
zgen load mdumitru/git-aliases
zgen load zsh-users/zsh-autosuggestions
zgen load ohmyzsh/ohmyzsh plugins/kubectl/kubectl.plugin.zsh
zgen load ohmyzsh/ohmyzsh plugins/debian/debian.plugin.zsh

zstyle ':completion:*' menu select

zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'


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

export PYTHONDONTWRITEBYTECODE=1
export TERM=xterm-256color

alias ls='ls --color'
alias clipboard='xclip -selection clipboard'


export VISUAL=vim
export EDITOR=$VISUAL
export GOROOT="/usr/lib/go-1.13"
export PATH="$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin:$PATH:$HOME/.cargo/bin"

#AWSume alias to source the AWSume script
alias awsume=". awsume"
fpath=(/usr/local/share/zsh/site-functions $fpath)

complete -C 'aws_completer' aws

