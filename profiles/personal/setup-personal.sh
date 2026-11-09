#!/bin/bash

# Personal profile installer (CachyOS / Arch Linux) — pacman, official repos only.
# Run from the repo root: ./profiles/personal/setup-personal.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

print_info() {
  echo -e "${YELLOW}ℹ $1${NC}"
}

pacman_install() {
  local packages=("$@")
  if [ ${#packages[@]} -eq 0 ]; then
    return 0
  fi

  print_info "Installing via pacman: ${packages[*]}"
  sudo pacman -S --needed --noconfirm "${packages[@]}" || {
    print_error "Failed to install some packages"
    return 1
  }
  print_success "Installed ${#packages[@]} packages via pacman"
}

install_base() {
  print_header "Installing BASE packages"
  local packages=(
    zsh
    tmux
    fzf
    zoxide
    git
    git-delta
    git-lfs
    curl
    wget
    eza
    atuin
    lazygit
    direnv
  )
  pacman_install "${packages[@]}"
}

install_desktop() {
  print_header "Installing DESKTOP packages"
  pacman_install ghostty
  print_success "Desktop packages installed"
}

install_devtools() {
  print_header "Installing DEV TOOLS packages"
  local packages=(
    go
    neovim
    kubectl
    kubectx
    k9s
    helm
    kind
    aws-cli-v2
    fnm
  )
  pacman_install "${packages[@]}"
  print_success "Dev tools installed"
}

install_fonts() {
  print_header "Installing FONTS packages"
  pacman_install ttf-jetbrains-mono-nerd
  print_success "Fonts installed"
}

install_extras() {
  print_header "Installing EXTRAS"
  pacman_install opencode
  print_success "Extras installed"
}

show_menu() {
  echo ""
  print_header "Select packages to install"
  echo ""
  echo "  1) [${base:- }] BASE      - zsh, tmux, fzf, zoxide, git, delta, eza, atuin, lazygit, direnv..."
  echo "  2) [${desktop:- }] DESKTOP   - ghostty"
  echo "  3) [${devtools:- }] DEV TOOLS - go, neovim, kubectl, kubectx, k9s, helm, kind, aws-cli, fnm"
  echo "  4) [${fonts:- }] FONTS     - ttf-jetbrains-mono-nerd"
  echo "  5) [${extras:- }] EXTRAS    - opencode"
  echo ""
  echo "  a) Install ALL"
  echo "  q) Quit"
  echo ""
}

toggle() {
  local var=$1
  if [ "${!var}" = "x" ]; then
    eval "$var=' '"
  else
    eval "$var=x"
  fi
}

main() {
  base=""
  desktop=""
  devtools=""
  fonts=""
  extras=""

  while true; do
    show_menu
    read -p "Choose: " choice

    case $choice in
    1) toggle base ;;
    2) toggle desktop ;;
    3) toggle devtools ;;
    4) toggle fonts ;;
    5) toggle extras ;;
    a | A)
      base="x"
      desktop="x"
      devtools="x"
      fonts="x"
      extras="x"
      ;;
    q | Q) exit 0 ;;
    *)
      echo "Invalid option"
      continue
      ;;
    esac

    if [[ "$choice" != "a" && "$choice" != "A" ]]; then
      show_menu
    fi

    if [[ "$base" == "x" ]] || [[ "$desktop" == "x" ]] || [[ "$devtools" == "x" ]] || [[ "$fonts" == "x" ]] || [[ "$extras" == "x" ]]; then
      read -p "Ready to install? [y/n]: " confirm_choice
      case $confirm_choice in
      y | Y) break ;;
      *) continue ;;
      esac
    fi
  done

  if [[ "$base" == "x" ]]; then install_base; fi
  if [[ "$desktop" == "x" ]]; then install_desktop; fi
  if [[ "$devtools" == "x" ]]; then install_devtools; fi
  if [[ "$fonts" == "x" ]]; then install_fonts; fi
  if [[ "$extras" == "x" ]]; then install_extras; fi

  print_header "Installation complete!"
  print_success "Done!"
}

main
