#!/usr/bin/env bash

dir="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

 # Launch the bar 
 for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -q top -c "$dir/cuts/config.ini" &
	MONITOR=$m polybar -q bottom -c "$dir/cuts/config.ini" &
done
