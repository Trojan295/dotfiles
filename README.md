# Dotfiles

This repository contains dotfiles for my desktop configuration.

## Setup

- OS: **Pop!_OS**
- Terminal: **alacritty**
- Text editors: **vim**, **VSCodium**
- Fonts: **JetBrains Mono**

## Configuration

```
sudo apt-get install -y git zsh alacritty neovim fonts-powerline peco libsqlite3-dev
chsh -s /bin/zsh

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

./scripts/jetbrains-fonts.sh

make apply
```

## Pulseaudio with JACK

1. Add [KXStudio repository](https://kx.studio/Repositories)
2. Install and use `cadence`
   ```bash
   apt-get install -y cadence
   ```
