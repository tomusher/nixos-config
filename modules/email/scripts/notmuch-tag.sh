#!/usr/bin/env bash
echo "Tagging new inboxed mail"
notmuch tag +inbox -- folder:/Inbox/ and tag:new
notmuch tag +notify -- tag:new and tag:unread and tag:inbox
notmuch tag -new -- tag:new