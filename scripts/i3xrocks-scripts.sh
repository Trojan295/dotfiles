#!/bin/bash
set -eEu

readonly scripts=(
  https://raw.githubusercontent.com/regolith-linux/regolith-i3xrocks-config/master/scripts/battery
  https://raw.githubusercontent.com/regolith-linux/regolith-i3xrocks-config/master/scripts/volume
)

for script in ${scripts[*]}; do
  name=$(echo "$script" | rev | awk -F '/' '{print $1}' | rev)

  echo "- Downloading script ${name}..."

  sudo curl -o "/usr/local/bin/${name}" $script
  sudo chmod +x "/usr/local/bin/${name}"
done