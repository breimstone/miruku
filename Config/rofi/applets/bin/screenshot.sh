#!/usr/bin/env bash
# A script to capture screenshots using Rofi and maim
# Maintained by humanwhodebugs

# Theme file used for styling the Rofi menu
theme="$HOME/.config/rofi/applets/theme/catppuccin.rasi"

# Prompt and message displayed in the Rofi menu
prompt="Screenshot"
mesg="DIR: Pictures/Screenshots"

# Number of columns, rows, and window width in the Rofi list view
list_col='1'
list_row='4'
win_width='400px'

# Check if the theme uses icons or text, based on 'USE_ICON' flag
layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1="Capture Desktop" # Full screen
  option_2="Capture Area"    # Manual selection
  option_3="Capture in 5s"   # Delayed capture
  option_4="Capture in 10s"  # Longer delay
else
  option_1=""
  option_2=""
  option_3=""
  option_4=""
fi

# Function: Configure and launch the Rofi menu
# Applies theme and layout settings for displaying options
rofi_cmd() {
  rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
}

# Function: Display Rofi menu with the available screenshot options
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Setup filename with timestamp
time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$HOME/Pictures/Screenshots"
file="Screenshot_${time}.png"

# Create screenshot directory if it doesn't exist
if [[ ! -d "$dir" ]]; then
  mkdir -p "$dir"
fi

# Function: Show notifications and preview screenshot
notify_view() {
  notify_cmd_shot='dunstify'
  notify-send -t 2000 "Screenshot" "Screenshot taken and copied to clipboard."
}

# Function: Copy screenshot to clipboard
copy_shot() {
  tee "$file" | xclip -selection clipboard -t image/png
}

# Function: Display countdown before taking screenshot
countdown() {
  for sec in $(seq "$1" -1 1); do
    dunstify -u low -t 1000 "Taking shot in" "$sec"
    sleep 1
  done
}

# Function: Capture full desktop immediately
shotnow() {
  cd "$dir" && sleep 0.5 && maim -u -f png | copy_shot
  notify_view
}

# Function: Capture full desktop after 5 seconds
shot5() {
  countdown '5'
  sleep 1 && cd "$dir" && maim -u -f png | copy_shot
  notify_view
}

# Function: Capture full desktop after 10 seconds
shot10() {
  countdown '10'
  sleep 1 && cd "$dir" && maim -u -f png | copy_shot
  notify_view
}

# Function: Capture a manually selected area
shotarea() {
  cd "$dir" && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | copy_shot
  notify_view
}

# Function: Run the command based on user selection
run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    shotnow
  elif [[ "$1" == '--opt2' ]]; then
    shotarea
  elif [[ "$1" == '--opt3' ]]; then
    shot5
  elif [[ "$1" == '--opt4' ]]; then
    shot10
  fi
}

# Run Rofi menu and capture user selection
chosen="$(run_rofi)"
case ${chosen} in
$option_1)
  run_cmd --opt1
  ;;
$option_2)
  run_cmd --opt2
  ;;
$option_3)
  run_cmd --opt3
  ;;
$option_4)
  run_cmd --opt4
  ;;
esac
