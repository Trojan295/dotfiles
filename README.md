# Dotfiles

The repository contains dotfiles for my desktop configuration.

## Setup

- OS: Regolith (https://regolith-linux.org/)

## Configuration

1. Install zsh and git
```
sudo apt install -y git zsh
chsh -s /bin/zsh
```

2. Install zgen (https://github.com/tarjoilija/zgen)
```
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
```

3. Install alacritty
```
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt install -y alacritty
```

4. Install i3 indicators
```
sudo apt install i3xrocks-wifi i3xrocks-battery i3xrocks-cpu-usage i3xrocks-volume i3xrocks-time i3xrocks-memory
regolith-look refresh
```