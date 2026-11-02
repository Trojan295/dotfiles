export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE
export EDITOR=nvim

# Per-device profile, read from the machine-local marker (created by applyconf.sh).
# 'core' = Go + cloud/k8s only; 'full' = adds other language tooling (flutter, Android, Dart, Elixir...).
# A pre-set DOTFILES_PROFILE env wins (e.g. one-off `DOTFILES_PROFILE=full zsh`); otherwise read the marker.
DOTFILES_PROFILE="${DOTFILES_PROFILE:-${$(<"$HOME/.config/dotfiles/profile" 2>/dev/null):-core}}"
export DOTFILES_PROFILE

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

# Core plugins (lazy)
zinit ice wait"1"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"1"
zinit light zsh-users/zsh-completions

# Fuzzy finder (high value)
zinit light junegunn/fzf
zinit light Aloxaf/fzf-tab

# Git aliases
zinit light mdumitru/git-aliases

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif command -v brew &>/dev/null; then
  FZF_SHARE="$(brew --prefix)/share/fzf"
  [[ -f "$FZF_SHARE/key-bindings.zsh" ]] && source "$FZF_SHARE/key-bindings.zsh"
fi

# OMZ snippets
zinit snippet OMZP::kubectl

command -v brew &>/dev/null && zinit snippet OMZP::brew
command -v apt &>/dev/null && zinit snippet OMZP::debian

# ALWAYS LAST
# Defer syntax highlighting until after the first prompt is rendered.
# Using wait"1" instead of wait"0" avoids the "$region_highlight is not defined"
# race where _zsh_highlight runs before ZLE init. atload is removed — the plugin
# hooks itself into ZLE via its own widgets when sourced.
zinit ice wait"1" lucid
zinit light zsh-users/zsh-syntax-highlighting

# Go + cloud/k8s tooling — all profiles
add_path_if_exists "/usr/local/go/bin"
add_path_if_exists "$HOME/go/bin"
add_path_if_exists "$HOME/.local/bin"
add_path_if_exists "/home/linuxbrew/.linuxbrew/bin"

# Extra language tooling — 'full' profile only
if [[ "$DOTFILES_PROFILE" == "full" ]]; then
  add_path_if_exists "$HOME/Development/flutter/bin"
  add_path_if_exists "$HOME/.pub-cache/bin"
  add_path_if_exists "$HOME/.mix/escripts"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
  else
    export ANDROID_HOME="$HOME/Android/Sdk"
  fi
  add_path_if_exists "$ANDROID_HOME/platform-tools"
fi

# Deduplicate PATH (keep first occurrence of each entry)
typeset -U path PATH

# Run compinit's full security check at most once per day; otherwise use the cached dump.
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit cdreplay -q

eval "$(zoxide init zsh --cmd cd)"

command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# direnv — replaces the OMZ dotenv plugin, which source()s .env files as shell code.
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

PURE_GIT_PULL=0
PURE_CMD_MAX_EXEC_TIME=5
PURE_PROMPT_SYMBOL='❯'

zstyle ':prompt:pure:path'        color '#7E9CD8'
zstyle ':prompt:pure:git:branch'  color '#54546D'
zstyle ':prompt:pure:git:dirty'   color '#E6C384'
zstyle ':prompt:pure:git:arrow'   color '#7AA89F'
zstyle ':prompt:pure:git:stash'   color '#E6C384'
zstyle ':prompt:pure:git:action'  show   yes
zstyle ':prompt:pure:git:stash'   show   yes
zstyle ':prompt:pure:prompt:success' color '#E6C384'
zstyle ':prompt:pure:prompt:error'   color '#D27E99'
zstyle ':prompt:pure:execution_time' color '#54546D'

alias ls='eza --icons auto'
alias ll='eza -l --icons auto --git'
alias la='eza -la --icons auto --git'


zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# bashcompinit is only needed for aws_completer — load it lazily.
if command -v aws_completer &>/dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C "$(command -v aws_completer)" aws
fi

# Cache CLI completions to disk to avoid spawning subprocesses on every shell startup.
# Invalidates when the binary's mtime changes (e.g. brew upgrade) or after 30 days as a safety net.
_cache_completion() {
  local cmd="$1"; shift
  local cache="$HOME/.zsh_completion_cache/_${cmd}"
  local bin
  bin=$(command -v "$cmd") || return
  mkdir -p "$HOME/.zsh_completion_cache"
  # Regenerate if cache is missing, the binary is newer than the cache, or the cache is >30 days old.
  if [[ ! -f "$cache" ]] || [[ "$bin" -nt "$cache" ]]; then
    "$cmd" "$@" > "$cache" 2>/dev/null
  else
    local age
    if [[ "$OSTYPE" == darwin* ]]; then
      age=$(( $(date +%s) - $(stat -f %m "$cache") ))
    else
      age=$(( $(date +%s) - $(stat -c %Y "$cache") ))
    fi
    (( age > 2592000 )) && "$cmd" "$@" > "$cache" 2>/dev/null
  fi
  [[ -s "$cache" ]] && source "$cache"
}

# Manual refresh escape hatch: run `zsh-refresh-completions` to clear the cache.
zsh-refresh-completions() {
  rm -rf "$HOME/.zsh_completion_cache"
  echo "Completion cache cleared. Restart your shell or re-source ~/.zshrc."
}

command -v kubectl  &>/dev/null && _cache_completion kubectl  completion zsh
command -v helm     &>/dev/null && _cache_completion helm     completion zsh
command -v kind     &>/dev/null && _cache_completion kind     completion zsh
command -v castctl  &>/dev/null && _cache_completion castctl  completion zsh
command -v skaffold &>/dev/null && _cache_completion skaffold completion zsh

# Lazy-load fnm — only initialize when node/npm/npx/yarn/pnpm is first invoked.
# Also fixes a bug where the Linux path /home/damian/... was hardcoded on macOS.
FNM_PATH="${HOME}/.local/share/fnm"
if [[ -d "$FNM_PATH" ]]; then
  export PATH="$FNM_PATH:$PATH"
  _fnm_lazy_init() {
    unset -f node npm npx yarn pnpm 2>/dev/null
    eval "$(fnm env --use-on-cd)"
  }
  for _cmd in node npm npx yarn pnpm; do
    eval "${_cmd}() { _fnm_lazy_init; ${_cmd} \"\$@\"; }"
  done
  unset _cmd
fi

# Dart CLI completions — 'full' profile only
if [[ "$DOTFILES_PROFILE" == "full" ]] && [[ -f "$HOME/.config/.dart-cli-completion/zsh-config.zsh" ]]; then
  source "$HOME/.config/.dart-cli-completion/zsh-config.zsh"
fi

# opencode
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"

# Machine-local overrides and secrets — keep this file out of the dotfiles repo.
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi