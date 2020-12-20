# Dotfiles

This repository contains dotfiles for my desktop configuration.

## Setup

- OS: **Pop!_OS**
- Terminal: **alacritty**
- Text editors: **vim**, **VSCodium**
- Fonts: **JetBrains Mono**

## Configuration

```
sudo apt install -y git zsh alacritty neovim
chsh -s /bin/zsh

git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

./scripts/jetbrains-fonts.sh

make apply
```

## Ubuntu Mainline Kernel Installer

Refer to [mainline](https://github.com/bkw777/mainline) for instructions, on how to update the Linux kernel version.
