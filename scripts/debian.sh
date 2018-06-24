#!/bin/bash
set -e

function install_dependencies {
  sudo sudo apt-get install -y git curl unzip cmake autoconf slim
}

function install_mate {
  sudo apt-get install -y task-mate-desktop
}

function install_i3 {
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

function install_polybar {
  sudo apt-get install -y cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev
  pushd ~/rice
  git clone --branch 3.1.0 --recursive https://github.com/jaagr/polybar.git
  pushd polybar
  (cd lib/xpp; git checkout master)
  mkdir build
  pushd build
  cmake ..
  sudo make install
  popd
  popd
  popd
}

function install_other {
  sudo apt-get install -y compton vim zsh redshift
  chsh -s $(which zsh)
}

install_dependencies
install_mate
install_i3
install_alacritty
install_polybar
install_other

