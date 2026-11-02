# Homebrew — macOS default prefix; guarded so it's a no-op on other OSes
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# OrbStack (macOS-only Docker/VM integration)
if [[ -f "$HOME/.orbstack/shell/init.zsh" ]]; then
  source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
fi

# Rust toolchain (cargo) — login shells only
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# MacPorts remnant (installed on one device; guarded)
if [[ -d /opt/local/bin ]]; then
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi