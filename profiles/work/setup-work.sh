#!/bin/bash
set -euo pipefail

# Work profile installer (macOS) — brew packages. Run from the repo root:
#   ./profiles/work/setup-work.sh

echo "Setting up work profile (macOS)..."

if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Install from https://brew.sh"
    exit 1
fi

echo "Installing packages..."
brew install \
    zsh \
    fzf \
    neovim \
    zoxide \
    git \
    git-delta \
    git-lfs \
    curl \
    direnv \
    wget \
    go \
    kubectl \
    kubectx \
    helm \
    fnm \
    font-jetbrains-mono-nerd-font \
    atuin \
    eza \
    lazygit \
    ghostty

echo "Done. Run ./applyconf.sh to deploy configs."
