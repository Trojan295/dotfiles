#!/bin/bash

save() {
    if [ -z "$1" ]; then
        echo "Missing path to save"
        return 1
    fi

    local src="$HOME/$1"
    local dst="home-configs/$1"

    # Check if source exists
    if [ ! -e "$src" ]; then
        echo "Error: Source $src does not exist"
        return 1
    }

    echo "Saving $1"
    
    # Create parent directory
    mkdir -p "$(dirname "$dst")"

    # Copy files properly handling both directories and files
    if [ -d "$src" ]; then
        if [ ! -d "$dst" ]; then
            mkdir -p "$dst"
        fi
        cp -r "$src/." "$dst/"
    else
        cp "$src" "$dst"
    fi

    if [ $? -eq 0 ]; then
        echo "Successfully saved $1"
    else
        echo "Failed to save $1"
        return 1
    fi
}

read -p "Are you sure you want to save configs? This will overwrite files in the repo. (y/n)? " choice
case "$choice" in
  y|Y ) ;;
  n|N ) echo "Operation cancelled"; exit 1;;
  * ) echo "Invalid response"; exit 1;;
esac

echo "Saving dotfiles..."

for f in $(cat files); do
    save "$f" || echo "Warning: Failed to save $f"
done

echo "Done"
