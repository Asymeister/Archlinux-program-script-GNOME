#!/bin/bash

# =============================================================================
# PROGRAM INSTALLER SCRIPT - Arch Linux GNOME(Final Version)
# Version: 1.0
# Description: Program Installation
# =============================================================================

# BASIC ERROR HANDLING
# The script will exit if a command returns an error.
set -eo pipefail

# =============================================================================
# COLORS and FORMATTING
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
ORANGE='\033[38;5;214m'
BOLD='\033[1m'
RESET='\033[0m'

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

# Print separator
print_divider() {
    echo -e "${CYAN}"
    echo "[================================================================================]"
    echo -e "${RESET}"
}

# Print title
print_title() {
    echo -e "${MAGENTA}"
    print_divider
    echo "  $1"
    print_divider
    echo -e "${RESET}"
}

# Success message
print_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

# Error message
print_error() {
    echo -e "${RED}✗${RESET} $1" >&2
}

# Warning message
print_warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

# Info message
print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

# Program installation message
print_install_start() {
    echo -e "${GREEN}🚀 ${BOLD}Installing:${RESET} ${GREEN}$1${RESET}"
}

# Installation function with error handling
install_package() {
    local source=$1
    local package=$2
    local output=""
    local status=1

    case "$source" in
        "Pacman")
            output=$(sudo pacman -S --noconfirm "$package" 2>&1)
            status=$?
            if [ $status -ne 0 ] && (echo "$output" | grep -q "there is nothing to do" || echo "$output" | grep -q "is up to date"); then
                print_warning "$package is already installed!"
                return 0
            elif [ $status -eq 0 ]; then
                return 0
            fi
            ;;
        "Yay")
            output=$(yay -S --noconfirm "$package" 2>&1)
            status=$?
            if [ $status -ne 0 ] && (echo "$output" | grep -q "there is nothing to do" || echo "$output" | grep -q "is up to date"); then
                print_warning "$package is already installed!"
                return 0
            elif [ $status -eq 0 ]; then
                return 0
            fi
            ;;
        "Flatpak")
            if flatpak install -y --noninteractive flathub "$package"; then
                return 0
            fi
            ;;
    esac
    return 1
}

# =============================================================================
# MAIN INSTALLATION PROCESS
# =============================================================================

clear
print_title "PROGRAM INSTALLER - Arch Linux"
print_info "Starting the installation process..."
echo

# 1. Check and install Yay (automatic)
print_info "1. Checking for Yay AUR helper..."
if ! command -v yay &> /dev/null; then
    print_warning "Yay not found, installing automatically..."
    
    print_install_start "Yay AUR helper"
    TMP_DIR=$(mktemp -d)
    if git clone https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"; then
        cd "$TMP_DIR/yay-bin"
        if makepkg -si --noconfirm; then
            print_success "Yay successfully installed!"
        else
            print_error "Error occurred while compiling/installing Yay."
            exit 1
        fi
        cd - > /dev/null
        rm -rf "$TMP_DIR"
    else
        print_error "Error occurred while downloading Yay source."
        rm -rf "$TMP_DIR"
        exit 1
    fi
else
    print_success "Yay is already installed!"
fi
echo

# 2. Check and install Flatpak (automatic)
print_info "2. Checking for Flatpak..."
if ! command -v flatpak &> /dev/null; then
    print_warning "Flatpak not found, installing automatically..."
    
    print_install_start "Flatpak"
    if sudo pacman -S --noconfirm flatpak; then
        print_success "Flatpak successfully installed!"
        
        # Add Flatpak remote
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        print_success "Flathub repository added!"
    else
        print_error "Error occurred while installing Flatpak."
        exit 1
    fi
else
    print_success "Flatpak is already installed!"
fi
echo

# 3. Installing essential packages (automatic)
print_info "3. Installing essential packages..."
sudo pacman -S --noconfirm base-devel git unzip p7zip zip curl
sudo pacman -S --noconfirm pipewire-pulse pipewire-alsa pipewire-jack wireplumber
sudo pacman -S --noconfirm sassc dkms cabextract calf
print_success "Essential packages successfully installed!"
echo

