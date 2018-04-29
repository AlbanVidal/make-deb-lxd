#!/bin/bash

# Update and upgrade OS
apt update
apt -y upgrade

# Need golang v10
if grep stretch /etc/os-release; then
    # for stretch (Debian 9), install via stretch-backports repository
    apt install -y -t stretch-backports golang golang-doc golang-go golang-src
elif grep buster /etc/os-release; then
    # natively in buster (Debian 10)
    apt install -y golang
fi

# Required : Install nécessary packages and dependencyies to compile LXC
apt install -y acl dnsmasq-base git liblxc1 lxc-dev libacl1-dev make pkg-config rsync squashfs-tools tar xz-utils bsdutils
# Optional : Install LVM tools and lvm thin provisioning tools
apt install -y lvm2 thin-provisioning-tools
# Optional : Install bridge-utils to create a bridge to test LXD in this host
apt install -y bridge-utils

# purge (delete) old directory
#rm -rf /opt/go/lxd
rm -rf /opt/go/
# Create source directory and binary directory
mkdir -p /opt/go/lxd

export GOPATH=/opt/go

# Download latest version of LXD from official repository LXD from github
go get github.com/lxc/lxd
# Download lxd-p2c
# 
cd $GOPATH/src/github.com/lxc/lxd
# Compile latest version of LXD - this will download all dependencies of LXD in other github repositories
make

