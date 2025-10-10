#!/bin/bash

set -eu # Stop script if there's an error

echo "╭──────────────────────────────╮"
echo "│         Rei Dotfiles         │"
echo "│   Powered by bspwm and eww   │"
echo "╰──────────────────────────────╯"

echo "╭───────────────────────────╮"
echo "│ Welcome to Install Script │"
echo "╰───────────────────────────╯"

# Function for installation
install_packages() {
  echo "Installing: $1"
  paru -S --noconfirm --needed "${@:2}"
  echo "Done installing: $1"
}

echo "╭─────────────────────────────╮"
echo "│ Installing Starter Packages │"
echo "╰─────────────────────────────╯"
install_packages "Starter Packages" bspwm sxhkd ranger kitty imagemagick sddm xorg firefox rofi dunst brightnessctl pavucontrol pulseaudio picom feh cava fuse fastfetch cheese zathura zathura-pdf-poppler papirus-folders-catppuccin-git nwg-look zsh task

echo "╭─────────────────────────────╮"
echo "│ Installing EWW Dependencies │"
echo "╰─────────────────────────────╯"
install_packages "EWW Dependencies" jq gtk3 pango gdk-pixbuf2 libdbusmenu-gtk3 cairo glib2 gcc-libs glibc network-manager-applet

echo "╭──────────────────╮"
echo "│ Installing Fonts │"
echo "╰──────────────────╯"
install_packages "Fonts" noto-fonts-emoji noto-fonts-cjk noto-fonts-extra ttf-maplemono ttf-maplemono-nf-unhinted ttf-maplemono-nf-cn-unhinted ttc-iosevka

echo "╭─────────────────────────╮"
echo "│ Installing File Manager │"
echo "╰─────────────────────────╯"
install_packages "Thunar Packages" thunar thunar-volman tumbler ffmpegthumbnailer file-roller thunar-archive-plugin gvfs gvfs-mtp android-tools android-udev mousepad p7zip unrar unzip

echo "╭──────────────────────────────╮"
echo "│ Installing SDDM Dependencies │"
echo "╰──────────────────────────────╯"
install_packages "SDDM Dependencies" qt6-svg qt6-declarative qt5-quickcontrols2

echo "╭────────────────────────────────────────╮"
echo "│ Installing Screenshot and Screenrecord │"
echo "╰────────────────────────────────────────╯"
install_packages "Screenshot Dependencies" maim xclip viewnior ffmpeg

echo "╭────────────────────────────╮"
echo "│ Installing MPD and NCMPCPP │"
echo "╰────────────────────────────╯"
install_packages "MPD and NCMPCPP" mpd ncmpcpp mpc mpv-mpris fum-bin

echo "╭──────────────────────╮"
echo "│ Copying Config Files │"
echo "╰──────────────────────╯"

CONFIG_SOURCE="../Config"
CONFIG_TARGET="$HOME/.config"
BACKUP_DIR="$HOME/Config-Backup-$(date +%Y%m%d_%H%M%S)"

if [ -d "$CONFIG_TARGET" ]; then
  echo "Found existing ~/.config, moving it to backup: $BACKUP_DIR"
  mv "$CONFIG_TARGET" "$BACKUP_DIR"
else
  echo "No existing ~/.config found, no need to backup."
fi

mkdir -p "$CONFIG_TARGET"

echo "Copying new configs from $CONFIG_SOURCE to $CONFIG_TARGET"
cp -r "$CONFIG_SOURCE"/. "$CONFIG_TARGET"

echo "Dotfiles configuration successfully applied!"

echo "╭──────────────────────────────────────────────╮"
echo "│ Installation Process Completed Successfully! │"
echo "╰──────────────────────────────────────────────╯"

echo "╭────────────────────────────╮"
echo "│ Enabling and Starting SDDM │"
echo "╰────────────────────────────╯"

sudo systemctl enable sddm
sudo systemctl start sddm
