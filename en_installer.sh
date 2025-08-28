#!/bin/bash

# The English installer script

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if Yay and Flatpak are installed
if ! command -v yay &> /dev/null
then
    zenity --info --title="Information" --text="The Yay AUR helper needs to be installed. Continuing..."
    sudo pacman -S --noconfirm yay-bin
fi

if ! command -v flatpak &> /dev/null
then
    zenity --info --title="Information" --text="Flatpak needs to be installed. Continuing..."
    sudo pacman -S --noconfirm flatpak
fi

# Install dependencies and essential packages
zenity --info --title="Dependencies" --text="Starting the installation of essential packages. This is handled automatically by the script."
sudo pacman -S --noconfirm \
    base-devel \
    git \
    unzip \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    wireplumber \
    p7zip \
    zip \
    sassc \
    dkms \
    curl \
    cabextract
    

# Show Zenity window for program selection
CHOICES=$(zenity --list --checklist \
    --title="Installer" \
    --width=800 \
    --height=600 \
    --column="Select" \
    --column="Program name" \
    --column="Source" \
    --column="Description" \
    FALSE "Bluetooth" "Pacman" "GNOME Bluetooth toggle" \
    FALSE "Bottles" "Pacman" "Wine environment for apps and games" \
    FALSE "Corectrl" "Pacman" "ATI and NVIDIA GPU control" \
    FALSE "Discord" "Flatpak" "Voice and text chat application" \
    FALSE "Double commander-qt6" "Pacman" "Two-pane file manager" \
    FALSE "EasyEffects" "Pacman" "Audio effects for Pipewire" \
    FALSE "Fastfetch" "Pacman" "System information in the terminal" \
    FALSE "Gamemode" "Pacman" "A performance optimization tool for games" \
    FALSE "Heroic Games Launcher" "Flatpak" "Game launcher for Epic Games and GOG" \
    FALSE "Jellyfin Media Player" "Yay" "Client for the Jellyfin media server" \
    FALSE "KDEConnect" "Pacman" "Connects phone and desktop" \
    FALSE "KeePassXC" "Pacman" "Password manager" \
    FALSE "Lutris" "Pacman" "Game launcher for all sources" \
    FALSE "MangoHud/Goverlay" "Pacman" "Performance overlay for games" \
    FALSE "OBS" "Flatpak" "Screen capture and streaming" \
    FALSE "OnlyOffice" "Yay" "Office suite (binary version)" \
    FALSE "Pamac" "Yay" "Graphical package manager" \
    FALSE "Spotify" "Pacman" "Music streaming client" \
    FALSE "VLC" "Flatpak" "Multimedia player" \
    FALSE "Vivaldi" "Pacman" "Feature-rich web browser" \
)

# Process user's selection
IFS='|' read -ra PROGRAMS <<< "$CHOICES"

for PROGRAM in "${PROGRAMS[@]}"; do
    case "$PROGRAM" in
        "Bluetooth")
            sudo pacman -S --noconfirm gnome-bluetooth
            ;;
        "Bottles")
            flatpak install flathub com.usebottles.bottles --noninteractive
            ;;
        "Corectrl")
            sudo pacman -S --noconfirm corectrl
            ;;
        "Discord") 
            flatpak install flathub com.discordapp.Discord --noninteractive
            ;;
        "Double commander-qt6")
            sudo pacman -S --noconfirm doublecmd-qt6
            ;;
        "EasyEffects")
            sudo pacman -S easyeffects lsp-plugins-lv2 lsp-plugins-standalone --noconfirm
            ;;
        "Fastfetch")
            sudo pacman -S --noconfirm fastfetch
            ;;
        "Gamemode")
            sudo pacman -S --noconfirm gamemode
            ;;
        "Heroic Games Launcher")
            flatpak install flathub com.heroicgameslauncher.hgl --noninteractive
            ;;
        "Jellyfin Media Player")
            yay -S --noconfirm jellyfin-media-player
            ;;
        "KDEConnect")
            sudo pacman -S --noconfirm kdeconnect
            ;;
        "KeePassXC")
            sudo pacman -S --noconfirm keepassxc
            ;;
        "Lutris")
            sudo pacman -S --noconfirm lutris
            ;;
        "MangoHud/Goverlay")
            sudo pacman -S --noconfirm mangohud goverlay
            ;;
        "OBS")
            flatpak install flathub com.obsproject.Studio --noninteractive
            ;;
        "OnlyOffice")
            yay -S --noconfirm onlyoffice-bin
            ;;
        "Pamac")
            yay -S --noconfirm pamac-aur
            ;;
        "Spotify")
            sudo pacman -S --noconfirm spotify-launcher
            ;;
        "VLC")
            flatpak install flathub org.videolan.VLC --noninteractive
            ;;
        "Vivaldi")
            sudo pacman -S --noconfirm vivaldi
            ;;
    esac
done

zenity --info --title="Installation Complete" --text="The installation process has finished successfully."

# Ask the user about rebooting
if zenity --question --title="Reboot Required" --text="The installation is complete. Do you want to reboot now?" --ok-label="Yes" --cancel-label="No" --no-wrap
then
    (
    TIME_TO_REBOOT=10
    for (( i=$TIME_TO_REBOOT; i>=0; i-- )); do
        PERCENTAGE=$(( ($TIME_TO_REBOOT - $i) * 100 / $TIME_TO_REBOOT ))
        echo $PERCENTAGE
        echo "# The system will reboot in $i seconds... (Click Cancel to stop)"
        sleep 1
    done
    ) | zenity --progress --title="Rebooting" --text="The system will reboot in 10 seconds..." --auto-close
    
    if [ $? -eq 0 ]; then
        sudo reboot
    else
        zenity --info --title="Cancelled" --text="The reboot has been cancelled. Log out and log back in for changes to take effect."
    fi
else
    zenity --info --title="Installation Complete" --text="The system will not reboot. Log out and log back in for changes to take effect."
fi
