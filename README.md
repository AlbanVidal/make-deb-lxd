Compile latest version of LXD to create a .deb file
===================================================

Working on:
+ [x] Debian 9 (stretch)
+ [x] Debian 10 (buster)

**For English version, see below**

---

# Version Française

Pour générer un fichier .deb à partir de la dernière version de LXD, exécutez les deux scripts suivants :
+ 00_install_required_packages.sh => **Prépare le système, installe les dépendances**
+ 01_make_lxd_latest.sh => **Télécharge la dernière version du code source et compile LXD**,
+ 02_create_deb_lxd.sh => **Créer un fichier .deb à partir des binaires compilés**.

Le fichier .deb est aussi dispobinle pour les architrctures **amd64**, **arm64** et **armhf** sur mon dépôt debian personnel, voir [deb.zordhak.fr](https://deb.zordhak.fr)

## Site web et dépôt github officiel LXD :
+ [linuxcontainers.org - LXD](https://linuxcontainers.org/lxd/)
+ [Ubuntu - LXD](https://www.ubuntu.com/containers/lxd)
+ [Github - LXC/LXD](https://github.com/lxc/lxd)

---

# English version

To generate a .deb file from latest version of LXD, execute the two following scripts :
+ 00_install_required_packages.sh => **Prepare OS and install dependencies**
+ 01_make_lxd_latest.sh => **Download latest version of source code and compile LDX**,
+ 02_create_deb_lxd.sh => **Create a .deb file from a compiled binary**.

.deb file is also available for the **amd64**, **arm64** and **armhf** architecture in my personnal debian repository, see [deb.zordhak.fr](https://deb.zordhak.fr)

## Official LXD website and github repository :
+ [linuxcontainers.org - LXD](https://linuxcontainers.org/lxd/)
+ [Ubuntu - LXD](https://www.ubuntu.com/containers/lxd)
+ [Github - LXC/LXD](https://github.com/lxc/lxd)
