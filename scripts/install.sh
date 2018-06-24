#!/bin/bash
set -e

EQUILUX_VERSION="v20180513"
PAPIRUS_ICONS_VERSION="20180601"

function install_oh_my_zsh {
  if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
  if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel9k ]; then
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  fi
  mkdir -p ~/.local/share/fonts ~/.config/fontconfig/conf.d/
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -O ~/.local/share/fonts/PowerlineSymbols.otf
  wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -O ~/.config/fontconfig/conf.d/10-powerline-symbols.conf
  fc-cache -vf ~/.local/share/fonts/
}

function install_theme {
  pushd /tmp

  wget https://github.com/ddnexus/equilux-theme/archive/equilux-${EQUILUX_VERSION}.tar.gz
  tar xf equilux-${EQUILUX_VERSION}.tar.gz
  pushd equilux-theme-equilux-${EQUILUX_VERSION}
      sudo ./install.sh
  popd
  rm -rf equilux-${EQUILUX_VERSION}.tar.gz
  popd
}

function install_icons {
  mkdir -p ~/.icons
  pushd ~/.icons

  wget https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/${PAPIRUS_ICONS_VERSION}.tar.gz
  tar xf ${PAPIRUS_ICONS_VERSION}.tar.gz

  find papirus-icon-theme-${PAPIRUS_ICONS_VERSION} -name "Papirus*" | xargs -I{} mv {} .
  rm -rf papirus-icon-theme-${PAPIRUS_ICONS_VERSION} ${PAPIRUS_ICONS_VERSION}.tar.gz

  popd
}

function install_fonts {
  mkdir -p ~/.fonts
  pushd ~/.fonts
wget -O Input-Fonts.zip "http://input.fontbureau.com/build/?fontSelection=whole&a=0&g=0&i=topserif&l=serifs&zero=0&asterisk=0&braces=straight&preset=andale&line-height=1.2&accept=I+do&email="
  unzip Input-Fonts.zip
  find Input_Fonts -name "*.ttf" | xargs -I{} mv {} .
  rm -rf Input-Fonts.zip Scripts Input_Fonts *.txt
  popd
}

install_oh_my_zsh
install_theme
install_icons
install_fonts

