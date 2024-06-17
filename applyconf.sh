#!/bin/bash

install() {
    if [ -z "$1" ]; then
        echo "Missing path to install"
        return 1
    fi

    echo "Installing $1"

    local src="home-configs/$1"
    local dst="$HOME/${1}"

    mkdir -p $(dirname $dst)
    cp -r "$src" "$dst"
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

echo "Done"

