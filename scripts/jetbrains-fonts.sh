#!/bin/bash
set -xe

font_package="JetBrainsMono-1.0.6"
fonts_dir="$HOME/.fonts"

wget https://github.com/JetBrains/JetBrainsMono/releases/download/v1.0.6/${font_package}.zip
unzip ${font_package}.zip

mkdir -p $fonts_dir
cp ${font_package}/ttf/* ${fonts_dir}

rm -rf ${font_package}*

