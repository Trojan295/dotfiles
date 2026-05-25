#!/bin/bash

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

confirm() {
  while true; do
    read -p "$1 [y/n]: " yn
    case $yn in
    [Yy]*) return 0 ;;
    [Nn]*) return 1 ;;
    *) echo "Please answer y or n" ;;
    esac
  done
}

check_brew() {
  if ! command -v brew &>/dev/null; then
    print_info "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    print_success "Homebrew installed"
  fi
}

apt_install() {
  local packages=("$@")
  if [ ${#packages[@]} -eq 0 ]; then
    return 0
  fi

  print_info "Installing via apt: ${packages[*]}"
  sudo apt install -y "${packages[@]}" || {
    print_error "Failed to install some packages"
    return 1
  }
  print_success "Installed ${#packages[@]} packages via apt"
}

brew_install() {
  local packages=("$@")
  if [ ${#packages[@]} -eq 0 ]; then
    return 0
  fi

  print_info "Installing via brew: ${packages[*]}"
  brew install "${packages[@]}" || {
    print_error "Failed to install some packages"
    return 1
  }
  print_success "Installed ${#packages[@]} packages via brew"
}

install_base() {
  print_header "Installing BASE packages"
  local packages=(
    zsh
    fzf
    zoxide
    git
    git-delta
    git-lfs
    curl
    wget
  )
  apt_install "${packages[@]}"

  check_brew
  local brew_packages=(
    zellij
    eza
    atuin
    lazygit
  )
  brew_install "${brew_packages[@]}"
}

install_desktop() {
  print_header "Installing DESKTOP packages"
  local packages=(
    alacritty
  )
  apt_install "${packages[@]}"
  print_success "Desktop packages installed"
}

install_devtools() {
  print_header "Installing DEV TOOLS packages"

  local apt_packages=(
    golang-go
    kubectx
  )
  apt_install "${apt_packages[@]}"

  local brew_packages=(
    neovim
    kubectl
    helm
    kind
    awscli
    fnm
  )
  check_brew
  brew_install "${brew_packages[@]}"

  print_success "Dev tools installed"
}

install_fonts() {
  print_header "Installing FONTS packages"
  local packages=(
    fonts-jetbrains-mono
  )
  apt_install "${packages[@]}"

  check_brew
  brew_install font-jetbrains-mono-nerd-font

  print_success "Fonts installed"
}

install_brew_extras() {
  print_header "Installing BREW extras"
  check_brew
  local packages=(
    opencode
  )
  brew_install "${packages[@]}"
  print_success "Brew extras installed"
}

show_menu() {
  echo ""
  print_header "Select packages to install"
  echo ""
  echo "  1) [${base:- }] BASE         - zsh, fzf, zellij, neovim, zoxide, git..."
  echo "  2) [${desktop:- }] DESKTOP    - alacritty..."
  echo "  3) [${devtools:- }] DEV TOOLS - go, kubectl, kubectx, helm, kind, awscli, fnm..."
  echo "  4) [${fonts:- }] FONTS       - fonts-jetbrains-mono..."
  echo "  5) [${brew_extras:- }] BREW EXTRAS - opencode..."
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
  brew_extras=""

  while true; do
    show_menu
    read -p "Choose: " choice

    case $choice in
    1) toggle base ;;
    2) toggle desktop ;;
    3) toggle devtools ;;
    4) toggle fonts ;;
    5) toggle brew_extras ;;
    a | A)
      base="x"
      desktop="x"
      devtools="x"
      fonts="x"
      brew_extras="x"
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

    if [[ "$base" == "x" ]] || [[ "$desktop" == "x" ]] || [[ "$devtools" == "x" ]] || [[ "$fonts" == "x" ]] || [[ "$brew_extras" == "x" ]]; then
      read -p "Ready to install? [y/n]: " confirm_choice
      case $confirm_choice in
      y | Y) break ;;
      *) continue ;;
      esac
    fi
  done

  if [[ "$base" == "x" ]]; then
    install_base
  fi
  if [[ "$desktop" == "x" ]]; then install_desktop; fi
  if [[ "$devtools" == "x" ]]; then install_devtools; fi
  if [[ "$fonts" == "x" ]]; then install_fonts; fi
  if [[ "$brew_extras" == "x" ]]; then install_brew_extras; fi

  print_header "Installation complete!"
  print_success "Done!"
}

main
