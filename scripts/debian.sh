#!/bin/bash
set -e

function install_dependencies {
    sudo sudo apt-get install -y git curl unzip cmake autoconf
}

function install_mate {
    sudo apt-get install -y task-mate-desktop
}

function install_i3 {
    sudo apt-get install -y slim
    sudo apt-get install -y i3 suckless-tools
    sudo apt-get install -y libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev
    mkdir -p ~/rice/
    pushd ~/rice

    rm -rf i3-gaps
    git clone https://www.github.com/Airblader/i3 i3-gaps
    pushd i3-gaps

    autoreconf --force --install
    rm -rf build/
    mkdir -p build
    pushd build

    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install

    popd
    popd
    popd
}

function install_alacritty {
    sudo apt-get install -y cmake libfreetype6-dev libfontconfig1-dev xclip
    curl https://sh.rustup.rs -sSf | sh
    source ~/.cargo/env
    rustup override set stable
    rustup update stable

    pushd ~/rice

    rm -rf alacritty
    git clone https://github.com/jwilm/alacritty.git
    pushd alacritty
    cargo build --release

    sudo cp target/release/alacritty /usr/local/bin
    sudo desktop-file-install alacritty.desktop
    sudo update-desktop-database
    sudo mkdir -p /usr/share/zsh/functions/Completion/X
    sudo cp alacritty-completions.zsh /usr/share/zsh/functions/Completion/X/_alacritty

    popd
    popd
}

function install_other {
    sudo apt-get install -y compton vim zsh
    chsh -s $(which zsh)
}

#install_dependencies
#install_mate
#install_i3
#install_alacritty
install_other

