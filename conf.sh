#!/bin/bash

install() {
    if [ -z "$1" ]; then
        echo "Missing path to install"
        return 1
    fi

    echo "Installing $1"

    local src="$1"

    local dst="$HOME/$1"
    local dst_dir=$(dirname $dst)
    if [ -d "$src" ]; then
        dst=$dst_dir
    fi

    mkdir -p $dst_dir
    cp -r "$src" "$dst"
}

install_dconf_settings() {
    echo "Loading dconf settings"
    dconf load / < dconf-settings.ini
}

read -p "Are you sure? (y/n)? " choice
case "$choice" in
  y|Y ) ;;
  n|N ) exit 1;;
  * ) exit 1;;
esac

echo "Installing dotfiles..."

for f in $(cat files); do
    install $f
done
install_dconf_settings

echo "Done"

