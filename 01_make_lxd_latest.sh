#!/bin/bash

# Update and upgrade OS
apt update
apt -y upgrade

# Required : Install nécessary packages and dependencyies to compile LXC
apt install acl dnsmasq-base git golang liblxc1 lxc-dev libacl1-dev make pkg-config rsync squashfs-tools tar xz-utils bsdutils
# Optional : Install LVM tools and lvm thin provisioning tools
apt install lvm2 thin-provisioning-tools
# Optional : Install bridge-utils to create a bridge to test LXD in this host
apt install bridge-utils

# purge (delete) old directory
rm -rf /opt/go/lxd
# Create source directory and binary directory
mkdir -p /opt/go/lxd

export GOPATH=/opt/go

# Download latest version of LXD from official repository LXD from github
go get github.com/lxc/lxd
# 
cd $GOPATH/src/github.com/lxc/lxd
# Compile latest version of LXD - this will download all dependencies of LXD in other github repositories
make

