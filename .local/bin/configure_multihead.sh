#!/bin/bash

xrandr --setprovideroutputsource Intel NVIDIA-0
xrandr --output eDP-1-1 --left-of DP1

$HOME/.local/bin/launch_polybar.sh
