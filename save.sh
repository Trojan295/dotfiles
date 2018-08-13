#!/bin/bash

save() {
    if [ -z "$1" ]; then
        echo "Missing path to save"
        return 1
    fi

    #echo "Saving $1"

    local src="$HOME/$1"
    local dst_dir=$(dirname $1)

    local dst=$1
    if [ -d "$src" ]; then
        dst=$dst_dir
    fi

    mkdir -p $dst_dir
    cp -r $src $dst
}

for f in $(cat files); do
    save $f
done

