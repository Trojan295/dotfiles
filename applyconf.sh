#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

resolve_profile() {
  # Priority: $DOTFILES_PROFILE env > ~/.config/dotfiles/profile marker > first-run prompt
  local profile="${DOTFILES_PROFILE:-}"
  if [ -z "$profile" ] && [ -f "$HOME/.config/dotfiles/profile" ]; then
    profile="$(cat "$HOME/.config/dotfiles/profile")"
  fi
  if [ -z "$profile" ]; then
    read -p "Create profile marker ~/.config/dotfiles/profile (work|personal) [work]: " profile
    profile="${profile:-work}"
  fi
  mkdir -p "$HOME/.config/dotfiles"
  printf '%s\n' "$profile" > "$HOME/.config/dotfiles/profile"
  echo "$profile"
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

deploy_manifest() {
  local base="$1"
  local manifest="$2"

  echo "Deploying $base configs..."
  while IFS= read -r f; do
    if [ -z "$f" ] || [[ "$f" == \#* ]]; then
      continue
    fi
    install "$base" "$f" || echo "Warning: Failed to install $f"
  done < "$REPO_ROOT/$manifest"
}

sync_repo() {
  local url="$1"
  local dst="$2"

  if [ ! -e "$dst" ]; then
    echo "Cloning $url -> $dst"
    mkdir -p "$(dirname "$dst")"
    git clone "$url" "$dst" || echo "Warning: Failed to clone $url"
  elif [ -d "$dst/.git" ]; then
    echo "Updating $dst"
    git -C "$dst" pull --ff-only || echo "Warning: Failed to update $dst"
  else
    echo "Warning: $dst exists and is not a git repo, skipping"
  fi
}

PROFILE=$(resolve_profile)

if [ "${DOTFILES_ASSUME_YES:-0}" != "1" ]; then
  read -p "Apply dotfiles (profile: $PROFILE)? This will overwrite existing files. (y/n)? " choice
  case "$choice" in
    y | Y) ;;
    *) echo "Cancelled"; exit 1 ;;
  esac
fi

deploy_manifest "common" "files.common"

if [ -f "$REPO_ROOT/files.profile-$PROFILE" ]; then
  deploy_manifest "profiles/$PROFILE" "files.profile-$PROFILE"
else
  echo "Note: no files.profile-$PROFILE manifest, skipping profile layer"
fi

sync_repo "https://github.com/Trojan295/LazyVim" "$HOME/.config/nvim"

echo "Done"