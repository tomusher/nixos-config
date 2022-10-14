#!/bin/bash

EMPTY_INBOX_ICON="%{T3}%{T-}"
UNREAD_INBOX_ICON="%{T2}%{T-}"

UNREAD=$(NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch/config notmuch count is:inbox and is:unread)
if [[ $1 = "count" ]]; then
   if [ $UNREAD = "0" ]; then
       echo $EMPTY_INBOX_ICON $UNREAD
   else
       echo $UNREAD_INBOX_ICON $UNREAD
   fi
elif [[ $1 = "alot" ]]; then
   $TERMINAL -e alot &
fi
