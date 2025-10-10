#!/bin/sh

music_dir="$HOME/Music"
previewdir="$HOME/.ncmpcpp/previews"
filename="$(mpc -p 6601 --format "$music_dir"/%file% current)"
previewname="$previewdir/$(mpc -p 6601 --format %album% current | base64).png"

[ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" >/dev/null 2>&1

notify-send -t 4000 "Now Playing" "$(mpc -p 6601 --format '%artist% - %title%' current)" -i "$previewname"
