#!/bin/sh

rofi_command="rofi -theme $HOME/.config/polybar/cuts/scripts/rofi/monitormenu.rasi"

devs=$(xrandr)
count="$(echo "$devs" | grep ' connected' | wc -l)"
extra_poly_args=""

if [ "$count" = 1 ]; then
    echo -e "<Only one monitor>" | $rofi_command -p "Monitor-menu Error" -dmenu -selected row 0
    xrandr --auto
else
    ref="$(echo "$devs" | grep 'connected primary' | cut -d' ' -f1 | head -n1)"
    monitor="$(echo "$devs" | grep ' connected' | grep 'HDMI' | cut -d' ' -f1 | head -n1)"
    direction=""

    # Options
    up="⇧ Above $ref"
    down="⇩ Below $ref"
    left="⇦ Left of $ref"
    right="⇨ Right of $ref"
    dupli="▣ Duplicate $ref"

    options="$up\n$down\n$left\n$right\n$dupli"
    chosen="$(echo -e "$options" | $rofi_command -p "Position of $monitor" -dmenu -selected-row 0)"
    case $chosen in
        $up)
            direction="--above"
            ;;
        $down)
            direction="--below"
            ;;
        $left)
            direction="--left-of"
            ;;
        $right)
            direction="--right-of"
            ;;
        $dupli)
            direction="--same-as"
            extra_poly_args="--single"
            ;;
    esac
    
    if [ ! "$direction" = "" ]; then
        xrandr --output "$monitor" --auto $direction "$ref"
    fi
fi

/home/jay/.config/polybar/launch.sh --cuts $extra_poly_args
