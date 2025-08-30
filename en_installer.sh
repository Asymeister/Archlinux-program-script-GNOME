#!/bin/bash

# =============================================================================
# PROGRAM INSTALLER SCRIPT - Arch Linux GNOME (Final Version)
# Version: 1.2.1
# Description: Installs various programs
# =============================================================================

# BASIC ERROR HANDLING
# The script will stop if a command returns an error.
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

# Display a divider
print_divider() {
    echo -e "${CYAN}"
    echo "[================================================================================]"
    echo -e "${RESET}"
}

# Display a title
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

# Information message
print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

# Program installation message
print_install_start() {
    echo -e "${GREEN}🚀 ${BOLD}Installing:${RESET} ${GREEN}$1${RESET}"
}

# Installation function that handles errors and warnings
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

# 1. Check for and install Yay (automatically)
print_info "1. Checking for Yay AUR helper..."
if ! command -v yay &> /dev/null; then
    print_warning "Yay not found, installing automatically..."
    
    print_install_start "Yay AUR helper"
    TMP_DIR=$(mktemp -d)
    if git clone https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"; then
        cd "$TMP_DIR/yay-bin"
        if makepkg -si --noconfirm; then
            print_success "Yay installed successfully!"
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

# 2. Check for and install Flatpak (automatically)
print_info "2. Checking for Flatpak..."
if ! command -v flatpak &> /dev/null; then
    print_warning "Flatpak not found, installing automatically..."
    
    print_install_start "Flatpak"
    if sudo pacman -S --noconfirm flatpak; then
        print_success "Flatpak installed successfully!"
        
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

# 3. Install basic packages (automatically)
print_info "3. Installing basic packages..."
sudo pacman -S --noconfirm base-devel git unzip p7zip zip curl
sudo pacman -S --noconfirm pipewire-pulse pipewire-alsa pipewire-jack wireplumber
sudo pacman -S --noconfirm sassc dkms cabextract calf
print_success "Basic packages installed successfully!"
echo

# 4. Program selection - with ZENITY SELECTION WINDOW
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
    ["Flatseal"]="com.github.tchx84.Flatseal"
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
    --title="Select Programs" \
    --width=900 \
    --height=1000 \
    --column="Select" \
    --column="Program Name" \
    --column="Source" \
    --column="Description" \
    FALSE "Bluetooth" "Pacman" "GNOME Bluetooth toggle" \
    FALSE "Bottles" "Flatpak" "Wine environment for programs and games" \
    FALSE "Corectrl" "Pacman" "ATI and NVIDIA GPU controller" \
    FALSE "Discord" "Flatpak" "Voice and text chat application" \
    FALSE "Double Commander" "Pacman" "Dual-pane file manager (Qt6)" \
    FALSE "EasyEffects" "Pacman" "Audio effects for Pipewire" \
    FALSE "Fastfetch" "Pacman" "System information in the terminal" \
    FALSE "Flatseal" "Flatpak" "Manage permissions for Flatpak applications" \
    FALSE "Gamemode" "Pacman" "Utility to increase game performance" \
    FALSE "Heroic Games Launcher" "Flatpak" "Game launcher for Epic Games and GOG" \
    FALSE "Jellyfin Media Player" "Yay" "Client for the Jellyfin media server" \
    FALSE "KDEConnect" "Pacman" "Connects phone and desktop" \
    FALSE "KeePassXC" "Pacman" "Password manager" \
    FALSE "KVM/QEMU" "Pacman" "Software package for running virtual machines" \
    FALSE "Lutris" "Pacman" "Game launcher for all sources" \
    FALSE "MangoHud/Goverlay" "Pacman" "Performance overlay for games" \
    FALSE "OBS Studio" "Flatpak" "Screen recording and streaming" \
    FALSE "OnlyOffice" "Yay" "Office suite (binary version)" \
    FALSE "Pamac" "Yay" "Graphical package manager" \
    FALSE "Steam" "Pacman" "Game library and launcher" \
    FALSE "Spotify" "Pacman" "Music streaming client" \
    FALSE "VLC" "Flatpak" "Multimedia player" \
    FALSE "Vivaldi" "Pacman" "Versatile web browser" \
    --print-column=2)


# Exit if the user didn't select anything
if [ -z "$CHOICES" ]; then
    print_warning "No programs were selected. The script will exit."
    zenity --info --title="No Selection" --text="No programs were selected. The script will exit." --width=300
    exit 0
fi

# 5. Install programs (with error handling)
print_info "5. Installing selected programs..."
IFS='|' read -ra PROGRAMS <<< "$CHOICES"

# SUMMARY OF SUCCESSFUL/FAILED INSTALLATIONS
declare -a SUCCESSFUL_INSTALLS
declare -a FAILED_INSTALLS

