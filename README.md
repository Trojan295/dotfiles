# Dotfiles

This repository contains dotfiles for my desktop configuration.

## Setup

- OS: **Pop!_OS**
- Terminal: **alacritty**
- Text editors: **vim**, **VSCodium**
- Fonts: **JetBrains Mono**

## Configuration

```
sudo apt install -y git zsh alacritty neovim fonts-powerline
chsh -s /bin/zsh

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

./scripts/jetbrains-fonts.sh

make apply
```

## Pulseaudio with JACK

1. Install JACK
    ```
    sudo apt install -y qjackctl pulseaudio-module-jack
    sudo usermod -aG audio "${USER}"
    ```

2. Configure QJackCtl:
    - **Setup -> Settings**: Select the correct interface and parameters.
    - **Setup -> Options -> Execute script after Startup**: `pacmd set-default-sink jack_out && pacmd set-default-source jack_in`
