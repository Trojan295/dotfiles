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

    if [ -d "$src" ]; then
        cp -r "$src" "$(dirname $dst)"
    else
        cp -r "$src" "$dst"
    fi
}

echo "Saving dotfiles..."

for f in $(cat files); do
    save $f
done

echo "Done"

