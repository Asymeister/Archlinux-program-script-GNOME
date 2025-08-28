#!/bin/bash

# A fő telepítő script, ami kezeli a frissítést, a nyelvválasztást,
# és biztosítja a telepítőscriptek futtathatóságát.

# Kéri a jelszót a sudo jogosultságokhoz, és életben tartja azokat
sudo -v

# Kilépés, ha bármelyik parancs hibát eredményez
set -e

# Ellenőrizzük, hogy a telepítőscriptek a megfelelő helyen vannak-e
if [ ! -f "hu_installer.sh" ] || [ ! -f "en_installer.sh" ]; then
    zenity --error \
        --title="Hiba: Hiányzó fájlok" \
        --text="A telepítőfájlok (hu_installer.sh és en_installer.sh) hiányoznak a jelenlegi könyvtárból.\n\nKérlek, helyezd őket a main.sh mellé, majd próbáld újra."
    exit 1
fi

# Ellenőrizzük a telepítőscriptek futtathatóságát, és ha szükséges, beállítjuk
chmod +x hu_installer.sh en_installer.sh

echo "--- Rendszerfrissítés és a Zenity telepítése ---"
sudo pacman -Syu --noconfirm

# Ellenőrizzük, hogy a zenity telepítve van-e, és telepítjük, ha szükséges
if ! command -v zenity &> /dev/null
then
    sudo pacman -S --noconfirm zenity
fi

# Nyelvválasztó ablak
LANGUAGE=$(zenity --list --radiolist \
    --title="Nyelvválasztás" \
    --text="Válassza ki a telepítő nyelvét:" \
    --column="Választás" \
    --column="Nyelv" \
    TRUE "Magyar" \
    FALSE "English")

# Ellenőrizzük a kiválasztott nyelvet, és elindítjuk a megfelelő scriptet
if [[ "$LANGUAGE" == "Magyar" ]]; then
    ./hu_installer.sh
elif [[ "$LANGUAGE" == "English" ]]; then
    ./en_installer.sh
else
    zenity --error --title="Hiba" --text="Érvénytelen választás. A program leáll."
    exit 1
fi
