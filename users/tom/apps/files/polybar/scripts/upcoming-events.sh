#/usr/bin/env bash
echo $(~/.local/share/pyenv/versions/3.8.2/bin/gcalcli \
    --calendar Personal --calendar Work --calendar "Mr T T Usher" \
    agenda today tomorrow --nostarted --tsv \
    | head -n 1 | awk 'BEGIN {FS="\t"}; {printf "%s - %s", $2, $5;};')
