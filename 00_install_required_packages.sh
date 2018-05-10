#!/bin/bash

# Update and upgrade OS
apt-get update
apt-get upgrade -y

# Need golang v10
if grep stretch /etc/os-release; then
    ## For stretch (Debian 9), install via stretch-backports repository
    # Install software-properties-common, necessary for use add-apt-repository
    apt-get install -y software-properties-common
    # Add stretch-backports repository
    add-apt-repository 'deb http://ftp.fr.debian.org/debian stretch-backports main contrib non-free'
    apt-get update
    # Install golang package in stretch-backports repository
    apt-get install -y -t stretch-backports golang golang-doc golang-go golang-src
elif grep buster /etc/os-release; then
    # natively in buster (Debian 10)
    apt-get install -y golang
fi

# Required : Install nécessary packages and dependencyies to compile LXC
apt install -y acl dnsmasq-base git liblxc1 lxc-dev libacl1-dev make pkg-config rsync squashfs-tools tar xz-utils bsdutils
# Optional : Install LVM tools and lvm thin provisioning tools
apt install -y lvm2 thin-provisioning-tools

# Optional : Install bridge-utils to create a bridge to test LXD in this host
apt install -y bridge-utils