# 4. Program selection - WITH ZENITY SELECTION WINDOW
print_info "4. Selecting programs..."
# Store options separately for easier management
declare -A programs=(
    ["Bluetooth"]="gnome-bluetooth"
    ["Bottles"]="com.usebottles.bottles"
    ["Corectrl"]="corectrl"
    ["Discord"]="com.discordapp.Discord"
    ["Double Commander"]="doublecmd-qt6"
    ["EasyEffects"]="easyeffects"
    ["Fastfetch"]="fastfetch"
    ["Gamemode"]="gamemode"
    ["Heroic Games Launcher"]="com.heroicgameslauncher.hgl"
    ["Jellyfin Media Player"]="jellyfin-media-player"
    ["KDEConnect"]="kdeconnect"
    ["KeePassXC"]="keepassxc"
    ["KVM/QEMU"]="qemu virt-manager libvirt edk2-ovmf dnsmasq bridge-utils openbsd-netcat"
    ["Lutris"]="lutris"
    ["MangoHud/Goverlay"]="mangohud goverlay"
    ["OBS Studio"]="com.obsproject.Studio"
    ["OnlyOffice"]="onlyoffice-bin"
    ["Pamac"]="pamac-aur"
    ["Spotify"]="spotify-launcher"
    ["VLC"]="org.videolan.VLC"
    ["Vivaldi"]="vivaldi"
)

CHOICES=$(zenity --list --checklist \
    --title="Program Selection" \
    --width=900 \
    --height=1100 \
    --column="Mark" \
    --column="Program Name" \
    --column="Source" \
    --column="Description" \
    FALSE "Bluetooth" "Pacman" "GNOME Bluetooth switch" \
    FALSE "Bottles" "Flatpak" "Wine environment for apps and games" \
    FALSE "Corectrl" "Pacman" "ATI and NVIDIA GPU controller" \
    FALSE "Discord" "Flatpak" "Voice and text chat application" \
    FALSE "Double Commander" "Pacman" "Dual-pane file manager (Qt6)" \
    FALSE "EasyEffects" "Pacman" "Sound effects for Pipewire" \
    FALSE "Fastfetch" "Pacman" "System information in the terminal" \
    FALSE "Gamemode" "Pacman" "Game performance-enhancing utility" \
    FALSE "Heroic Games Launcher" "Flatpak" "Game launcher for Epic Games and GOG" \
    FALSE "Jellyfin Media Player" "Yay" "Jellyfin media server client" \
    FALSE "KDEConnect" "Pacman" "Connects phone and desktop" \
    FALSE "KeePassXC" "Pacman" "Password manager" \
    FALSE "KVM/QEMU" "Pacman" "Software package for running virtual machines" \
    FALSE "Lutris" "Pacman" "Game launcher for all sources" \
    FALSE "MangoHud/Goverlay" "Pacman" "Performance overlay for games" \
    FALSE "OBS Studio" "Flatpak" "Screen recording and streaming" \
    FALSE "OnlyOffice" "Yay" "Office suite (binary version)" \
    FALSE "Pamac" "Yay" "Graphical package manager" \
    FALSE "Steam" "Pacman" "Zene-streamelő kliens" \
    FALSE "Spotify" "Pacman" "Music streaming client" \
    FALSE "VLC" "Flatpak" "Multimedia player" \
    FALSE "Vivaldi" "Pacman" "Versatile web browser" \
    --print-column=2)


# Exit if the user did not select anything
if [ -z "$CHOICES" ]; then
    print_warning "No programs were selected. The script will exit."
    zenity --info --title="No Selection" --text="No programs were selected. The script will exit." --width=300
    exit 0
fi

# 5. Installing selected programs (with error handling)
print_info "5. Installing selected programs..."
IFS='|' read -ra PROGRAMS <<< "$CHOICES"

# SUCCESSFUL/FAILED INSTALLATION SUMMARY
declare -a SUCCESSFUL_INSTALLS
declare -a FAILED_INSTALLS

