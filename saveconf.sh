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

save() {
  local base="$1"
  local path="$2"

  if [ -z "$path" ]; then
    echo "Missing path to save"
    return 1
  fi

  local src="$HOME/$path"
  local dst="$REPO_ROOT/$base/$path"

  if [ ! -e "$src" ]; then
    echo "Error: Source $src does not exist"
    return 1
  fi

  echo "Saving $path (to $base)"

  mkdir -p "$(dirname "$dst")"

  if [ -d "$src" ]; then
    if [ ! -d "$dst" ]; then
      mkdir -p "$dst"
    fi
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

read -p "Save dotfiles from $OS to repo? This will overwrite files in the repo. (y/n)? " choice
case "$choice" in
  y | Y) ;;
  n | N) echo "Cancelled"; exit 1 ;;
  *)     echo "Invalid response"; exit 1 ;;
esac

echo "Saving common configs..."
while IFS= read -r f; do
  [ -z "$f" ] || [[ "$f" == \#* ]] && continue
  save "common" "$f" || echo "Warning: Failed to save $f"
done < "$REPO_ROOT/files.common"

echo "Saving $OS configs..."
while IFS= read -r f; do
  [ -z "$f" ] || [[ "$f" == \#* ]] && continue
  save "$OS" "$f" || echo "Warning: Failed to save $f"
done < "$REPO_ROOT/files.$OS"

echo "Done"
