#!/bin/bash

install() {
    if [ -z "$1" ]; then
        echo "Missing path to install"
        return 1
    fi

    echo "Installing $1"
    local dir=$(dirname $1)
    mkdir -p $HOME/$dir
    cp -r "$1" "$HOME/$1"
}

for f in $(cat files); do
    install $f
done

