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



# Core plugins (lazy)
zinit ice wait"1"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"1"
zinit light zsh-users/zsh-completions

# Fuzzy finder (high value)
zinit light junegunn/fzf
zinit light Aloxaf/fzf-tab

# Git + history
zinit light mdumitru/git-aliases
zinit light agkozak/zsh-z

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif command -v brew &>/dev/null; then
  FZF_SHARE="$(brew --prefix)/share/fzf"
  [[ -f "$FZF_SHARE/key-bindings.zsh" ]] && source "$FZF_SHARE/key-bindings.zsh"
fi

# Optional: modern history

# OMZ snippets
zinit snippet OMZP::dotenv
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

add_path_if_exists "/usr/local/go/bin"
add_path_if_exists "$HOME/go/bin"
add_path_if_exists "$HOME/.local/bin"
add_path_if_exists "/home/linuxbrew/.linuxbrew/bin"
add_path_if_exists "$HOME/Development/flutter/bin"
add_path_if_exists "$HOME/.pub-cache/bin"
add_path_if_exists "$HOME/.mix/escripts"
add_path_if_exists "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
else
  export ANDROID_HOME="$HOME/Android/Sdk"
fi
add_path_if_exists "$ANDROID_HOME/platform-tools"

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

alias ls='eza --icons'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'


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
  if [[ ! -f "$cache" ]] || [[ "$bin" -nt "$cache" ]] || [[ -n $(find "$cache" -mtime +30 2>/dev/null) ]]; then
    "$cmd" "$@" > "$cache" 2>/dev/null
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

if [[ -n "$ZELLIJ" ]]; then
  _zj_tab_preexec() {
    local cmd="${3:-$1}"
    cmd="${cmd[(w)0]}"
    [[ -n "$cmd" ]] && zellij action rename-tab "$cmd"
  }
  _zj_tab_precmd() {
    zellij action rename-tab "zsh"
  }
  add-zsh-hook preexec _zj_tab_preexec
  add-zsh-hook precmd _zj_tab_precmd
fi

if command -v zellij &> /dev/null && [ -n "$PS1" ] && [ -z "$ZELLIJ" ]; then
  zellij
fi


## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f "$HOME/.config/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.config/.dart-cli-completion/zsh-config.zsh"
## [/Completion]


# opencode
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
