#/usr/bin/env bash

function notifications_status {
    status="$(dunstctl is-paused)"
    
    if [[ $status == "true" ]]; then
       echo ""
    else
       echo ""
    fi
}

function notifications_on {
    dunstctl set-paused false
}

function notifications_off {
    dunstctl set-paused true
}

function notifications_toggle {
    status="$(dunstctl is-paused)"
    if [[ $status == "true" ]]; then
        notifications_on
    else
        notifications_off
    fi
    polybar-msg hook notify 1
}

case $1 in
    on)
        notifications_on
    ;;
    off)
        notifications_off
    ;;
    toggle)
        notifications_toggle
    ;;
    *)
        notifications_status
    ;;
esac

