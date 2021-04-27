#!/bin/bash
set -xe

version="2.1.0"
zip_name="JetBrainsMono.zip"
fonts_dir="$HOME/.fonts"

wget -O "${zip_name}" "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/JetBrainsMono.zip"
unzip "${zip_name}"

mkdir -p "${fonts_dir}"
mv *.ttf "${fonts_dir}"

rm -rf "${zip_name}"
