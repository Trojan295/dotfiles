#!/bin/bash

pidof polybar | xargs kill

export WIFI=$(cat /proc/net/dev | cut -d ':' -f 1 | tr -d ' ' | tail -n +3 | grep wl)
export ETHERNET=$(cat /proc/net/dev | cut -d ':' -f 1 | tr -d ' ' | tail -n +3 | grep en)

for monitor in $(polybar --list-monitors | cut -d ':' -f 1); do
    MONITOR=$monitor polybar --reload main &
done
