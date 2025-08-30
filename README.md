<div align="center">
  <img src="https://github.com/Asymeister/Archlinux-program-script-GNOME/blob/main/img/arch.png?raw=true" alt="Arch logo" width="100"/>
  <img src="https://github.com/Asymeister/Archlinux-program-script-GNOME/blob/main/img/gnome.png?raw=true" alt="gnome Logo" width="80"/>
</div>

<h1 align="center">PROGRAM TELEPÍTŐ SCRIPT</h1>
<h3 align="center">❗A program telepítő script csak AMD-s gépen volt tesztelve❗</h3>

---

## 🔐 Támogatottság / Support

- [x] AMD CPU x AMD GPU
- [x] AMD CPU x NVIDIA
- [x] INTEL CPU x AMD GPU
- [x] INTEL CPU x NVIDIA

---

## 🚀 Jellemzők / Features

**Magyar**
- [x] **Grafikus telepítő:** A Zenity-alapú grafikus felület egyszerűvé teszi a programok kiválasztását.
- [x] **Automatikus frissítés:** A script induláskor ellenőrzi és letölti a legújabb verziót GitHub-ról.
- [x] **Intelligens függőségkezelés:** Automatikusan telepíti a `yay` (AUR helper) és a `flatpak` csomagkezelőket, beleértve a Flathub repozitóriumot.
- [x] **Kernel felismerés:** Észleli a futó kernel típusát (pl. `lts`, `zen`) és telepíti a hozzá tartozó headereket.
- [x] **Automatikus sötétmód:** Segít teljes mértékben elérhetővé tenni a sötét módot.

**English**
- [x] **Graphical Installer:** The Zenity-based graphical interface makes it easy to select programs.
- [x] **Automatic Update:** The script checks for and downloads the latest version from GitHub at startup.
- [x] **Intelligent Dependency Management:** Automatically installs the `yay` (AUR helper) and `flatpak` package managers, including the Flathub repository.
- [x] **Kernel Detection:** Detects the running kernel type (e.g., `lts`, `zen`) and installs the corresponding headers.
- [x] **Automatic Dark Mode:** Helps to fully enable the dark mode.

---

## 📋 Telepíthető Szoftverek / Installable Software

**Magyar**
A script egy gondosan összeállított listát kínál a legnépszerűbb és leghasznosabb programokból, beleértve:
- [x] **Rendszereszközök** (`Fastfetch`, `Pamac`, `KDEConnect`)
- [x] **Multimédia** (`EasyEffects`, `VLC`, `OBS Studio`, `Jellyfin Media Player`)
- [x] **Játék** (`Steam`,`Bottles`, `Lutris`, `Heroic Games Launcher`, `Gamemode`, `Corectrl`, `MangoHud`)
- [x] **Termelékenység** (`OnlyOffice`, `KeePassXC`, `Discord`, `Vivaldi`)

**English**
The script offers a carefully curated list of the most popular and useful programs, including:
- [x] **System Tools** (`Fastfetch`, `Pamac`, `KDEConnect`)
- [x] **Multimedia** (`EasyEffects`, `VLC`, `OBS Studio`, `Jellyfin Media Player`)
- [x] **Gaming** (`Steam`,`Bottles`, `Lutris`, `Heroic Games Launcher`, `Gamemode`, `Corectrl`, `MangoHud`)
- [x] **Productivity** (`OnlyOffice`, `KeePassXC`, `Discord`, `Vivaldi`)

---

## 🛠️ Használat / Usage

**Magyar**
A script használata rendkívül egyszerű.
1.  **Klónozd a repót:**
    ```bash
    git clone [https://github.com/Asymeister/Archlinux-program-script-GNOME.git](https://github.com/Asymeister/Archlinux-program-script-GNOME.git)
    cd Archlinux-program-script-GNOME
    ```
2.  **Futtasd a fő scriptet:**
    ```bash
    sudo chmod +x ./main.sh
    ./main.sh
    ```
3.  **Válassz nyelvet és programokat:** Kövesd a grafikus felületen megjelenő utasításokat a telepítéshez.

**English**
Using the script is extremely simple.
1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/Asymeister/Archlinux-program-script-GNOME.git](https://github.com/Asymeister/Archlinux-program-script-GNOME.git)
    cd Archlinux-program-script-GNOME
    ```
2.  **Run the main script:**
    ```bash
    sudo chmod +x ./main.sh
    ./main.sh
    ```
3.  **Select language and programs:** Follow the instructions on the graphical interface to proceed with the installation.

---

## 🚧 Következő update... / Next update...

**Magyar**
1. **Csak az elsődleges monitoron jelenjen meg a bejelentkező felület.**
2. **Programok folyamatos bővítése.**

**English**
1. **The login screen should only appear on the primary monitor.**
2. **Continuous expansion of the program list.**

---

## ❗ Fontos Megjegyzések / Important Notes

**Magyar**
> **A szkript használata teljes mértékben a te felelősségedre történik.** Bár a script robusztus hibakezelést tartalmaz, használat előtt minden fontos adatot ments le. A projekt szerzője nem vállal felelősséget a felmerülő problémákért.
* A script feltételezi, hogy az Arch Linux alaprendszer már telepítve van.
* A `main.sh` futtatásához internetkapcsolat szükséges.

**English**
> **The use of this script is entirely at your own risk.** Although the script includes robust error handling, you should back up all important data before use. The author of this project is not responsible for any problems that may arise.
* The script assumes that the Arch Linux base system is already installed.
* An internet connection is required to run `main.sh`.

---

## 🤝 Hozzájárulás / Contribution

**Magyar**
A visszajelzéseket és a hozzájárulásokat örömmel fogadom! Ha hibát találsz vagy van egy ötleted a script fejlesztésére, kérlek, nyiss egy [issue-t](https://github.com/Asymeister/Archlinux-program-script-GNOME/issues) vagy küldj be egy [pull request-et](https://github.com/Asymeister/Archlinux-program-script-GNOME/pulls).

**English**
Feedback and contributions are welcome! If you find a bug or have an idea for improving the script, please open an [issue](https://github.com/Asymeister/Archlinux-program-script-GNOME/issues) or submit a [pull request](https://github.com/Asymeister/Archlinux-program-script-GNOME/pulls).

---

## 📝 Licenc / License

**Magyar**
Ez a projekt az **[MIT Licenc](https://opensource.org/licenses/MIT)** alatt van.

**English**
This project is licensed under the **[MIT License](https://opensource.org/licenses/MIT)**.

---

*Készítette:* ***Asymeister***  *Made By:* ***Asymeister***
