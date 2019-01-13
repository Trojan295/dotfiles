#!/bin/bash

pidof polybar | xargs kill

for monitor in $(polybar --list-monitors | cut -d ':' -f 1); do
    MONITOR=$monitor polybar --reload main &
done