for PROGRAM in "${PROGRAMS[@]}"; do
    print_install_start "$PROGRAM"
    
    INSTALL_SUCCESS=false
    
    # Find the source of the program from the package list
    SOURCE=$(grep -F "$PROGRAM" <<< "$CHOICES" | cut -d'|' -f3)

    case "$PROGRAM" in
        "Bluetooth")
            if install_package "Pacman" "gnome-bluetooth"; then INSTALL_SUCCESS=true; fi
            ;;
        "Bottles")
            if install_package "Flatpak" "com.usebottles.bottles"; then INSTALL_SUCCESS=true; fi
            ;;
        "Corectrl")
            if install_package "Pacman" "corectrl"; then INSTALL_SUCCESS=true; fi
            ;;
        "Discord")
            if install_package "Flatpak" "com.discordapp.Discord"; then INSTALL_SUCCESS=true; fi
            ;;
        "Double Commander")
            if install_package "Pacman" "doublecmd-qt6"; then INSTALL_SUCCESS=true; fi
            ;;
        "EasyEffects")
            if install_package "Pacman" "easyeffects"; then INSTALL_SUCCESS=true; fi
            ;;
        "Fastfetch")
            if install_package "Pacman" "fastfetch"; then INSTALL_SUCCESS=true; fi
            ;;
        "Gamemode")
            if install_package "Pacman" "gamemode"; then INSTALL_SUCCESS=true; fi
            ;;
        "Heroic Games Launcher")
            if install_package "Flatpak" "com.heroicgameslauncher.hgl"; then INSTALL_SUCCESS=true; fi
            ;;
        "Jellyfin Media Player")
            if install_package "Yay" "jellyfin-media-player"; then INSTALL_SUCCESS=true; fi
            ;;
        "KDEConnect")
            if install_package "Pacman" "kdeconnect"; then INSTALL_SUCCESS=true; fi
            ;;
        "KeePassXC")
            if install_package "Pacman" "keepassxc"; then INSTALL_SUCCESS=true; fi
            ;;
        "Lutris")
            if install_package "Pacman" "lutris"; then INSTALL_SUCCESS=true; fi
            ;;
        "MangoHud/Goverlay")
            if install_package "Pacman" "mangohud goverlay"; then INSTALL_SUCCESS=true; fi
            ;;
        "OBS Studio")
            if install_package "Flatpak" "com.obsproject.Studio"; then INSTALL_SUCCESS=true; fi
            ;;
        "OnlyOffice")
            if install_package "Yay" "onlyoffice-bin"; then INSTALL_SUCCESS=true; fi
            ;;
        "Pamac")
            if install_package "Yay" "pamac-aur"; then INSTALL_SUCCESS=true; fi
            ;;
        "Steam")
            if install_package "Pacman" "steam"; then INSTALL_SUCCESS=true; fi
            ;;
        "Spotify")
            if install_package "Pacman" "spotify-launcher"; then INSTALL_SUCCESS=true; fi
            ;;
        "VLC")
            if install_package "Flatpak" "org.videolan.VLC"; then INSTALL_SUCCESS=true; fi
            ;;
        "Vivaldi")
            if install_package "Pacman" "vivaldi"; then INSTALL_SUCCESS=true; fi
            ;;
        "KVM/QEMU")
            # Robust installation process for KVM/QEMU
            print_install_start "KVM/QEMU and dependencies"

            # Install core packages
            if sudo pacman -S --noconfirm qemu virt-manager libvirt edk2-ovmf dnsmasq bridge-utils openbsd-netcat; then
                print_success "KVM/QEMU packages installed successfully."
            else
                print_error "Error: Failed to install KVM/QEMU packages."
                INSTALL_SUCCESS=false
                continue
            fi

            # Add user to the necessary groups
            print_info "Adding user to 'kvm', 'input', and 'libvirt' groups..."
            if sudo usermod -aG kvm,input,libvirt "$USER"; then
                print_success "User added to required groups successfully."
            else
                print_error "Error: Failed to add user to groups."
                INSTALL_SUCCESS=false
                continue
            fi

            # Modify libvirt configuration file
            print_info "Modifying '/etc/libvirt/qemu.conf' configuration file..."
            if sudo sed -i 's/#user = "root"/user = "'"$USER"'"/' /etc/libvirt/qemu.conf &&
               sudo sed -i 's/#group = "root"/group = "kvm"/' /etc/libvirt/qemu.conf; then
                print_success "'qemu.conf' file modified successfully."
            else
                print_error "Error: Failed to modify 'qemu.conf'."
                INSTALL_SUCCESS=false
                continue
            fi

            # Enable and start the libvirtd service
            print_info "Enabling and starting the 'libvirtd' service..."
            if sudo systemctl enable --now libvirtd.service; then
                print_success "'libvirtd' service started successfully."
            else
                print_error "Error: Failed to start the 'libvirtd' service."
                INSTALL_SUCCESS=false
                continue
            fi

            # Set the default network to autostart
            print_info "Enabling 'default' virtual network autostart..."
            if sudo virsh net-autostart default; then
                print_success "'default' network autostart enabled."
                INSTALL_SUCCESS=true
            else
                print_error "Error: Failed to enable 'default' network autostart."
                INSTALL_SUCCESS=false
                continue
            fi
            ;;
    esac
    
    if [ "$INSTALL_SUCCESS" = true ]; then
        print_success "$PROGRAM successfully installed!"
        SUCCESSFUL_INSTALLS+=("$PROGRAM")
    else
        print_error "Error: Installation of '$PROGRAM' failed."
        FAILED_INSTALLS+=("$PROGRAM")
    fi
    echo
    
    sleep 0.5
