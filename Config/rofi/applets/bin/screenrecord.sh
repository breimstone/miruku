#!/usr/bin/env bash
# A script to control screen recording using Rofi and gpu-screen-recorder
# Maintained by humanwhodebugs

# Theme file used for styling the Rofi menu
theme="$HOME/.config/rofi/applets/theme/catppuccin.rasi"

# Prompt and message displayed in the Rofi menu
prompt="Screen Recorder"
mesg="DIR: Videos/Screenrecords"

# Number of columns and rows in the Rofi list view
list_col='2'
list_row='1'

# Check if the theme uses icons or text, based on 'USE_ICON' flag
layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
  option_1="Start Recording" # Text label for start
  option_2="Stop Recording"  # Text label for stop
else
  option_1="" # Icon for start
  option_2="" # Icon for stop
fi

# Function: Configure and launch the Rofi menu
# Applies theme and layout settings for displaying options
rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
}

# Function: Display Rofi menu with the available recording options
run_rofi() {
  echo -e "$option_1\n$option_2" | rofi_cmd
}

# Function: Start screen recording using ffmpeg (WhatsApp-compatible)
start_recording() {
  n=1
  # Find next available file name
  while [[ -e "$HOME/Videos/Screenrecords/screen-recording-$n.mp4" ]]; do ((n++)); done

  # Launch ffmpeg screen recording (X11 + PulseAudio)
  ffmpeg -f pulse -i alsa_output.pci-0000_00_1b.0.analog-stereo.monitor \
    -f x11grab -framerate 30 -video_size 1366x768 -i :0.0 \
    -c:v libx264 -preset ultrafast -tune zerolatency -crf 28 \
    -pix_fmt yuv420p -profile:v baseline -level 3.1 \
    -c:a aac -b:a 128k \
    "$HOME/Videos/Screenrecords/screen-recording-$n.mp4" &

  echo $! >/tmp/screen_recording.pid # Save process ID
  notify-send -t 2000 "Screen Recorder" "Recording started: screen-recording-$n.mp4"
}

# Function: Stop screen recording
stop_recording() {
  if [[ -f /tmp/screen_recording.pid ]]; then
    PID=$(cat /tmp/screen_recording.pid)
    kill -SIGINT "$PID"
    rm /tmp/screen_recording.pid

    # Get the latest recording file
    latest_recording=$(ls -t "$HOME/Videos/Screenrecords/"screen-recording-*.mp4 | head -n 1)
    notify-send -t 2000 "Screen Recorder" "Recording stopped.\nSaved to: $latest_recording"
  else
    notify-send -t 2000 "Screen Recorder" "No active recording found."
  fi
}

# Function: Run the command based on user selection
run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    start_recording
  elif [[ "$1" == '--opt2' ]]; then
    stop_recording
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
