<div align="center">
  <img src="https://github.com/Asymeister/Archlinux-program-script-GNOME/blob/main/img/arch.png?raw=true" alt="Arch logo" width="100"/>
  <img src="https://github.com/Asymeister/Archlinux-program-script-GNOME/blob/main/img/amd.png?raw=true" alt="radeon Logo" width="100"/>
  <img src="https://github.com/Asymeister/Archlinux-program-script-GNOME/blob/main/img/gnome.png?raw=true" alt="gnome Logo" width="100"/>
</div>

<h1 align="center">PROGRAM TELEPÍTŐ SCRIPT</h1>
<h3 align="center">❗A program telepítő script csak AMD-s gépen volt tesztelve❗</h3>
<h3 align="center">❗A STEAM biztos hogy nem fog még működni NVIDIA kártyán❗</h3>

---

## 🔐 Támogatottság
- [x] AMD CPU x AMD GPU
- [ ] AMD CPU x NVIDIA
- [x] INTEL CPU x AMD GPU
- [ ] INTEL CPU x NVIDIA

---

## 🚀 Jellemzők

- [x] **Grafikus telepítő:** A Zenity-alapú grafikus felület egyszerűvé teszi a programok kiválasztását.
- [x] **Automatikus frissítés:** A script induláskor ellenőrzi és letölti a legújabb verziót GitHub-ról.
- [x] **Intelligens függőségkezelés:** Automatikusan telepíti a `yay` (AUR helper) és a `flatpak` csomagkezelőket, beleértve a Flathub repozitóriumot.
- [x] **Kernel felismerés:** Észleli a futó kernel típusát (pl. `lts`, `zen`) és telepíti a hozzá tartozó headereket.
- [x] **Automatikus sötétmód:** Segít teljes mértékben elérhetővé tenni a sötét módot.

---

## 📋 Telepíthető Szoftverek

A script egy gondosan összeállított listát kínál a legnépszerűbb és leghasznosabb programokból, beleértve:

- [x] **Rendszereszközök** (`Fastfetch`, `Pamac`, `KDEConnect`)
- [x] **Multimédia** (`EasyEffects`, `VLC`, `OBS Studio`, `Jellyfin Media Player`)
- [x] **Játék** (`Steam`,`Bottles`, `Lutris`, `Heroic Games Launcher`, `Gamemode`, `Corectrl`, `MangoHud`)
- [x] **Termelékenység** (`OnlyOffice`, `KeePassXC`, `Discord`, `Vivaldi`)

---

## 🛠️ Használat

A script használata rendkívül egyszerű.

1.  **Klónozd a repót:**
    ```bash
    git clone https://github.com/Asymeister/Archlinux-program-script-GNOME.git
    cd Archlinux-program-script-GNOME
    ```
2.  **Futtasd a fő scriptet:**
    ```bash
    sudo chmod +x ./main.sh
    ./main.sh
    ```
3.  **Válassz nyelvet és programokat:** Kövesd a grafikus felületen megjelenő utasításokat a telepítéshez.

---

## ❗ Fontos Megjegyzések

> **A szkript használata teljes mértékben a te felelősségedre történik.** Bár a script robusztus hibakezelést tartalmaz, használat előtt minden fontos adatot ments le. A projekt szerzője nem vállal felelősséget a felmerülő problémákért.

* A script feltételezi, hogy az Arch Linux alaprendszer már telepítve van.
* A `main.sh` futtatásához internetkapcsolat szükséges.

---

## 🤝 Hozzájárulás

A visszajelzéseket és a hozzájárulásokat örömmel fogadom! Ha hibát találsz vagy van egy ötleted a script fejlesztésére, kérlek, nyiss egy [issue-t](https://github.com/Asymeister/Archlinux-program-script-GNOME/issues) vagy küldj be egy [pull request-et](https://github.com/Asymeister/Archlinux-program-script-GNOME/pulls).

---

## 📝 Licenc

Ez a projekt az **[MIT Licenc](https://opensource.org/licenses/MIT)** alatt van.

---

*Készítette:* ***Asymeister***
