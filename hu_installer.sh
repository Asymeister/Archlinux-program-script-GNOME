#!/bin/bash

# A magyar nyelvű telepítő script

# Kilépés, ha bármelyik parancs hibát eredményez
set -e

# Ellenőrizzük, hogy a Yay és a Flatpak telepítve van-e
if ! command -v yay &> /dev/null
then
    zenity --info --title="Információ" --text="A Yay AUR segédprogram telepítése szükséges. Folytatás..."
    sudo pacman -S --noconfirm yay-bin
fi

if ! command -v flatpak &> /dev/null
then
    zenity --info --title="Információ" --text="A Flatpak telepítése szükséges. Folytatás..."
    sudo pacman -S --noconfirm flatpak
fi

# Függőségek és alapvető programok telepítése (ezeket érdemes az elején felrakni)
zenity --info --title="Függőségek" --text="A szükséges alapvető csomagok telepítése megkezdődik. Ezt a script automatikusan kezeli."
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

# Zenity ablak megjelenítése a választáshoz
CHOICES=$(zenity --list --checklist \
    --title="Telepítő" \
    --width=800 \
    --height=600 \
    --column="Jelölőnégyzet" \
    --column="Program neve" \
    --column="Forrás" \
    --column="Leírás" \
    FALSE "Bluetooth" "Pacman" "GNOME Bluetooth kapcsoló" \
    FALSE "Bottles" "Pacman" "Wine környezet a programokhoz és játékokhoz" \
    FALSE "Corectrl" "Pacman" "ATI és NVIDIA GPU vezérlő" \
    FALSE "Discord" "Flatpak" "Hang- és szöveges csevegőalkalmazás" \
    FALSE "Double commander-qt6" "Pacman" "Kéttáblás fájlkezelő" \
    FALSE "EasyEffects" "Pacman" "Hang effektek a Pipewire-hez" \
    FALSE "Fastfetch" "Pacman" "Rendszerinformációk terminálban" \
    FALSE "Gamemode" "Pacman" "Játékok teljesítményét növelő segédprogram" \
    FALSE "Heroic Games Launcher" "Flatpak" "Játékindító Epic Games és GOG-hoz" \
    FALSE "Jellyfin Media Player" "Yay" "Jellyfin médiakiszolgáló kliense" \
    FALSE "KDEConnect" "Pacman" "Telefon és asztali számítógép összekötése" \
    FALSE "KeePassXC" "Pacman" "Jelszókezelő" \
    FALSE "Lutris" "Pacman" "Játékindító az összes forráshoz" \
    FALSE "MangoHud/Goverlay" "Pacman" "Teljesítmény-kijelző játékokhoz" \
    FALSE "OBS" "Flatpak" "Képernyőfelvétel és streamelés" \
    FALSE "OnlyOffice" "Yay" "Irodai programcsomag (bináris verzió)" \
    FALSE "Pamac" "Yay" "Grafikus csomagkezelő" \
    FALSE "Spotify" "Pacman" "Zene-streamelő kliens" \
    FALSE "VLC" "Flatpak" "Multimédiás lejátszó" \
    FALSE "Vivaldi" "Pacman" "Sokoldalú webböngésző" \
)

# A felhasználó döntésének feldolgozása
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

zenity --info --title="Telepítés befejezve" --text="A telepítés sikeresen befejeződött."

# Kérdés az újraindításról
if zenity --question --title="Újraindítás szükséges" --text="A telepítés befejeződött. Szeretnéd most újraindítani a rendszert?" --ok-label="Igen" --cancel-label="Nem" --no-wrap
then
    (
    TIME_TO_REBOOT=10
    for (( i=$TIME_TO_REBOOT; i>=0; i-- )); do
        PERCENTAGE=$(( ($TIME_TO_REBOOT - $i) * 100 / $TIME_TO_REBOOT ))
        echo $PERCENTAGE
        echo "# A rendszer $i másodperc múlva újraindul... (Kattints a Mégse gombra a megszakításhoz)"
        sleep 1
    done
    ) | zenity --progress --title="Újraindítás" --text="A rendszer 10 másodperc múlva újraindul..." --auto-close
    
    if [ $? -eq 0 ]; then
        sudo reboot
    else
        zenity --info --title="Megszakítva" --text="Az újraindítás megszakítva. A változások érvényesüléséhez jelentkezz ki, majd lépj be újra."
    fi
else
    zenity --info --title="Telepítés befejezve" --text="A rendszer nem indul újra. Jelentkezz ki, majd lépj be újra a változások érvényesüléséhez."
fi
