#!/bin/bash

EMPTY_INBOX_ICON="%{T3}%{T-}"
UNREAD_INBOX_ICON="%{T2}%{T-}"

UNREAD=$(newsboat -x print-unread | cut -d " " -f1)
if [[ $1 = "count" ]]; then
   if [ $UNREAD = "0" ]; then
       echo $EMPTY_INBOX_ICON $UNREAD
   else
       echo $UNREAD_INBOX_ICON $UNREAD
   fi
elif [[ $1 = "newsboat" ]]; then
   kitty -e newsboat &
fi
