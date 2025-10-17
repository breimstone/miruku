# Arch Linux Installation and Configuration Guide

## INSTALLATION PROCESS

### 1. Connect to Internet

Type `iwctl`
station wlan0 connect [WLAN_NAME]

After connecting, type `clear` and then `exit`

### 2. Update System Clock

Test connection first with `ping 8.8.8.8` then type `timedatectl`
If synchronized, set keymap with `loadkeys jp106`

### 3. Disk Partitioning

Format whole disk by typing `mkfs.ext4 /dev/sda`
Then do disk partition using `fdisk /dev/sda`

Create partitions as follows:
40GB/60GB for root
8GB for swap
Rest for home

Format partitions:
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

Mount partitions:
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home
