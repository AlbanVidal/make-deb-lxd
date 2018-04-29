#!/bin/bash

# Search the actual version number in LXD website
version_maj=$(curl -s https://linuxcontainers.org/lxd/downloads/|grep 'href="/downloads/lxd/lxd-'|head -n1|sed 's/.*>lxd-\([0-9].[0-9]*\).*/\1/')

# année mois jour heure
#version_min=$(date +%Y%m%d.%H)
version_min=$(date +%Y%m%d)
# 
version_arch=$(dpkg --print-architecture)
#
VERSION="lxd-$version_maj-$version_min-$version_arch"

# Si le répertoire existe déjà on supprime
# If directory exist, will be delete it
if [ -d /opt/deb/$VERSION/ ]
then
    echo "Le répertoire existe déjà, on le supprime"
    rm -rf /opt/deb/$VERSION/
fi

# Création des répertoires
mkdir -p /opt/deb/$VERSION/DEBIAN
# Création des sous-répertoires
mkdir -p /opt/deb/$VERSION/usr/bin
mkdir -p /opt/deb/$VERSION/lib/systemd/system
#mkdir -p /opt/deb/$VERSION/usr/share/bash-completion/completions
mkdir -p /opt/deb/$VERSION/etc/bash_completion.d/

# Fichier Debian control
cat << EOF > /opt/deb/$VERSION/DEBIAN/control
Package: lxd
Version: $version_maj-$version_min
Section: base
Priority: optional
Architecture: $version_arch
Depends: lxc, liblxc1, lxcfs, acl, squashfs-tools, dnsmasq-base, bsdutils
Recommends: btrfs-progs, btrfs-tools, lvm2, thin-provisioning-tools
Maintainer: Alban Vidal <alban.vidal@zordhak.fr>
Description: Daemon based on liblxc offering a REST API to manage containers
EOF

# Script de post-Installation
cat << 'EOF' > /opt/deb/$VERSION/DEBIAN/postinst
#!/bin/sh

if ! grep -q root:1000000:65536 /etc/subuid; then
    logger --stderr --tag lxd-install --priority notice "Add subuid root:1000000:65536 in /etc/subuid file"
    echo 'root:1000000:65536' >> /etc/subuid;
    update_subXids=true
fi
if ! grep -q root:1000000:65536 /etc/subgid; then
    logger --stderr --tag lxd-install --priority notice "Add subgid root:1000000:65536 in /etc/subgid file"
    echo 'root:1000000:65536' >> /etc/subgid;
    update_subXids=true
fi

logger --stderr --tag lxd-install --priority notice "Enable lxd daemon"
systemctl daemon-reload
systemctl enable lxd

echo "
To force load bash-completion:
. /etc/bash_completion.d/lxd-client
#. /usr/share/bash-completion/completions/lxd-client

"

# If subuid or subgid are enabled now, need reboot no enable it
if ${update_subXids:-false} ; then
    logger --stderr --tag lxd-install --priority notice "You'll need sub{u,g}ids for root, so that LXD can create the unprivileged containers"
    logger --stderr --tag lxd-install --priority notice "To enable sub{u,g}ids for root, you need to reboot this node"
    logger --stderr --tag lxd-install --priority notice "If is possible, we recommend you to only create unprivileged container"
fi

logger --stderr --tag lxd-install --priority notice "Starting LXD daemon"
systemctl start lxd

EOF

chmod 755 /opt/deb/$VERSION/DEBIAN/postinst

# Fichier de pré-suppression
cat << 'EOF' > /opt/deb/$VERSION/DEBIAN/prerm
#!/bin/sh

logger --stderr --tag lxd-install --priority notice "Stop and disable lxd daemon"
systemctl disable lxd
systemctl stop lxd
systemctl daemon-reload

logger --stderr --tag lxd-install --priority notice "Delete sub{u,g}ids in files /etc/subuid and /etc/subuid"
sed -i '/root:1000000:65536/d' /etc/subgid
sed -i '/root:1000000:65536/d' /etc/subgid

logger --stderr --tag lxd-install --priority notice "Delete lxd-client bash_completion"
rm -f /etc/bash_completion.d/lxd-client
#rm -f /usr/share/bash-completion/completions/lxd-client

EOF

chmod 755 /opt/deb/$VERSION/DEBIAN/prerm

# Copie de l'auto-completion
#cp /opt/go/src/github.com/lxc/lxd/config/bash/lxd-client     /opt/deb/$VERSION/usr/share/bash-completion/completions/
cp /opt/go/src/github.com/lxc/lxd/config/bash/lxd-client     /opt/deb/$VERSION/etc/bash_completion.d/

# Copie des binaires :
cd /opt/go/bin/
/usr/bin/install -c lxc              /opt/deb/$VERSION/usr/bin/
/usr/bin/install -c lxd              /opt/deb/$VERSION/usr/bin/
/usr/bin/install -c lxd-benchmark    /opt/deb/$VERSION/usr/bin/

# Création du service systemd
cat << 'EOF' > /opt/deb/$VERSION/lib/systemd/system/lxd.service
[Unit]
Description=LXD
After=network.target

[Service]
ExecStart=/usr/bin/lxd
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

#################################

# Création du fichier .deb
cd /opt/deb/
dpkg-deb --build $VERSION


