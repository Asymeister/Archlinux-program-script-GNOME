<p align="center">
  <img src="./docs/arch_gnome_logo.png" alt="Arch Linux GNOME Fúzió Logó" width="150"/>
</p>

<h1 align="center">Hunter Installer Script</h1>

## 🚀 Jellemzők

* **Grafikus telepítő:** A Zenity-alapú grafikus felület egyszerűvé teszi a programok kiválasztását.
* **Automatikus frissítés:** A script induláskor ellenőrzi és letölti a legújabb verziót GitHub-ról.
* **Intelligens függőségkezelés:** Automatikusan telepíti a `yay` (AUR helper) és a `flatpak` csomagkezelőket, beleértve a Flathub repozitóriumot.
* **Kernel felismerés:** Észleli a futó kernel típusát (pl. `lts`, `zen`) és telepíti a hozzá tartozó headereket.
* **Kiemelt támogatás a KVM/QEMU-hoz:** Egyetlen választással telepíthető és konfigurálható a teljes virtualizációs környezet.

---

## 📋 Telepíthető Szoftverek

A script egy gondosan összeállított listát kínál a legnépszerűbb és leghasznosabb programokból, beleértve:

* **Rendszereszközök** (`Fastfetch`, `Pamac`, `KDEConnect`)
* **Multimédia** (`EasyEffects`, `VLC`, `OBS Studio`, `Jellyfin Media Player`)
* **Játék** (`Bottles`, `Lutris`, `Heroic Games Launcher`, `Gamemode`, `Corectrl`, `MangoHud`)
* **Termelékenység** (`OnlyOffice`, `KeePassXC`, `Discord`, `Vivaldi`)

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

A visszajelzéseket és a hozzájárulásokat örömmel fogadom! Ha hibát találsz vagy van egy ötleted a script fejlesztésére, kérlek, nyiss egy [issue-t](https://github.com/a_felhasználóneved/a_projekted_neve/issues) vagy küldj be egy [pull request-et](https://github.com/a_felhasználóneved/a_projekted_neve/pulls).

---

## 📝 Licenc

Ez a projekt az **[MIT Licenc](https://opensource.org/licenses/MIT)** alatt van.

---

**Készítette: A te neved**

---

Ez a javaslat tükrözi a képen látható elrendezést: egyértelmű, nagy szakaszcímek, alatta rövid leírások és listák. A `---` elválasztók segítenek a vizuális tagolásban, a `#` és `##` pedig hierarchiát ad a címeknek.

Ha elküldöd a saját logódat, a kódban egyszerűen lecseréled a `src="./docs/arch_gnome_logo.png"` részt a te fájlnevedre.
