#!/bin/bash

save() {
    if [ -z "$1" ]; then
        echo "Missing path to save"
        return 1
    fi

    echo "Saving $1"

    local src="$HOME/$1"
    local dst="home-configs/${1}"

    mkdir -p $(dirname $dst)
    cp -r "$src" "$dst"
}

echo "Saving dotfiles..."

for f in $(cat files); do
    save $f
done

echo "Done"

