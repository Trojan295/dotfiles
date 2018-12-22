#!/bin/bash -e

function install_i3 {
    sudo apt install -y libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb \
        libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev \
        libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev \
        libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0-dev

    if [ ! -d i3-gaps ]; then
        git clone https://www.github.com/Airblader/i3 i3-gaps
    fi

    cd i3-gaps
    git checkout gaps
    git pull origin gaps

    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/

    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install
}

function install_polybar {
    sudo apt -y install cmake libpulse-dev libnl-genl-3-dev libxcb-ewmh-dev python-xcbgen xcb-proto

    if [ ! -d polybar ]; then
        git clone --branch 3.2 --recursive https://github.com/jaagr/polybar
    fi

    rm -rf polybar/build
    mkdir -p polybar/build
    cd polybar/build
    cmake ..
    make
    sudo make install
}

function install_firefox {
    echo "deb http://http.debian.net/debian unstable main" | sudo tee /etc/apt/sources.list.d/unstable.list
    echo | sudo tee /etc/apt/preferences << EOF
Package: *
Pin: release a=unstable
Pin-Priority: 1
EOF
    sudo apt update
    sudo apt install -y -t sid firefox
}

function install_alacritty {
    if [ ! -f "$HOME/.cargo/bin/cargo" ]; then
        curl https://sh.rustup.rs -sSf | sh
    fi

    source $HOME/.cargo/env
    rustup override set stable
    rustup update stable

    sudo apt install -y cmake libfontconfig1-dev xclip

    if [ ! -d alacritty ]; then
        git clone https://github.com/jwilm/alacritty.git
    fi

    cd alacritty
    git checkout v0.2.4
    git pull origin v0.2.4

    cargo install cargo-deb --force
    cargo deb --install
}

function install_custom_stuff {
    sudo apt install -y vim zsh git fonts-hack fonts-roboto compton redshift dmenu \
        papirus-icon-theme fonts-font-awesome dconf-cli nitrogen
    
    if [ ! -d "$HOME/.zgen" ]; then
        git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
    fi
    cd $HOME/.zgen
    git pull origin master

    chsh -s /bin/zsh
}

sudo apt install -y git autoconf curl

mkdir -p "$HOME/customization"
cd "$HOME/customization"
install_i3

cd "$HOME/customization"
install_polybar

cd "$HOME/customization"
install_alacritty

install_firefox
install_custom_stuff

