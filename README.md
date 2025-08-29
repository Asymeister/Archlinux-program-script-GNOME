<p align="center">
  <img src="[https://upload.wikimedia.org/wikipedia/commons/e/e8/Archlinux-logo-standard-version.png" alt="Arch Linux GNOME Fúzió Logó" width="250"/>
</p>

<h1 align="center">PROGRAM Installer Script</h1>

## 🚀 Jellemzők

- [x] **Grafikus telepítő:** A Zenity-alapú grafikus felület egyszerűvé teszi a programok kiválasztását.
- [x] **Automatikus frissítés:** A script induláskor ellenőrzi és letölti a legújabb verziót GitHub-ról.
- [x] **Intelligens függőségkezelés:** Automatikusan telepíti a `yay` (AUR helper) és a `flatpak` csomagkezelőket, beleértve a Flathub repozitóriumot.
- [x] **Kernel felismerés:** Észleli a futó kernel típusát (pl. `lts`, `zen`) és telepíti a hozzá tartozó headereket.
- [x] **Kiemelt támogatás a KVM/QEMU-hoz:** Egyetlen választással telepíthető és konfigurálható a teljes virtualizációs környezet.

---

## 📋 Telepíthető Szoftverek

A script egy gondosan összeállított listát kínál a legnépszerűbb és leghasznosabb programokból, beleértve:

- [x] **Rendszereszközök** (`Fastfetch`, `Pamac`, `KDEConnect`)
- [x] **Multimédia** (`EasyEffects`, `VLC`, `OBS Studio`, `Jellyfin Media Player`)
- [x] **Játék** (`Bottles`, `Lutris`, `Heroic Games Launcher`, `Gamemode`, `Corectrl`, `MangoHud`)
- [x] **Termelékenység** (`OnlyOffice`, `KeePassXC`, `Discord`, `Vivaldi`)

---

## 🛠️ Használat

A script használata rendkívül egyszerű.

1.  **Klónozd a repót:**
    ```bash
    git clone [https://github.com/a_felhasználóneved/a_projekted_neve.git](https://github.com/a_felhasználóneved/a_projekted_neve.git)
    cd a_projekted_neve
    ```
2.  **Futtasd a fő scriptet:**
    ```bash
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
