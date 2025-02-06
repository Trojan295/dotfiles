# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
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
zinit light romkatv/powerlevel10k

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
