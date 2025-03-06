#!/usr/bin/env bash

set -eEu

apply_theme() {
  local -r theme="${1}"

  echo "$theme" >~/.config/theme

  # Change alacritty theme
  rm -f ~/.config/alacritty/alacritty.toml
  ln -s "$HOME/.config/alacritty/${theme}.alacritty.toml" ~/.config/alacritty/alacritty.toml
}

main() {
  local current_theme

  current_theme="dark"
  if [ -f ~/.config/theme ]; then
    current_theme="$(cat ~/.config/theme)"
  fi

  local new_theme

  if [ "$current_theme" = "dark" ]; then
    echo "Switching to light theme"
    new_theme="light"

  elif [ "$current_theme" = "light" ]; then
    echo "Switching to dark theme"
    new_theme="dark"
  else
    echo "Unknown theme: $current_theme, fallback to dark theme"
    new_theme="dark"
  fi

  apply_theme "$new_theme"
}

# shellcheck disable=SC2068
main $@
