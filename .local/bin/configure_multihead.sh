#!/bin/bash

xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --output eDP-1-1 --left-of DP-0

$HOME/.local/bin/launch_polybar.sh
