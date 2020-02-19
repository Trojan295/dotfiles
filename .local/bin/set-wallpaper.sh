#!/bin/bash

display_nr=$(expr $(polybar --list-monitors | wc -l) - 1)

for display_no in $(seq 0 $display_nr); do
    resolution=$(polybar --list-monitors | tail -n+$display_no | head -n1 | awk -F ' ' '{print $2}' | awk -F '+' '{print $1}')

    nitrogen --head=$display_no --set-scaled $HOME/.local/share/wallpapers/${resolution}.jpg
done

