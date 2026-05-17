#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

detect_os() {
  case "$(uname -s)" in
    Linux)  echo "linux" ;;
    Darwin) echo "macos" ;;
    *)      echo "unknown" ;;
  esac
}

install() {
  local base="$1"
  local path="$2"

  if [ -z "$path" ]; then
    echo "Missing path to install"
    return 1
  fi

  local src="$REPO_ROOT/$base/$path"
  local dst="$HOME/$path"

  if [ ! -e "$src" ]; then
    echo "Error: Source $src does not exist"
    return 1
  fi

  echo "Installing $path (from $base)"

  mkdir -p "$(dirname "$dst")"

  if [ -d "$src" ]; then
    cp -r "$src/." "$dst/"
  else
    cp "$src" "$dst"
  fi
}

OS=$(detect_os)

if [ "$OS" = "unknown" ]; then
  echo "Unsupported OS"
  exit 1
fi

read -p "Apply dotfiles for $OS? This will overwrite existing files. (y/n)? " choice
case "$choice" in
  y | Y) ;;
  n | N) echo "Cancelled"; exit 1 ;;
  *)     echo "Invalid response"; exit 1 ;;
esac

echo "Deploying common configs..."
while IFS= read -r f; do
  [ -z "$f" ] && continue
  install "common" "$f" || echo "Warning: Failed to install $f"
done < "$REPO_ROOT/files.common"

echo "Deploying $OS configs..."
while IFS= read -r f; do
  [ -z "$f" ] && continue
  install "$OS" "$f" || echo "Warning: Failed to install $f"
done < "$REPO_ROOT/files.$OS"

echo "Done"
