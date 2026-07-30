#!/bin/bash
set -euo pipefail

echo "Setting up macOS dotfiles..."

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
    starship \
    ghostty

echo "Done. Run ./applyconf.sh to deploy configs."
