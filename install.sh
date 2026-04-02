#!/bin/bash
set -e

echo "Installing packages..."

if [ -f "packages_pacman.txt" ]; then
  echo "Installing pacman packages..."
  sudo pacman -S --needed - < packages_pacman.txt
fi

if [ -f "packages_aur.txt" ]; then
  if ! command -v paru &> /dev/null; then
    echo "Installing paru first..."
    sudo pacman -S --needed base-devel
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ~
  fi
  echo "Installing AUR packages..."
  paru -S --needed - < packages_aur.txt
fi

echo "Done!"