for PROGRAM in "${PROGRAMS[@]}"; do
    print_install_start "$PROGRAM"
    
    INSTALL_SUCCESS=false
    
    # Find the program's source from the package name to be installed
    SOURCE=$(grep -F "$PROGRAM" <<< "$CHOICES" | cut -d'|' -f3)

    case "$PROGRAM" in
        "Bluetooth")
            if install_package "Pacman" "gnome-bluetooth"; then INSTALL_SUCCESS=true; fi
            ;;
        "Bottles")
            if install_package "Flatpak" "com.usebottles.bottles"; then INSTALL_SUCCESS=true; fi
            ;;
        "Corectrl")
            print_install_start "CoreCTRL and user settings"
            
            # Install with pacman
            if sudo pacman -S --noconfirm corectrl; then
                print_success "CoreCTRL installed successfully."
            else
                print_error "Error: CoreCTRL installation failed."
                INSTALL_SUCCESS=false
                continue
            fi

            # Set up autostart
            mkdir -p ~/.config/autostart
            if cp /usr/share/applications/org.corectrl.CoreCtrl.desktop ~/.config/autostart/; then
                print_success "CoreCTRL autostart configured."
            else
                print_warning "Warning: Failed to configure CoreCTRL autostart."
            fi

            # Add Polkit rule
            if echo "polkit.addRule(function(action, subject) {    if ((action.id == \"org.corectrl.helper.init\" ||        action.id == \"org.corectrl.helperkiller.init\") &&        subject.local == true &&        subject.active == true &&        subject.isInGroup(\"$USER\")) {            return polkit.Result.YES;    }});" | sudo tee /etc/polkit-1/rules.d/90-corectrl.rules >/dev/null; then
                print_success "Polkit rule added for user permissions."
            else
                print_error "Error: Failed to add Polkit rule."
                INSTALL_SUCCESS=false
                continue
            fi

            # Modify kernel parameters depending on the bootloader
            if [ -d "/boot/loader/entries" ]; then
                # For systemd-boot
                if sudo sed -i '/options/s/$/ amdgpu.ignore_min_pcap=1 amdgpu.ppfeaturemask=0xffffffff /' /boot/loader/entries/*.conf; then
                    print_success "Kernel parameters modified (systemd-boot)."
                else
                    print_error "Error: Failed to modify kernel parameters."
                    INSTALL_SUCCESS=false
                    continue
                fi
            else
                # For GRUB
                if sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amdgpu.ignore_min_pcap=1 amdgpu.ppfeaturemask=0xffffffff"/' /etc/default/grub; then
                    print_success "Kernel parameters added to GRUB configuration."
                    print_info "Updating GRUB configuration..."
                    if sudo grub-mkconfig -o /boot/grub/grub.cfg; then
                        print_success "GRUB configuration updated successfully."
                    else
                        print_error "Error: Failed to update GRUB configuration."
                        INSTALL_SUCCESS=false
                        continue
                    fi
                else
                    print_error "Error: Failed to modify GRUB configuration file."
                    INSTALL_SUCCESS=false
                    continue
                fi
            fi

            INSTALL_SUCCESS=true
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
        "Flatseal")
            if install_package "Flatpak" "com.github.tchx84.Flatseal"; then INSTALL_SUCCESS=true; fi
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
            print_install_start "Steam and video card optimizations"
            
            # Detect video card
            GPU_TYPE=""
            if lspci | grep -i "nvidia" > /dev/null; then
                GPU_TYPE="nvidia"
                print_info "NVIDIA video card detected"
            elif lspci | grep -i "amd" > /dev/null || lspci | grep -i "radeon" > /dev/null; then
                GPU_TYPE="amd"
                print_info "AMD video card detected"
            elif lspci | grep -i "intel" > /dev/null; then
                GPU_TYPE="intel"
                print_info "Intel integrated video card detected"
            else
                GPU_TYPE="unknown"
                print_warning "Unknown video card, performing basic Steam installation"
            fi

            # Install Steam
            if install_package "Pacman" "steam"; then
                # Install video card-specific packages
                case "$GPU_TYPE" in
                    "nvidia")
                        print_info "Installing NVIDIA drivers and optimizations..."
                        # NVIDIA drivers
                        sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings 2>/dev/null && print_success "NVIDIA drivers installed"
                        
                        # NVIDIA-dkms for kernel compatibility
                        sudo pacman -S --noconfirm nvidia-dkms 2>/dev/null && print_success "NVIDIA DKMS installed"
                        
                        # Vulkan support
                        sudo pacman -S --noconfirm vulkan-icd-loader vulkan-tools 2>/dev/null && print_success "Vulkan support installed"
                        
                        # 32-bit support
                        sudo pacman -S --noconfirm lib32-nvidia-utils lib32-vulkan-icd-loader 2>/dev/null && print_success "32-bit support installed"
                        
                        # Game optimizations
                        sudo pacman -S --noconfirm gamemode lib32-gamemode 2>/dev/null && print_success "Gamemode installed"
                        ;;
                    "amd")
                        print_info "Installing AMD optimizations..."
                        # Vulkan support
                        sudo pacman -S --noconfirm vulkan-radeon vulkan-icd-loader vulkan-tools 2>/dev/null && print_success "Vulkan support installed"
                        
                        # 32-bit support
                        sudo pacman -S --noconfirm lib32-vulkan-icd-loader lib32-vulkan-radeon 2>/dev/null && print_success "32-bit support installed"
                        
                        # Mesa with performance optimizations
                        sudo pacman -S --noconfirm mesa lib32-mesa 2>/dev/null && print_success "Mesa graphics libraries installed"
                        
                        # Game optimizations
                        sudo pacman -S --noconfirm gamemode lib32-gamemode 2>/dev/null && print_success "Gamemode installed"
                        
                        # AMD GPU monitoring tools
                        sudo pacman -S --noconfirm radeontop 2>/dev/null && print_success "RadeonTOP monitoring installed"
                        ;;
                    "intel")
                        print_info "Installing Intel optimizations..."
                        # Vulkan support
                        sudo pacman -S --noconfirm vulkan-intel vulkan-icd-loader vulkan-tools 2>/dev/null && print_success "Vulkan support installed"
                        
                        # 32-bit support
                        sudo pacman -S --noconfirm lib32-vulkan-intel lib32-vulkan-icd-loader 2>/dev/null && print_success "32-bit support installed"
                        
                        # Mesa
                        sudo pacman -S --noconfirm mesa lib32-mesa 2>/dev/null && print_success "Mesa graphics libraries installed"
                        
                        # Game optimizations
                        sudo pacman -S --noconfirm gamemode lib32-gamemode 2>/dev/null && print_success "Gamemode installed"
                        ;;
                    *)
                        print_info "Basic Steam installation for unknown video card..."
                        # Basic Vulkan support
                        sudo pacman -S --noconfirm vulkan-icd-loader vulkan-tools 2>/dev/null
                        sudo pacman -S --noconfirm lib32-vulkan-icd-loader 2>/dev/null
                        ;;
                esac
                
                # General game optimization packages
                print_info "Installing general game optimization packages..."
                sudo pacman -S --noconfirm lib32-systemd lib32-openssl lib32-libpulse 2>/dev/null
                
                # Wine and Proton dependencies
                print_info "Installing Wine and Proton dependencies..."
                sudo pacman -S --noconfirm wine-staging winetricks giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap \
                gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse \
                libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
                sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses \
                opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs 2>/dev/null
                
                # Automatic installation of Proton-GE (latest version)
                print_info "Installing the latest Proton-GE version..."
                PROTON_GE_DIR="$HOME/.steam/root/compatibilitytools.d"
                mkdir -p "$PROTON_GE_DIR"
                
                # Download the latest Proton-GE
                DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest" | grep "browser_download_url.*\.tar\.gz" | head -1 | cut -d '"' -f 4)
                
                if [ -n "$DOWNLOAD_URL" ]; then
                    print_info "Downloading Proton-GE: $(basename "$DOWNLOAD_URL")"
                    
                    if wget -q --show-progress -O "/tmp/proton-ge-latest.tar.gz" "$DOWNLOAD_URL"; then
                        if tar -xzf "/tmp/proton-ge-latest.tar.gz" -C "$PROTON_GE_DIR"; then
                            print_success "Proton-GE installed successfully"
                            # Display extracted folder name
                            EXTRACTED_DIR=$(ls -1 "$PROTON_GE_DIR" | grep "GE-Proton" | head -1)
                            if [ -n "$EXTRACTED_DIR" ]; then
                                print_info "Installed: $EXTRACTED_DIR"
                            fi
                        else
                            print_warning "Proton-GE extraction failed"
                        fi
                        rm -f "/tmp/proton-ge-latest.tar.gz"
                    else
                        print_warning "Proton-GE download failed"
                    fi
                else
                    print_warning "Failed to get Proton-GE download URL"
                fi
                
                # Install ProtonUp-Qt (graphical Proton manager)
                print_info "Installing ProtonUp-Qt (graphical Proton manager)..."
                if command -v flatpak >/dev/null 2>&1; then
                    if flatpak install -y --noninteractive flathub com.vysp3r.ProtonUp 2>/dev/null; then
                        print_success "ProtonUp-Qt installed (Flatpak)"
                    else
                        print_warning "ProtonUp-Qt Flatpak installation failed"
                    fi
                fi
                
                # If flatpak fails or isn't available, try yay
                if command -v yay >/dev/null 2>&1; then
                    if yay -S --noconfirm protonup-qt 2>/dev/null; then
                        print_success "ProtonUp-Qt installed (Yay)"
                    else
                        print_warning "ProtonUp-Qt Yay installation failed"
                    fi
                fi
                
                # Steam configuration guide
                print_info "Steam configuration guide:"
                echo -e "${GREEN}1.${RESET} Start Steam"
                echo -e "${GREEN}2.${RESET} Go to: Settings → Steam Play"
                echo -e "${GREEN}3.${RESET} Enable: 'Enable Steam Play for supported titles'"
                echo -e "${GREEN}4.${RESET} Enable: 'Enable Steam Play for all other titles'"
                echo -e "${GREEN}5.${RESET} Select the desired Proton version"
                echo -e "${GREEN}6.${RESET} Use ProtonUp-Qt to install additional versions"
                
                INSTALL_SUCCESS=true
                print_success "Steam and optimizations installed successfully"
            else
                print_error "Error: Steam installation failed."
                INSTALL_SUCCESS=false
            fi
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
            # Confirmed, robust installation process
            print_install_start "KVM/QEMU and dependencies"
            
            # Install packages in a single line
            if sudo pacman -S --noconfirm qemu virt-manager libvirt edk2-ovmf dnsmasq bridge-utils openbsd-netcat; then
                print_success "KVM/QEMU packages installed successfully."
            else
                print_error "Error: KVM/QEMU package installation failed."
                INSTALL_SUCCESS=false
                continue
            fi

            # Add user to the correct groups
            print_info "Adding user to 'kvm', 'input', and 'libvirt' groups..."
            if sudo usermod -aG kvm,input,libvirt "$USER"; then
                print_success "User successfully added to the required groups."
            else
                print_error "Error: Failed to add user to groups."
                INSTALL_SUCCESS=false
                continue
            fi

            # Modify libvirt configuration file
            print_info "Modifying the '/etc/libvirt/qemu.conf' configuration file..."
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
                print_success "The 'libvirtd' service started successfully."
            else
                print_error "Error: Failed to start the 'libvirtd' service."
                INSTALL_SUCCESS=false
                continue
            fi

            # Set the default network to autostart
            print_info "Enabling autostart for the 'default' virtual network..."
            if sudo virsh net-autostart default; then
                print_success "Autostart for the 'default' network configured."
                INSTALL_SUCCESS=true
            else
                print_error "Error: Failed to set autostart for the 'default' network."
                INSTALL_SUCCESS=false
                continue
            fi
            ;;
    esac
    
    if [ "$INSTALL_SUCCESS" = true ]; then
        print_success "$PROGRAM installed successfully!"
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
    print_success "The following programs were installed successfully:"
    for prog in "${SUCCESSFUL_INSTALLS[@]}"; do
        echo -e "${GREEN}  - $prog${RESET}"
    done
    echo
fi

if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
    print_warning "The following programs failed to install:"
    for prog in "${FAILED_INSTALLS[@]}"; do
        echo -e "${RED}  - $prog${RESET}"
    done
    echo
fi

# Ask about GNOME theme settings (if GNOME is running)
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
    if zenity --question --title="Theme Settings" --text="Would you like to set the system to the dark theme (Adwaita-dark)?\n\nThis setting is recommended for running the following programs:\n- KVM/QEMU\n- Discord\n- OBS Studio" --width=300; then
        print_info "Starting GNOME theme configuration script..."
        if [ -f "gnome_theming.sh" ]; then
            chmod +x gnome_theming.sh
            ./gnome_theming.sh
            print_success "Theme configuration completed successfully."
        else
            print_error "The 'gnome_theming.sh' script was not found. Theme configuration skipped."
        fi
    fi
fi

# ...
# 7. Reboot with a progress bar and cancellation
if zenity --question --title="Reboot" --text="Installation is complete. Would you like to reboot the system now for the changes to take effect?" --width=300; then
    # Progress bar with cancellation
    if zenity --progress --title="Reboot" --text="The system will reboot in 10 seconds..." --percentage=0 --auto-close --timeout=10 < <(
        for i in {0..10}; do
            echo $((i * 10))
            echo "# The system will reboot in $((10 - i)) seconds..."
            sleep 1
        done
    ); then
        # If the progress bar completed successfully (timeout)
        print_info "Rebooting the system..."
        print_divider
        echo -e "${GREEN}${BOLD}The Program Installer script has finished successfully!${RESET}"
        print_divider
        sudo systemctl reboot
    else
        # If the user pressed the Cancel button
        print_warning "Reboot cancelled."
        zenity --info --title="Cancelled" --text="The reboot was cancelled. To apply the changes, log out and then log back in."
    fi
else
    print_info "Reboot skipped."
    zenity --info --title="Installation Complete" --text="The system will not reboot. To apply the changes, log out and then log back in."
fi
