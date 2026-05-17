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

check_yay() {
  if ! command -v yay &>/dev/null; then
    print_info "yay not found. Installing..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
    print_success "yay installed"
  fi
}

install_packages() {
  local packages=("$@")
  if [ ${#packages[@]} -eq 0 ]; then
    return 0
  fi

  print_info "Installing: ${packages[*]}"
  yay -S --needed --noconfirm "${packages[@]}" || {
    print_error "Failed to install some packages"
    return 1
  }
  print_success "Installed ${#packages[@]} packages"
}

install_base() {
  print_header "Installing BASE packages"
  local packages=(
    zsh
    fzf
    tmux
    neovim
    zoxide
    git
    git-delta
    git-lfs
    curl
    wget
  )
  install_packages "${packages[@]}"
}

install_tmux_plugins() {
  print_header "Installing TMUX plugins (tpm)"
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    print_info "Installing tpm (tmux plugin manager)..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir" || {
      print_error "Failed to clone tpm"
      return 1
    }
    print_success "tpm installed"
  else
    print_info "tpm already installed, updating..."
    git -C "$tpm_dir" pull || true
  fi

  if [ -f "$HOME/.config/tmux/tmux.conf" ]; then
    print_info "Installing tmux plugins..."
    tmux new-session -d -s __tpm_install \; source-file "$HOME/.config/tmux/tmux.conf" \; run-shell "$tpm_dir/bin/install_plugins" \; kill-session -t __tpm_install || {
      print_error "Failed to install some tmux plugins"
      return 1
    }
    print_success "tmux plugins installed"
  else
    print_info "tmux.conf not found, skipping plugin installation"
  fi
}

install_desktop() {
  print_header "Installing DESKTOP packages"
  local packages=(
    hyprland
    alacritty
    waybar
    thunar
    wofi
    grim
    slurp
    wl-clipboard
    playerctl
    brightnessctl
    wireplumber
    pavucontrol
  )
  install_packages "${packages[@]}"

  print_info "Installing awww from AUR..."
  yay -S --noconfirm awww || print_error "Failed to install awww (AUR)"

  print_success "Desktop packages installed"
}

install_devtools() {
  print_header "Installing DEV TOOLS packages"
  local packages=(
    go
    kubectl
    kubectx
    kubens
    kind
    helm
    aws-cli-v2
  )
  install_packages "${packages[@]}"

  print_info "Installing fnm from AUR..."
  yay -S --noconfirm fnm || print_error "Failed to install fnm (AUR)"

  print_success "Dev tools installed"
}

install_fonts() {
  print_header "Installing FONTS packages"
  local packages=(
    ttf-jetbrains-mono
  )
  install_packages "${packages[@]}"
  print_success "Fonts installed"
}

install_aur() {
  print_header "Installing AUR/CUSTOM packages"
  local packages=(
    opencode-bin
  )
  install_packages "${packages[@]}"
  print_success "AUR packages installed"
}

install_sddm() {
  print_header "Setting up SDDM login screen (SilentSDDM + Kanagawa)"
  local repo_root
  repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
  local theme_dir="/usr/share/sddm/themes/silent"

  yay -S --needed --noconfirm sddm-silent-theme-git qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg || {
    print_error "Failed to install SilentSDDM theme"
    return 1
  }

  sudo mkdir -p "$theme_dir/configs"
  sudo cp "$repo_root/linux/etc/sddm/configs/kanagawa.conf" "$theme_dir/configs/kanagawa.conf"
  sudo mkdir -p "$theme_dir/backgrounds"
  sudo cp "$repo_root/linux/etc/sddm/backgrounds/background.png" "$theme_dir/backgrounds/background.png"
  sudo sed -i "s|^ConfigFile=.*|ConfigFile=configs/kanagawa.conf|" "$theme_dir/metadata.desktop"

  sudo tee /etc/sddm.conf > /dev/null << 'SDDMEOF'
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent

[Autologin]
Session=hyprland
SDDMEOF

  print_success "SDDM configured with Kanagawa theme"
  print_info "Test with: cd $theme_dir && sudo ./test.sh"
}

show_menu() {
  echo ""
  print_header "Select packages to install"
  echo ""
  echo "  1) [${base:- ]} BASE         - zsh, fzf, tmux, neovim, zoxide, git..."
  echo "  2) [${desktop:- ]} DESKTOP    - hyprland, alacritty, waybar, thunar, wofi..."
  echo "  3) [${devtools:- ]} DEV TOOLS - go, kubectl, kubectx, kubens, kind, helm, aws-cli..."
  echo "  4) [${fonts:- ]} FONTS       - ttf-jetbrains-mono, ttf-nerd-fonts..."
  echo "  5) [${aur:- ]} AUR          - opencode-bin..."
  echo "  6) [${sddm:- ]} SDDM        - SilentSDDM theme with Kanagawa (requires sudo)"
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
  aur=""
  sddm=""

  while true; do
    show_menu
    read -p "Choose: " choice

    case $choice in
    1) toggle base ;;
    2) toggle desktop ;;
    3) toggle devtools ;;
    4) toggle fonts ;;
    5) toggle aur ;;
    6) toggle sddm ;;
    a | A)
      base="x"
      desktop="x"
      devtools="x"
      fonts="x"
      aur="x"
      sddm="x"
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

    if [[ "$base" == "x" ]] || [[ "$desktop" == "x" ]] || [[ "$devtools" == "x" ]] || [[ "$fonts" == "x" ]] || [[ "$aur" == "x" ]] || [[ "$sddm" == "x" ]]; then
      read -p "Ready to install? [y/n]: " confirm_choice
      case $confirm_choice in
      y | Y) break ;;
      *) continue ;;
      esac
    fi
  done

  if [[ "$base" == "x" ]]; then
    install_base
    install_tmux_plugins
  fi
  if [[ "$desktop" == "x" ]]; then install_desktop; fi
  if [[ "$devtools" == "x" ]]; then install_devtools; fi
  if [[ "$fonts" == "x" ]]; then install_fonts; fi
  if [[ "$aur" == "x" ]]; then install_aur; fi
  if [[ "$sddm" == "x" ]]; then install_sddm; fi

  print_header "Installation complete!"
  print_success "Done!"
}

check_yay
main
