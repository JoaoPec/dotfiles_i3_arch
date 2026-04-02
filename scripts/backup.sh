#!/bin/bash

set -e

BACKUP_DIR="$HOME/dotfiles"
REPO_URL="git@github.com:JoaoPec/dotfiles_i3_arch.git"

while getopts "r:" opt; do
  case $opt in
    r) REPO_URL="$OPTARG" ;;
    *) echo "Usage: $0 -r <git-repo-url>" >&2; exit 1 ;;
  esac
done

if [ -z "$REPO_URL" ]; then
  echo "Usage: $0 -r <git-repo-url>"
  exit 1
fi

echo "Starting backup..."

mkdir -p "$BACKUP_DIR"

backup_dir() {
  local src="$HOME/.config/$1"
  local dest="$BACKUP_DIR/$1"
  if [ -d "$src" ]; then
    rm -rf "$dest"
    cp -r "$src" "$dest"
    echo "Backed up: $1"
  fi
}

backup_file() {
  local src="$HOME/$1"
  local dest="$BACKUP_DIR/$1"
  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    rm -f "$dest"
    cp "$src" "$dest"
    echo "Backed up: $1"
  fi
}

backup_dir "nvim"
backup_dir "i3"
backup_dir "kitty"
backup_dir "rofi"
backup_dir "picom"
backup_dir "i3status"
backup_dir "opencode"
backup_file ".zshrc"
backup_file ".bashrc"
backup_file "scripts/backup.sh"

echo "Exporting installed packages..."

pacman -Qqe > "$BACKUP_DIR/packages_pacman.txt"
echo "Backed up: packages_pacman.txt"

if command -v paru &> /dev/null; then
  pacman -Qqm > "$BACKUP_DIR/packages_aur.txt"
  echo "Backed up: packages_aur.txt"
fi

cat > "$BACKUP_DIR/install.sh" << 'INSTALLSCRIPT'
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
INSTALLSCRIPT
chmod +x "$BACKUP_DIR/install.sh"
echo "Backed up: install.sh"

cd "$BACKUP_DIR"

if [ ! -d ".git" ]; then
  echo "Initializing git repo..."
  git init
  git remote add origin "$REPO_URL"
fi

git add -A
git commit -m "Backup $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
git push -u origin main --force

echo "Backup complete!"
