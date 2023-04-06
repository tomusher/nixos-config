#!/usr/bin/env bash
SEARCH="tag:notify"

NOTIFY_COUNT=$(notmuch count "$SEARCH")

if [ "$NOTIFY_COUNT" -gt 0 ]; then
  RESULTS=$(notmuch search --format=json --output=summary --limit=3 --sort="newest-first" "$SEARCH" | jq -r '.[] | "\(.authors): \(.subject)"')
  notify-send "$NOTIFY_COUNT new mesages." "$RESULTS"
fi

notmuch tag -notify -- tag:notify