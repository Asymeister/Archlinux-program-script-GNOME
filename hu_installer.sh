#!/bin/bash

# =============================================================================
# PROGRAM INSTALLER SCRIPT - Arch Linux GNOME (Végleges verzió)
# Verzió: 1.0
# Leírás: Programok telepítése
# =============================================================================

# ALAPVETŐ HIBAKEZELÉS
# A szkript leáll, ha egy parancs hibát ad vissza.
set -eo pipefail

# =============================================================================
# SZÍNEK és FORMÁZÁS
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
# =============================================================================

# Elválasztó megjelenítése
print_divider() {
    echo -e "${CYAN}"
    echo "[================================================================================]"
    echo -e "${RESET}"
}

# Cím megjelenítése
print_title() {
    echo -e "${MAGENTA}"
    print_divider
    echo "  $1"
    print_divider
    echo -e "${RESET}"
}

# Siker üzenet
print_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

# Hiba üzenet
print_error() {
    echo -e "${RED}✗${RESET} $1" >&2
}

# Figyelmeztetés üzenet
print_warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

# Információs üzenet
print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

# Program telepítési üzenet
print_install_start() {
    echo -e "${GREEN}🚀 ${BOLD}Telepítés:${RESET} ${GREEN}$1${RESET}"
}

# Telepítési függvény, amely kezeli a hibákat és a figyelmeztetéseket
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
                print_warning "$package már telepítve van!"
                return 0
            elif [ $status -eq 0 ]; then
                return 0
            fi
            ;;
        "Yay")
            output=$(yay -S --noconfirm "$package" 2>&1)
            status=$?
            if [ $status -ne 0 ] && (echo "$output" | grep -q "there is nothing to do" || echo "$output" | grep -q "is up to date"); then
                print_warning "$package már telepítve van!"
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
# FŐ TELEPÍTÉSI FOLYAMAT
# =============================================================================

clear
print_title "PROGRAM TELEPÍTŐ - Arch Linux"
print_info "Kezdődik a telepítési folyamat..."
echo

# 1. Yay ellenőrzése és telepítése (automatikus)
print_info "1. Yay AUR helper ellenőrzése..."
if ! command -v yay &> /dev/null; then
    print_warning "Yay nem található, automatikus telepítés..."
    
    print_install_start "Yay AUR helper"
    TMP_DIR=$(mktemp -d)
    if git clone https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"; then
        cd "$TMP_DIR/yay-bin"
        if makepkg -si --noconfirm; then
            print_success "Yay sikeresen telepítve!"
        else
            print_error "Hiba történt a Yay fordításakor/telepítésekor."
            exit 1
        fi
        cd - > /dev/null
        rm -rf "$TMP_DIR"
    else
        print_error "Hiba történt a Yay forrás letöltésekor."
        rm -rf "$TMP_DIR"
        exit 1
    fi
else
    print_success "Yay már telepítve van!"
fi
echo

# 2. Flatpak ellenőrzése és telepítése (automatikus)
print_info "2. Flatpak ellenőrzése..."
if ! command -v flatpak &> /dev/null; then
    print_warning "Flatpak nem található, automatikus telepítés..."
    
    print_install_start "Flatpak"
    if sudo pacman -S --noconfirm flatpak; then
        print_success "Flatpak sikeresen telepítve!"
        
        # Flatpak remote hozzáadása
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        print_success "Flathub repository hozzáadva!"
    else
        print_error "Hiba történt a Flatpak telepítésekor."
        exit 1
    fi
else
    print_success "Flatpak már telepítve van!"
fi
echo

# 3. Alapvető csomagok telepítése (automatikus)
print_info "3. Alapvető csomagok telepítése..."
sudo pacman -S --noconfirm base-devel git unzip p7zip zip curl
sudo pacman -S --noconfirm pipewire-pulse pipewire-alsa pipewire-jack wireplumber
sudo pacman -S --noconfirm sassc dkms cabextract calf
print_success "Alapvető csomagok sikeresen telepítve!"
echo

