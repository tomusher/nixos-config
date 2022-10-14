#!/bin/bash
if [[ -z "$@" ]]; then
  set +e
  echo "nl"
  echo "nt"
  set -e
else
  notify-send "$1"
fi
