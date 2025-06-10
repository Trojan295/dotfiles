#!/bin/bash

install() {
    if [ -z "$1" ]; then
        echo "Missing path to install"
        return 1
    fi

    local src="home-configs/$1"
    local dst="$HOME/$1"

    # Check if source exists
    if [ ! -e "$src" ]; then
        echo "Error: Source $src does not exist"
        return 1
    fi

    echo "Installing $1"
    
    # Create parent directory
    mkdir -p "$(dirname "$dst")"
    
    # Create backup if destination exists
    if [ -e "$dst" ]; then
        echo "Creating backup of $dst"
        mv "$dst" "${dst}.backup.$(date +%Y%m%d%H%M%S)"
    fi

    # Copy files properly handling both directories and files
    if [ -d "$src" ]; then
        cp -r "$src/." "$dst/"
    else
        cp "$src" "$dst"
    fi

    if [ $? -eq 0 ]; then
        echo "Successfully installed $1"
    else
        echo "Failed to install $1"
        return 1
    fi
}

read -p "Are you sure you want to apply configs? This will overwrite existing files. (y/n)? " choice
case "$choice" in
  y|Y ) ;;
  n|N ) echo "Operation cancelled"; exit 1;;
  * ) echo "Invalid response"; exit 1;;
esac

echo "Installing dotfiles..."

for f in $(cat files); do
    install "$f" || echo "Warning: Failed to install $f"
done

echo "Done"
