#!/bin/bash

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

