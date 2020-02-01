#!/bin/bash

git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

sudo apt install rofi zsh

NEW_SHELL="/bin/zsh"
echo "Change shell to $NEW_SHELL"
chsh -s $NEW_SHELL

