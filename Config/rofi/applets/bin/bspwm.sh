#!/usr/bin/env bash
# A script for switching BSPWM layout using Rofi menu
# Maintained by humanwhodebugs

# Theme file used for styling the Rofi menu
theme="$HOME/.config/rofi/applets/theme/catppuccin.rasi"

# Prompt text shown at the top of the Rofi menu
prompt="BSPWM Layout"

# Number of columns and rows in the Rofi list view
list_col='2'
list_row='1'

# Check if the theme uses icons or text, based on 'USE_ICON' flag
layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1="Normal" # Text label for normal layout
  option_2="Zen"    # Text label for zen layout
else
  option_1="" # Icon for normal layout
  option_2="" # Icon for zen layout
fi

# Function: Configure and launch the Rofi menu
# Applies theme and layout settings for displaying layout options
rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -dmenu \
    -p "$prompt" \
    -markup-rows \
    -theme ${theme}
}

# Function: Display Rofi menu with the available layout options
run_rofi() {
  echo -e "$option_1\n$option_2" | rofi_cmd
}

# Function: Apply the Normal layout
# Copies Normal layout config to active bspwmrc and reloads BSPWM
normal() {
  CONFIG_SRC="$HOME/.config/bspwm/bin/layout/Normal/bspwmrc"
  CONFIG_DEST="$HOME/.config/bspwm/bspwmrc"

  rm -f "$CONFIG_DEST"
  cp "$CONFIG_SRC" "$CONFIG_DEST"
  chmod +x "$CONFIG_DEST"
  bspc wm -r

  notify-send -t 2000 "Layout Changed" "Normal Mode"
}

# Function: Apply the Zen layout
# Copies Zen layout config to active bspwmrc and reloads BSPWM
zen() {
  CONFIG_SRC="$HOME/.config/bspwm/bin/layout/Zen/bspwmrc"
  CONFIG_DEST="$HOME/.config/bspwm/bspwmrc"

  rm -f "$CONFIG_DEST"
  cp "$CONFIG_SRC" "$CONFIG_DEST"
  chmod +x "$CONFIG_DEST"
  bspc wm -r

  notify-send -t 2000 "Layout Changed" "Zen Mode"
}

# Function: Run the layout command based on user choice
run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    normal
  elif [[ "$1" == '--opt2' ]]; then
    zen
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
esac