# 4. Programok kiválasztása - ZENITY VÁLASZTÓABLAKKAL
print_info "4. Programok kiválasztása..."
# Az opciók külön tárolása a könnyebb kezelhetőség érdekében
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
    --title="Programok kiválasztása" \
    --width=900 \
    --height=1100 \
    --column="Jelölés" \
    --column="Program neve" \
    --column="Forrás" \
    --column="Leírás" \
    FALSE "Bluetooth" "Pacman" "GNOME Bluetooth kapcsoló" \
    FALSE "Bottles" "Flatpak" "Wine környezet programokhoz és játékokhoz" \
    FALSE "Corectrl" "Pacman" "ATI és NVIDIA GPU vezérlő" \
    FALSE "Discord" "Flatpak" "Hang- és szöveges csevegőalkalmazás" \
    FALSE "Double Commander" "Pacman" "Kéttáblás fájlkezelő (Qt6)" \
    FALSE "EasyEffects" "Pacman" "Hang effektek a Pipewire-hez" \
    FALSE "Fastfetch" "Pacman" "Rendszerinformációk terminálban" \
    FALSE "Gamemode" "Pacman" "Játékok teljesítményét növelő segédprogram" \
    FALSE "Heroic Games Launcher" "Flatpak" "Játékindító Epic Games és GOG-hoz" \
    FALSE "Jellyfin Media Player" "Yay" "Jellyfin médiakiszolgáló kliense" \
    FALSE "KDEConnect" "Pacman" "Telefon és asztali számítógép összekötése" \
    FALSE "KeePassXC" "Pacman" "Jelszókezelő" \
    FALSE "KVM/QEMU" "Pacman" "Virtuális gépek futtatására szolgáló szoftvercsomag" \
    FALSE "Lutris" "Pacman" "Játékindító az összes forráshoz" \
    FALSE "MangoHud/Goverlay" "Pacman" "Teljesítmény-kijelző játékokhoz" \
    FALSE "OBS Studio" "Flatpak" "Képernyőfelvétel és streamelés" \
    FALSE "OnlyOffice" "Yay" "Irodai programcsomag (bináris verzió)" \
    FALSE "Pamac" "Yay" "Grafikus csomagkezelő" \
    FALSE "Steam" "Pacman" "Zene-streamelő kliens" \
    FALSE "Spotify" "Pacman" "Zene-streamelő kliens" \
    FALSE "VLC" "Flatpak" "Multimédiás lejátszó" \
    FALSE "Vivaldi" "Pacman" "Sokoldalú webböngésző" \
    --print-column=2)


# Kilépés, ha a felhasználó nem választott semmit
if [ -z "$CHOICES" ]; then
    print_warning "Nem választott programot. A script leáll."
    zenity --info --title="Nincs kiválasztás" --text="Nem választott programot. A script leáll." --width=300
    exit 0
fi

# 5. Programok telepítése (hibakezeléssel)
print_info "5. Kiválasztott programok telepítése..."
IFS='|' read -ra PROGRAMS <<< "$CHOICES"

# SIKERES/SIKERTELEN TELEPÍTÉS ÖSSZEFOGLALÓ
declare -a SUCCESSFUL_INSTALLS
declare -a FAILED_INSTALLS

