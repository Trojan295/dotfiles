#!/bin/bash

save() {
    if [ -z "$1" ]; then
        echo "Missing path to save"
        return 1
    fi

    echo "Saving $1"
    local dir=$(dirname $1)
    mkdir -p $dir
    cp -r "$HOME/$1" "$1"
}

for f in $(cat files); do
    save $f
done

