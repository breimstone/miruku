#!/usr/bin/env bash
# A script for controlling MPD (Music Player Daemon) using a Rofi menu
# Maintained by humanwhodebugs

# Set MPD connection environment variables
export MPD_HOST="127.0.0.1"
export MPD_PORT="6601"

# Theme file used for styling the Rofi menu
theme="$HOME/.config/rofi/applets/theme/catppuccin.rasi"

# Fetch current MPD status and currently playing song
status="$(mpc status)"
current_song="$(mpc current)"

# Set prompt and message based on MPD state
if [[ -z "$status" ]]; then
  prompt='Offline' # If MPD is offline
  mesg="MPD is Offline"
else
  if [[ -z "$current_song" ]]; then
    prompt="Music Player" # If nothing is playing
    mesg="No Music Playing"
  elif [[ "$status" == *"[paused]"* ]]; then
    prompt="Music Player" # If paused
    mesg="$(mpc -f "%title%" current)"
  else
    prompt="Music Player" # If playing
    mesg="$(mpc -f "%title%" current)"
  fi
fi

# Number of columns and rows in the Rofi list view
list_col='3'
list_row='2'

# Check if icons or text should be used based on theme
layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  if [[ ${status} == *"[playing]"* ]]; then
    option_1="Pause"
  elif [[ ${status} == *"[paused]"* ]]; then
    option_1="Resume"
  else
    option_1="Play"
  fi
  option_2="Stop"
  option_3="Previous"
  option_4="Next"
  option_5="Repeat"
  option_6="Shuffle"
else
  if [[ ${status} == *"[playing]"* ]]; then
    option_1=""
  else
    option_1=""
  fi
  option_2=""
  option_3=""
  option_4=""
  option_5=""
  option_6=""
fi

# Set item highlighting for repeat and shuffle states
active=''
urgent=''

# Highlight Repeat option
if [[ ${status} == *"repeat: on"* ]]; then
  active="-a 4"
elif [[ ${status} == *"repeat: off"* ]]; then
  urgent="-u 4"
else
  option_5=" Parsing Error" # Fallback in case of unexpected output
fi

# Highlight Shuffle option
if [[ ${status} == *"random: on"* ]]; then
  [ -n "$active" ] && active+=",5" || active="-a 5"
elif [[ ${status} == *"random: off"* ]]; then
  [ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
else
  option_6=" Parsing Error" # Fallback in case of unexpected output
fi

# Function: Configure and launch the Rofi menu
# Applies theme and status info, and highlights toggle options
rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    ${active} \
    -markup-rows \
    -theme ${theme}
}

# Function: Display Rofi menu with MPD control options
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Function: Run the MPD command based on selected option
run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    status=$(mpc status)
    current_song=$(mpc current)

    if [[ "$status" == *"[playing]"* ]]; then
      mpc -q pause
      notify-send -t 2000 "Paused" "$(mpc current)"
    else
      mpc -q play
      if [[ "$status" == *"[paused]"* ]]; then
        notify-send -t 2000 "Resumed" "$(mpc current)"
      else
        notify-send -t 2000 "Now Playing" "$(mpc current)"
      fi
    fi

  elif [[ "$1" == '--opt2' ]]; then
    mpc -q stop
    notify-send -t 2000 "Stopped" "Music has been stopped"

  elif [[ "$1" == '--opt3' ]]; then
    mpc -q prev
    notify-send -t 2000 "Now Playing" "$(mpc current)"

  elif [[ "$1" == '--opt4' ]]; then
    mpc -q next
    notify-send -t 2000 "Now Playing" "$(mpc current)"

  elif [[ "$1" == '--opt5' ]]; then
    mpc -q repeat

  elif [[ "$1" == '--opt6' ]]; then
    mpc -q random
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
$option_5)
  run_cmd --opt5
  ;;
$option_6)
  run_cmd --opt6
  ;;
esac
