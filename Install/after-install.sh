#!/bin/bash

set -eu # Stop script if there's an error

echo "╭──────────────────────────────╮"
echo "│         Rei Dotfiles         │"
echo "│   Powered by bspwm and eww   │"
echo "╰──────────────────────────────╯"

echo "╭─────────────────────────────────╮"
echo "│ Welcome to After Install Script │"
echo "╰─────────────────────────────────╯"

# Function for installing packages
install_packages() {
  echo "Installing: $1"
  paru -S --noconfirm --needed "${@:2}"
  echo "Done installing: $1"
}

# Function for installing dependencies
install_dependencies() {
  echo "Installing: $1"
  paru -S --noconfirm --needed --asdeps "${@:2}"
  echo "Done installing: $1"
}

# Function to clone a git repository if it doesn't exist
clone_repo() {
  local name=$1
  local repo_url=$2
  local dest_dir=$3

  if [ ! -d "$dest_dir" ]; then
    echo "Cloning $name..."
    git clone "$repo_url" "$dest_dir"
    echo "Done cloning $name into $dest_dir"
  else
    echo "$name already cloned in $dest_dir"
  fi
}

echo "╭──────────────────────────────╮"
echo "│ Installing Development Tools │"
echo "╰──────────────────────────────╯"
install_packages "Development Tools" joplin neovim lazygit httpie tmux zsh-theme-powerlevel10k-git texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended

echo "╭─────────────╮"
echo "│ Cloning TPM │"
echo "╰─────────────╯"
clone_repo "TPM" "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

echo "╭─────────────────────────╮"
echo "│ Installing Gaming Tools │"
echo "╰─────────────────────────╯"
install_packages "Gaming Tools" lib32-mangohud mangohud wine-staging

echo "╭────────────────────────────────╮"
echo "│ Installing Lutris Dependencies │"
echo "╰────────────────────────────────╯"
install_dependencies "Lutris Dependencies" giflib lib32-giflib gnutls lib32-gnutls v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib sqlite lib32-sqlite libxcomposite lib32-libxcomposite ocl-icd lib32-ocl-icd libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader sdl2-compat lib32-sdl2-compat winetricks

echo "╭──────────────────────╮"
echo "│ Copying Config Files │"
echo "╰──────────────────────╯"

CONFIG_SOURCE="../Home"
CONFIG_TARGET="$HOME"

# Copy
echo "Copying new configs from $CONFIG_SOURCE to $CONFIG_TARGET"
cp -r "$CONFIG_SOURCE"/. "$CONFIG_TARGET"

echo "Dotfiles configuration applied!"

echo "╭────────────────────────────╮"
echo "│ Setting up MPD and NCMPCPP │"
echo "╰────────────────────────────╯"

mkdir -p "$HOME/Music"
touch "$HOME/.mpd/mpd.db" "$HOME/.mpd/mpd.log" "$HOME/.mpd/mpd.pid"

echo "Starting MPD service..."
systemctl --user enable mpd.service
echo "Enabling MPD service..."
systemctl --user start mpd.service

echo "MPD setup completed!"

echo "╭────────────────────────────────────────────────────────────────╮"
echo "│ All packages, dependencies and plugins installed successfully! │"
echo "│                     Enjoy your system!                         │"
echo "╰────────────────────────────────────────────────────────────────╯"
