#!/bin/bash
# A script to capture notifications, save them, and push updates to EWW.
# Maintained by humanwhodebugs

# Path to the JSON file for notification history
HISTORY_FILE="$HOME/.config/dunst/history.json"
# Maximum number of notifications to keep in the history
MAX_HISTORY=2
# Path to the EWW notifications script
EWW_NOTIFICATIONS_SCRIPT="$HOME/.config/eww/scripts/notifications"
# Path to the eww binary
EWW_BIN="$HOME/.local/bin/eww"

# --- Part 1: Save Notification to File ---

# Generate a Unix timestamp for the current notification
timestamp=$(date +%s)
# Create a new JSON object for the notification
new_notification=$(jq -n \
  --arg ts "$timestamp" \
  --arg appname "$1" \
  --arg summary "$2" \
  --arg body "$3" \
  '{timestamp: $ts | tonumber, appname: $appname, summary: $summary, body: $body}')

# Create the history file if it doesn't exist
if [ ! -f "$HISTORY_FILE" ]; then
  echo "[]" >"$HISTORY_FILE"
fi

# Use a temporary file to safely write the new history
TMP_FILE="${HISTORY_FILE}.tmp"
jq --argjson new_notif "$new_notification" \
  --arg max_h "$MAX_HISTORY" \
  '[ $new_notif ] + . | .[0:($max_h | tonumber)]' \
  "$HISTORY_FILE" >"$TMP_FILE"

# If jq command was successful, replace the old history file with the new one
if [ $? -eq 0 ]; then
  mv "$TMP_FILE" "$HISTORY_FILE"
else
  rm -f "$TMP_FILE"
  exit 1
fi

# --- Part 2: Push Update to EWW ---

# Check if the EWW script is executable, then trigger an update
if [ -x "$EWW_NOTIFICATIONS_SCRIPT" ]; then
  formatted_json=$($EWW_NOTIFICATIONS_SCRIPT)
  ${EWW_BIN} update "notifications=$formatted_json"
fi

# --- Part 3: Trigger popup window in EWW ---
${EWW_BIN} open notif
(sleep 5 && ${EWW_BIN} close notif) &
