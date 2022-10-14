#/usr/bin/env bash

function tray_status {
    if pgrep -x stalonetray >/dev/null; then
       echo ""
    else
       echo ""
    fi
}

function tray_on {
    i3-msg "exec --no-startup-id stalonetray --config ~/.config/stalonetrayrc"
}

function tray_off {
    killall stalonetray
}

function tray_toggle {
    if pgrep -x stalonetray >/dev/null; then
        tray_off
    else
        tray_on
    fi
    polybar-msg hook tray 1
}

case $1 in
    on)
        tray_on
    ;;
    off)
        tray_off
    ;;
    toggle)
        tray_toggle
    ;;
    *)
        tray_status
    ;;
esac

