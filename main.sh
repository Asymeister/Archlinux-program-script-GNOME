#!/bin/bash

# =============================================================================
# PROGRAM INSTALLER SCRIPT - Arch Linux
# PROGRAM TELEPÍTŐ SCRIPT - Arch Linux
# Verzió: 1.2 (Végső verzió)
# Version: 1.2 (Final version)
# Leírás: Program telepítő előjárója (Linux-header telepítése + programok + sötét téma beállítása)
# Description: Program installer forerunner (install Linux header + programs + set dark theme)
# =============================================================================

# Kéri a jelszót a sudo jogosultságokhoz, és életben tartja azokat
# Asks for password for sudo privileges and keeps them alive
sudo -v

# Kilépés, ha bármelyik parancs hibát eredményez
# Exit if any command fails
set -euo pipefail # Strict mode

# =============================================================================
# SZÍNEK és FORMÁZÁS
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
# SEGÉDFÜGGVÉNYEK
# HELPER FUNCTIONS
# =============================================================================

# Információs üzenet
# Info message
print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

# Siker üzenet
# Success message
print_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

# Hiba üzenet
# Error message
print_error() {
    echo -e "${RED}✗${RESET} $1" >&2
}

# Verzió összehasonlító függvény
# Version comparison function
version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# =============================================================================
# VERZIÓELLENŐRZÉS
# VERSION CHECK
# =============================================================================

CURRENT_VERSION="1.2"
GITHUB_REPO="https://raw.githubusercontent.com/username/repo/main" # Cseréld ki a valós GitHub repódra
# Replace with your actual GitHub repo
SCRIPT_NAME="main.sh"

print_info "Verzió ellenőrzése..."
# Checking version...
LATEST_VERSION=$(curl -s "$GITHUB_REPO/version.txt")

if [[ -z "$LATEST_VERSION" ]]; then
    print_error "Nem sikerült lekérni a legújabb verziószámot. A szkript tovább fut."
    # Failed to get the latest version number. The script will continue to run.
else
    # A verziószámok összehasonlítása sort -V segítségével
    # Compare version numbers using sort -V
    if version_gt "$CURRENT_VERSION" "$LATEST_VERSION"; then
        if zenity --question --title="Frissítés elérhető" --text="Új verzió érhető el ($LATEST_VERSION). Szeretné letölteni és futtatni?" --width=300; then
        # Update available. A new version is available ($LATEST_VERSION). Do you want to download and run it?
            print_info "Frissítés letöltése..."
            # Downloading update...
            if curl -s -o "$SCRIPT_NAME" "$GITHUB_REPO/$SCRIPT_NAME"; then
                print_success "Sikeresen frissítve! Újraindítás..."
                # Successfully updated! Restarting...
                exec bash "$SCRIPT_NAME"
            else
                print_error "Hiba: Nem sikerült letölteni a frissítést. A szkript a régi verzióval folytatódik."
                # Error: Failed to download the update. The script will continue with the old version.
            fi
        else
            print_info "A frissítés megszakítva. A szkript a régi verzióval fut tovább."
            # Update aborted. The script will continue with the old version.
        fi
    else
        print_info "A szkript naprakész."
        # The script is up to date.
    fi
fi

# =============================================================================
# FŐ LOGIKA
# MAIN LOGIC
# =============================================================================

kernel_version=$(uname -r || echo "")
kernel_header_package="linux-headers"

if [[ -z "$kernel_version" ]]; then
    print_error "Hiba: Nem sikerült meghatározni a kernel verzióját!"
    # Error: Failed to determine kernel version!
    exit 1
fi

case "$kernel_version" in
    *hardened*)
        kernel_header_package="linux-hardened-headers"
        echo "Hardened kernel észlelve." ;;
        # Hardened kernel detected.
    *lts*)
        kernel_header_package="linux-lts-headers"
        echo "LTS kernel észlelve." ;;
        # LTS kernel detected.
    *zen*)
        kernel_header_package="linux-zen-headers"
        echo "Zen kernel észlelve." ;;
        # Zen kernel detected.
    *)
        kernel_header_package="linux-headers"
        echo "Standard kernel észlelve." ;;
        # Standard kernel detected.
esac

echo "Észlelt kernel: $kernel_version"
# Detected kernel: $kernel_version
echo "Használt header csomag: $kernel_header_package"
# Used header package: $kernel_header_package

if [[ ! -f /etc/os-release ]]; then
    print_error "Hiba: A disztribúció nem meghatározható!"
    # Error: The distribution could not be determined!
    exit 1
fi

. /etc/os-release

if [[ "$ID" != "arch" ]]; then
    print_error "Hiba: Nem támogatott disztribúció: $ID"
    # Error: Unsupported distribution: $ID
    exit 1
fi

if ! pacman -Q "$kernel_header_package" &>/dev/null; then
    print_info "A kernel headerek telepítése..."
    # Installing kernel headers...
    sudo pacman -Syu --noconfirm "$kernel_header_package"
    print_success "A $kernel_header_package csomag sikeresen telepítve a $kernel_version kernelhez."
    # The $kernel_header_package package has been successfully installed for the $kernel_version kernel.
else
    print_info "A $kernel_header_package csomag már telepítve van."
    # The $kernel_header_package package is already installed.
fi

# =============================================================================
# TOVÁBBI PROGRAMOK TELEPÍTÉSE
# INSTALLING ADDITIONAL PROGRAMS
# =============================================================================

if [ ! -f "hu_installer.sh" ] || [ ! -f "en_installer.sh" ]; then
    zenity --error \
        --title="Hiba: Hiányzó fájlok" \
        --text="A telepítőfájlok (hu_installer.sh és en_installer.sh) hiányoznak a jelenlegi könyvtárból.\n\nKérlek, helyezd őket a main.sh mellé, majd próbáld újra."
    # Error: Missing files. The installation files (hu_installer.sh and en_installer.sh) are missing from the current directory. Please place them next to main.sh and try again.
    exit 1
fi

chmod +x hu_installer.sh en_installer.sh

print_info "A Zenity telepítése ---"
# Installing Zenity ---

if ! command -v zenity &> /dev/null; then
    sudo pacman -S --noconfirm zenity
fi

LANGUAGE=$(zenity --list --radiolist --title="Nyelvválasztás" --text="Válassza ki a telepítő nyelvét:" --column="Választás" --column="Nyelv" TRUE "Hungarian" FALSE "English")

if [[ "$LANGUAGE" == "Magyar" ]]; then
    ./hu_installer.sh
elif [[ "$LANGUAGE" == "English" ]]; then
    ./en_installer.sh
else
    zenity --error --title="Hiba" --text="Érvénytelen választás. A program leáll."
    exit 1
fi