done

# 6. Final summary
print_title "INSTALLATION COMPLETE"

if [ ${#SUCCESSFUL_INSTALLS[@]} -gt 0 ]; then
    print_success "The following programs were successfully installed:"
    for prog in "${SUCCESSFUL_INSTALLS[@]}"; do
        echo -e "${GREEN}  - $prog${RESET}"
    done
    echo
fi

if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
    print_warning "Installation of the following programs failed:"
    for prog in "${FAILED_INSTALLS[@]}"; do
        echo -e "${RED}  - $prog${RESET}"
    done
    echo
fi

# Ask about GNOME theme settings (if GNOME is running)
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
    if zenity --question --title="Theme Settings" --text="Would you like to set the system to a dark theme (Adwaita-dark)?\n\nThis setting is recommended for the following programs:\n- KVM/QEMU\n- Discord\n- OBS Studio" --width=300; then
        print_info "Starting GNOME theme configuration script..."
        if [ -f "gnome_theming.sh" ]; then
            chmod +x gnome_theming.sh
            ./gnome_theming.sh
            print_success "Theme configuration successfully completed."
        else
            print_error "The 'gnome_theming.sh' script was not found. Theme configuration skipped."
        fi
    fi
fi

# 7. Reboot with a progress bar and cancellation
if zenity --question --title="Reboot" --text="The installation is complete. Would you like to reboot the system now for the changes to take effect?" --width=300; then
    (
        for i in {10..0}; do
            PERCENT=$(( (10 - i) * 10 ))
            echo "$PERCENT"
            echo "# The system will reboot in $i seconds... (Click Cancel to abort)"
            sleep 1
        done
        echo "100"
    ) | zenity --progress --title="Reboot" --text="The system will reboot in 10 seconds..." --percentage=0 --auto-close
    
    if [ $? -eq 0 ]; then
        print_info "Rebooting system..."
        sudo reboot
    else
        print_warning "Reboot aborted."
        zenity --info --title="Aborted" --text="The reboot was aborted. To apply the changes, please log out and log back in."
    fi
else
    print_info "Reboot skipped."
    zenity --info --title="Installation Complete" --text="The system will not reboot. To apply the changes, please log out and log back in."
fi

print_divider
echo -e "${GREEN}${BOLD}The PROGRAM installer script successfully completed!${RESET}"
print_divider