for PROGRAM in "${PROGRAMS[@]}"; do
    print_install_start "$PROGRAM"
    
    INSTALL_SUCCESS=false
    
    # Keresd meg a program forrását a telepítendő csomag nevéből
    SOURCE=$(grep -F "$PROGRAM" <<< "$CHOICES" | cut -d'|' -f3)

    case "$PROGRAM" in
        "Bluetooth")
            if install_package "Pacman" "gnome-bluetooth"; then INSTALL_SUCCESS=true; fi
            ;;
        "Bottles")
            if install_package "Flatpak" "com.usebottles.bottles"; then INSTALL_SUCCESS=true; fi
            ;;
        "Corectrl")
	    print_install_start "CoreCTRL és felhasználói beállítások"
	    
	    # Telepítés pacman-nal
	    if sudo pacman -S --noconfirm corectrl; then
		print_success "CoreCTRL sikeresen telepítve."
	    else
		print_error "Hiba: A CoreCTRL telepítése sikertelen volt."
		INSTALL_SUCCESS=false
		continue
	    fi

	    # Autostart beállítása
	    mkdir -p ~/.config/autostart
	    if cp /usr/share/applications/org.corectrl.CoreCtrl.desktop ~/.config/autostart/; then
		print_success "CoreCTRL autostart beállítva."
	    else
		print_warning "Figyelem: A CoreCTRL autostart beállítása sikertelen volt."
	    fi

	    # Polkit szabály hozzáadása
	    if echo "polkit.addRule(function(action, subject) {    if ((action.id == \"org.corectrl.helper.init\" ||         action.id == \"org.corectrl.helperkiller.init\") &&        subject.local == true &&        subject.active == true &&        subject.isInGroup(\"$USER\")) {            return polkit.Result.YES;    }});" | sudo tee /etc/polkit-1/rules.d/90-corectrl.rules >/dev/null; then
		print_success "Polkit szabály hozzáadva a felhasználói jogosultságokhoz."
	    else
		print_error "Hiba: A Polkit szabály hozzáadása sikertelen volt."
		INSTALL_SUCCESS=false
		continue
	    fi

	    # Kernel paraméterek módosítása a bootloader-től függően
	    if [ -d "/boot/loader/entries" ]; then
		# systemd-boot esetén
		if sudo sed -i '/options/s/$/ amdgpu.ignore_min_pcap=1 amdgpu.ppfeaturemask=0xffffffff /' /boot/loader/entries/*.conf; then
		    print_success "Kernel paraméterek módosítva (systemd-boot)."
		else
		    print_error "Hiba: A kernel paraméterek módosítása sikertelen volt."
		    INSTALL_SUCCESS=false
		    continue
		fi
	    else
		# GRUB esetén
		if sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amdgpu.ignore_min_pcap=1 amdgpu.ppfeaturemask=0xffffffff"/' /etc/default/grub; then
		    print_success "Kernel paraméterek hozzáadva a GRUB konfigurációhoz."
		    print_info "GRUB konfiguráció frissítése..."
		    if sudo grub-mkconfig -o /boot/grub/grub.cfg; then
		        print_success "GRUB konfiguráció sikeresen frissítve."
		    else
		        print_error "Hiba: A GRUB konfiguráció frissítése sikertelen volt."
		        INSTALL_SUCCESS=false
		        continue
		    fi
		else
		    print_error "Hiba: A GRUB konfigurációs fájl módosítása sikertelen volt."
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
            # Megerősített, robusztus telepítési folyamat
            print_install_start "KVM/QEMU és függőségei"
            
            # Csomagok telepítése egyetlen sorban
            if sudo pacman -S --noconfirm qemu virt-manager libvirt edk2-ovmf dnsmasq bridge-utils openbsd-netcat; then
                print_success "A KVM/QEMU csomagok sikeresen telepítve."
            else
                print_error "Hiba: A KVM/QEMU csomagok telepítése sikertelen volt."
                INSTALL_SUCCESS=false
                continue
            fi

            # Felhasználó hozzáadása a megfelelő csoportokhoz
            print_info "Felhasználó hozzáadása a 'kvm', 'input', és 'libvirt' csoportokhoz..."
            if sudo usermod -aG kvm,input,libvirt "$USER"; then
                print_success "A felhasználó sikeresen hozzáadva a szükséges csoportokhoz."
            else
                print_error "Hiba: Nem sikerült hozzáadni a felhasználót a csoportokhoz."
                INSTALL_SUCCESS=false
                continue
            fi

            # libvirt konfigurációs fájl módosítása
            print_info "A '/etc/libvirt/qemu.conf' konfigurációs fájl módosítása..."
            if sudo sed -i 's/#user = "root"/user = "'"$USER"'"/' /etc/libvirt/qemu.conf &&
               sudo sed -i 's/#group = "root"/group = "kvm"/' /etc/libvirt/qemu.conf; then
                print_success "A 'qemu.conf' fájl sikeresen módosítva."
            else
                print_error "Hiba: A 'qemu.conf' módosítása sikertelen volt."
                INSTALL_SUCCESS=false
                continue
            fi

            # A libvirtd szolgáltatás engedélyezése és elindítása
            print_info "A 'libvirtd' szolgáltatás engedélyezése és elindítása..."
            if sudo systemctl enable --now libvirtd.service; then
                print_success "A 'libvirtd' szolgáltatás sikeresen elindult."
            else
                print_error "Hiba: Nem sikerült elindítani a 'libvirtd' szolgáltatást."
                INSTALL_SUCCESS=false
                continue
            fi

            # A default hálózat automatikus indításának beállítása
            print_info "A 'default' virtuális hálózat automatikus indításának engedélyezése..."
            if sudo virsh net-autostart default; then
                print_success "A 'default' hálózat automatikus indítása beállítva."
                INSTALL_SUCCESS=true
            else
                print_error "Hiba: Nem sikerült beállítani a 'default' hálózat automatikus indítását."
                INSTALL_SUCCESS=false
                continue
            fi
            ;;
    esac
    
    if [ "$INSTALL_SUCCESS" = true ]; then
        print_success "$PROGRAM sikeresen telepítve!"
        SUCCESSFUL_INSTALLS+=("$PROGRAM")
    else
        print_error "Hiba: A '$PROGRAM' telepítése sikertelen volt."
        FAILED_INSTALLS+=("$PROGRAM")
    fi
    echo
    
    sleep 0.5
done

# 6. Végső összefoglaló
print_title "TELEPÍTÉS BEFEJEZVE"

if [ ${#SUCCESSFUL_INSTALLS[@]} -gt 0 ]; then
    print_success "Az alábbi programok sikeresen telepítve:"
    for prog in "${SUCCESSFUL_INSTALLS[@]}"; do
        echo -e "${GREEN}  - $prog${RESET}"
    done
    echo
fi

if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
    print_warning "Az alábbi programok telepítése sikertelen volt:"
    for prog in "${FAILED_INSTALLS[@]}"; do
        echo -e "${RED}  - $prog${RESET}"
    done
    echo
fi

# Kérdés a GNOME téma beállításáról (ha a GNOME fut)
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
    if zenity --question --title="Téma beállítása" --text="Szeretné beállítani a rendszert sötét témára (Adwaita-dark)?\n\nEz a beállítás a következő programok futtatásához javasolt:\n- KVM/QEMU\n- Discord\n- OBS Studio" --width=300; then
        print_info "GNOME téma beállító script indítása..."
        if [ -f "gnome_theming.sh" ]; then
            chmod +x gnome_theming.sh
            ./gnome_theming.sh
            print_success "A téma beállítása sikeresen befejeződött."
        else
            print_error "A 'gnome_theming.sh' script nem található. A téma beállítása kihagyva."
        fi
    fi
fi

# ...
# 7. Újraindítás progress bárral és megszakítással
if zenity --question --title="Újraindítás" --text="A telepítés befejeződött. Szeretné most újraindítani a rendszert a változások érvényesüléséhez?" --width=300; then
    # Progress bar a megszakítással
    if zenity --progress --title="Újraindítás" --text="A rendszer 10 másodperc múlva újraindul..." --percentage=0 --auto-close --timeout=10 < <(
        for i in {0..10}; do
            echo $((i * 10))
            echo "# A rendszer $((10 - i)) másodperc múlva újraindul..."
            sleep 1
        done
    ); then
        # Ha a progress bar sikeresen lefutott (időtúllépés)
        print_info "Rendszer újraindítása..."
        print_divider
        echo -e "${GREEN}${BOLD}A Program telepítő script sikeresen befejeződött!${RESET}"
        print_divider
        sudo systemctl reboot
    else
        # Ha a felhasználó megnyomta a Cancel gombot
        print_warning "Újraindítás megszakítva."
        zenity --info --title="Megszakítva" --text="Az újraindítás megszakítva. A változások érvényesüléséhez jelentkezz ki, majd lépj be újra."
    fi
else
    print_info "Újraindítás kihagyva."
    zenity --info --title="Telepítés befejezve" --text="A rendszer nem indul újra. A változások érvényesüléséhez jelentkezz ki, majd lépj be újra."
fi
