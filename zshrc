export ZSH=/home/damian/.oh-my-zsh

TERM="xterm-256color"

ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_folders

POWERLEVEL9K_PROMPT_ON_NEWLINE=true

plugin=(
  debian docker git kubectl lol systemd ssh-agent zsh-navigation-tools
)

source $ZSH/oh-my-zsh.sh
export GNUPGHOME=~/.gnupg/trezor

