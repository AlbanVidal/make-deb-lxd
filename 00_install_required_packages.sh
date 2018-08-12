#!/bin/bash

################################################################################
##########                    Define color to output:                 ##########
################################################################################
_WHITE_="tput sgr0"
_RED_="tput setaf 1"
_GREEN_="tput setaf 2"
_ORANGE_="tput setaf 3"
################################################################################

# Update and upgrade OS
echo "$($_ORANGE_)Update and upgrade OS$($_WHITE_)"
apt-get update
apt-get upgrade -y

# Need golang v10
echo "$($_ORANGE_)Need golang v10 - Install it$($_WHITE_)"
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

# Required : Install nécessary packages and dependencies to compile LXC
echo "$($_ORANGE_)Required : Install nécessary packages and dependencies to compile LXC$($_WHITE_)"
apt install -y acl dnsmasq-base git liblxc1 lxc-dev libacl1-dev make pkg-config rsync squashfs-tools tar xz-utils bsdutils tcl

# Optional : Install LVM tools and lvm thin provisioning tools
echo "$($_ORANGE_)Optional : Install LVM tools and lvm thin provisioning tools$($_WHITE_)"
apt install -y lvm2 thin-provisioning-tools

# Optional : Install bridge-utils to create a bridge to test LXD in this host
echo "$($_ORANGE_)Optional : Install bridge-utils to create a bridge to test LXD in this host$($_WHITE_)"
apt install -y bridge-utils

