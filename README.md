Arch Linux - PROGRAM Installer Script
Ez a script egy modern, grafikus felhasználói felülettel (GUI) rendelkező telepítő, amely automatizálja az Arch Linux alaprendszered testreszabását. A Program Installer célja, hogy a felhasználók könnyedén és gyorsan telepíthessék azokat az alapvető és kiegészítő szoftvereket, amelyekre a mindennapi használathoz szükségük van, a GNOME asztali környezet tiszta alapjaira építve.

Fontos: Ez a script feltételezi, hogy az Arch Linux alaprendszere már telepítve van. A telepítést nem a nulláról végzi, hanem a meglévő rendszeren futtatva automatizálja a szoftverek telepítését és konfigurálását.

🚀 Főbb Jellemzők
Grafikus Felhasználói Felület (GUI): A script Zenity-t használ, így egy interaktív ablakban, egyszerűen és vizuálisan választhatod ki a telepíteni kívánt programokat.

Moduláris felépítés: A main.sh szkript intelligensen kezeli a nyelvválasztást, és szükség esetén elindítja a magyar (hu_installer.sh) vagy angol (en_installer.sh) telepítő-modult.

Automatikus frissítés: A script induláskor ellenőrzi a GitHub-on lévő legújabb verziót, és felajánlja a frissítést, biztosítva, hogy mindig a legnaprakészebb funkciókat használd.

Okos függőségkezelés: Automatikusan telepíti a yay (AUR helper) és a flatpak csomagkezelőket, valamint hozzáadja a Flathub repozitóriumot a széleskörű programválaszték érdekében.

Robusztus KVM/QEMU beállítás: A script egy komplex telepítési folyamatot végez el a KVM/QEMU-hoz, beleértve a csomagok telepítését, a felhasználó csoportokhoz adását, és a libvirtd szolgáltatás beállítását.

Részletes visszajelzés: A telepítési folyamat alatt a script folyamatosan információs, sikeres, figyelmeztető és hibaüzeneteket jelenít meg, így mindig tudni fogod, mi történik.

Rendszer optimalizálás: A script észleli a futó kernel típusát (pl. linux-lts, linux-zen) és automatikusan telepíti a hozzá tartozó linux-headers csomagot.

📋 Telepíthető Szoftverek
A script egy széleskörű listát kínál a legnépszerűbb és leggyakrabban használt programokból, beleértve az alábbiakat:

Rendszereszközök: Fastfetch, KDEConnect, Pamac

Multimédia: EasyEffects, VLC, OBS Studio, Jellyfin Media Player

Játék: Bottles, Lutris, Heroic Games Launcher, Gamemode, Corectrl, MangoHud

Termelékenység: OnlyOffice, KeePassXC, Discord, Vivaldi

Virtuális gépek: KVM/QEMU (komplett konfigurációval)

🛠️ Használat
Indulás Arch Linux alatt: Győződj meg róla, hogy egy működő Arch Linux rendszert használsz, és van internetkapcsolatod.

Töltsd le a scripteket:

Bash

git clone https://github.com/Asymesiter/Archlinux-program-script-GNOME.git
cd Archlinux-program-script-GNOME
Futtatás: A script elindításához csak a main.sh fájlt kell futtathatóvá tenned és elindítanod:

Bash

chmod +x main.sh
./main.sh
Kövesd az utasításokat: A Zenity ablakban válaszd ki a telepíteni kívánt nyelvet és programokat, majd a script automatikusan végrehajtja a telepítést.

⚠️ Jogi Nyilatkozat
Ez a script "ahogy van" alapon kerül terjesztésre, garancia nélkül. A script használata saját felelősségre történik. A projekt szerzője nem vállal felelősséget a felmerülő problémákért, adatvesztésért vagy a hibás működésért.

🤝 Hozzájárulás
A visszajelzéseket és a hozzájárulásokat örömmel fogadom! Ha hibát találsz, vagy van egy ötleted a script fejlesztésére, kérlek, nyiss egy issue-t vagy küldj be egy pull request-et.

📝 Licenc
Ez a projekt az MIT Licenc alatt van.

Készítette: A te neved
