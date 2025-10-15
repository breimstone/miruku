# Arch Linux Installation and Configuration Guide

## INSTALLATION PROCESS

### 1. Connect to Internet

iwctl
station wlan0 connect [WLAN_NAME]

After connecting, type `clear` and then `exit`

### 2. Update System Clock

Test connection first with `ping 8.8.8.8` then type `timedatectl`

If synchronized, set keymap with `loadkeys jp106`
