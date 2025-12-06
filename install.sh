#!/bin/bash

exec_as_root() {
  if [ "$(id -u)" -ne 0 ]; then
      exec su -c "$*"
  else
      eval "$*"
  fi
}

if [ "$(id -u)" -eq 0 ]; then
  echo "Do not run this script as root."
  exit 1
fi

#
# Install packages
#
packages=""

# Install fonts.
packages+="noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-hack ttf-cascadia-code "

# Wayland.
packages+="wayland wayland-protocols "

# Wayland utilities.
packages+="wlroots0.17 python-pywlroots wl-clipboard xorg-xwayland xdg-desktop-portal xdg-desktop-portal-hyprland "

# Install Hyprland wm, lock screen, screen shot, status bar tools and notification daemon.
packages+="hyprland hyprlock hyprshot waybar swaync "

# Applications launcher.
packages+="wofi "

# Shell
packages+="zsh zoxide"

# Terminal emulator, terminal multiplexer and other terminal-related applications.
packages+="alacritty tmux "

# Terminal file editor and a few required packages for optional features.
packages+="neovim fzf ripgrep "

# Audio packages.
packages+="libpipewire pipewire pipewire-pulse pipewire-audio pipewire-session-manager pavucontrol "

# Compiling and programmming tools.
packages+="gcc arm-none-eabi-gcc arm-none-eabi-newlib clang ninja doxygen cmake make gdb valgrind openocd "

# Install additional useful packages.
packages+="firefox htop gnome-keyring man-db vlc git libreoffice greetd tree stow "
extra_packages="bitwarden nemo "

while :; do
    echo "Do you want to install the following additional packages?"
    echo "$extra_packages"
    echo ""
    read -p "[y/n]? " -n 1 -r ans
    case "$ans" in
        y|Y)
          packages+=extra_packages
          break 
          ;;
        n|N) break ;;
    esac
done

# Dark GTK theme.
packages+="adw-gtk-theme "

exec_as_root "pacman -S $packages"


#
# UI graphics-related stuff.
#

# Sets the dark theme.
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Creates the resource directory.
mkdir dotresources

# Download relevant resources.
wget https://img.icons8.com/color/48/arch-linux.png
mv arch-linux.png dotresources/.

# Download wallpapers.
git clone https://github.com/mylinuxforwork/wallpaper.git dotresources/wallpaper

# Restores dconf configuration.
if [ -e "dconf-settings.conf" ]; then
  dconf load / < dconf-settings.conf
fi


#
# System configuration.
#

# Creates symlink for any dotfile in this directory into the parent.
stow .

# Sets the login shell.
chsh -s /usr/bin/zsh

# Enables autologin on boot.
exec_as_root "echo -e \"\n[initial_session]\ncommand = \"hyprland\"\nuser = \"$user\"\n\" >> /etc/greetd/config.toml"

# Enables greet daemon.
exec_as_root "systemctl enable greetd"

# Sets `swappy` as default application for a few image formats.
xdg-mime default swappy.desktop image/png
xdg-mime default swappy.desktop image/jpg
xdg-mime default swappy.desktop image/webp

# Sets `vlc` as default application for a few video formats.
xdg-mime default vlc.desktop video/mp4
xdg-mime default vlc.desktop video/mpeg
xdg-mime default vlc.desktop video/ogg

# Same thing but for audio formats.
xdg-mime default vlc.desktop audio/mp3
xdg-mime default vlc.desktop audio/aac
xdg-mime default vlc.desktop audio/mpeg
xdg-mime default vlc.desktop audio/ogg
xdg-mime default vlc.desktop audio/webm

#
# Applications-specific configuration.
#

# Saves the current nvim configuration, if present.
if [ -e "~/.local/share/nvim" ]; then
  mv "~/.local/share/nvim" "~/.local/share/nvim.old"
fi

# Starts a nvim instance.
nvim --headless &

# Wait until the nvim server is ready.
while ! ls $XDG_RUNTIME_DIR/nvim.* &> /dev/null; do
  sleep .25
done

for server in $XDG_RUNTIME_DIR/nvim.*; do 
  # `--remote-expr` is a blocking call.
  nvim --server "$server" --remote-expr 'execute("lua Setup_LazySync()")' > /dev/null
  nvim --server "$server" --remote-expr 'execute("lua Setup_MasonInstall()")' > /dev/null
  nvim --server "$server" --remote-send ':qa!<CR>'
done

# Patches import error due to `cmake_language_server` not being maintained anymore.
sed -i "s/from pygls.server/from pygls.lsp.server/g" ~/.local/share/nvim/mason/packages/cmake-language-server/venv/lib/python3.13/site-packages/cmake_language_server/server.py


#
# End.
#

echo "Configuration complete"
read -p "Do you want to reboot now (Recommended)? " -n 1 -r
if [[ "$REPLY" =~ ^[Yy]$ ]]
then
  echo -e "\nRebooting"
  reboot
fi
echo ""
