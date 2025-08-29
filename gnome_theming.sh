#!/bin/bash

# =============================================================================
# GNOME THEME SCRIPT
# Leírás: Automatikusan beállítja a sötét témát a GNOME asztali környezetben
# =============================================================================

# Színek és formázás (a fő scriptből)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Segédfüggvények
print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

print_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

print_error() {
    echo -e "${RED}✗${RESET} $1" >&2
}

# Ellenőrizzük, hogy a GNOME fut-e
if [[ "$XDG_CURRENT_DESKTOP" != "GNOME" ]]; then
    print_warning "Nem GNOME környezet. A téma beállítása kihagyva."
    exit 0
fi

# Elengedhetetlen csomagok telepítése a témaváltáshoz
print_info "A GNOME téma csomagok ellenőrzése és telepítése..."
sudo pacman -S --noconfirm gnome-tweaks gnome-themes-extra gnome-shell-extensions

# Sötét téma beállítása
print_info "A rendszer téma beállítása 'Adwaita-dark'-ra..."

# Globális színséma beállítása (a teljes sötét módhoz)
if gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'; then
    print_success "A globális színséma sikeresen beállítva."
else
    print_error "Hiba: A globális színséma beállítása sikertelen volt."
fi

# Rendszer GTK téma (régebbi alkalmazásokhoz)
if gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'; then
    print_success "GTK téma sikeresen beállítva."
else
    print_error "Hiba: A GTK téma beállítása sikertelen volt."
fi

# Rendszer ikon téma
if gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'; then
    print_success "Ikon téma sikeresen beállítva."
else
    print_error "Hiba: Az ikon téma beállítása sikertelen volt."
fi

# Alapértelmezett alkalmazások téma (ha a felhasználói bővítmény telepítve van)
if gsettings set org.gnome.shell.extensions.user-theme name 'Adwaita-dark'; then
    print_success "Felhasználói téma sikeresen beállítva."
else
    print_warning "Hiba: A felhasználói téma beállítása sikertelen volt. Lehetséges, hogy a bővítmény nem lett megfelelően aktiválva. Az újraindítás segíthet."
fi

print_info "A téma beállítása befejeződött. Lehet, hogy újra be kell jelentkeznie."
