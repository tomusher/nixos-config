#!/usr/bin/env bash
echo "Removing emails deleted from inbox"
notmuch new --no-hooks
notmuch search --output=files --format=text folder:/Inbox/ -tag:inbox | grep Inbox | xargs --no-run-if-empty rm
notmuch new --no-hooks