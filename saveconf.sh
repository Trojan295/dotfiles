#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

resolve_profile() {
  # Priority: $DOTFILES_PROFILE env > ~/.config/dotfiles/profile marker.
  # Never creates the marker (that's applyconf's job); empty output = skip profile layer.
  if [ -n "${DOTFILES_PROFILE:-}" ]; then
    echo "$DOTFILES_PROFILE"
  elif [ -f "$HOME/.config/dotfiles/profile" ]; then
    cat "$HOME/.config/dotfiles/profile"
  fi
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

save_manifest() {
  local base="$1"
  local manifest="$2"

  echo "Saving $base configs..."
  while IFS= read -r f; do
    if [ -z "$f" ] || [[ "$f" == \#* ]]; then
      continue
    fi
    save "$base" "$f" || echo "Warning: Failed to save $f"
  done < "$REPO_ROOT/$manifest"
}

PROFILE=$(resolve_profile)

if [ "${DOTFILES_ASSUME_YES:-0}" != "1" ]; then
  read -p "Save dotfiles to repo? This will overwrite files in the repo. (y/n)? " choice
  case "$choice" in
    y | Y) ;;
    *) echo "Cancelled"; exit 1 ;;
  esac
fi

save_manifest "common" "files.common"

if [ -n "$PROFILE" ] && [ -f "$REPO_ROOT/files.profile-$PROFILE" ]; then
  save_manifest "profiles/$PROFILE" "files.profile-$PROFILE"
fi

echo "Done"