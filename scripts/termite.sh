#!/bin/bash

mkdir -p $HOME/customization
cd $HOME/customization

sudo apt install -y g++ libgtk-3-dev gtk-doc-tools gnutls-bin \
    valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev \
    libgirepository1.0-dev libxml2-utils gperf build-essential

git clone https://github.com/thestinger/vte-ng.git
cd vte-ng
./autogen.sh
make -j(nproc)
sudo make install

cd ..
git clone --recursive https://github.com/thestinger/termite.git
cd termite
make -j$(nproc)
sudo make install

sudo ldconfig
sudo mkdir -p /lib/terminfo/x
sudo ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite

