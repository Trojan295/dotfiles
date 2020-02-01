#!/bin/bash

mkdir -p $HOME/customization
cd $HOME/customization

git clone https://github.com/powerline/fonts.git --depth=1 powerline-fonts
cd powerline-fonts

./install.sh
