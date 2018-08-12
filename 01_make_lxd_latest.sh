#!/bin/bash

################################################################################
##########                    Define color to output:                 ##########
################################################################################
_WHITE_="tput sgr0"
_RED_="tput setaf 1"
_GREEN_="tput setaf 2"
_ORANGE_="tput setaf 3"
################################################################################

# purge (delete) old binary
echo "$($_ORANGE_)purge (delete) old binary (/opt/go/bin)$($_WHITE_)"
rm -rf /opt/go/bin

# Create source directory and binary directory
$($_WHITE_)"Create source directory and binary directory (/opt/go)$($_WHITE_)"
mkdir -p /opt/go

export GOPATH=/opt/go

# Download latest version of LXD from official repository LXD from github
echo "$($_ORANGE_)Download latest version of LXD from official repository LXD from github$($_WHITE_)"
go get github.com/lxc/lxd

# ??
# Download lxd-p2c

# Go to the source code directory
cd $GOPATH/src/github.com/lxc/lxd

# Make missing dependencies
echo "$($_ORANGE_)Make missing dependencies$($_WHITE_)"
make deps

# Compile latest version of LXD - this will download all dependencies of LXD in other github repositories
echo "$($_ORANGE_)Compile latest version of LXD - this will download all dependencies of LXD in other github repositories$($_WHITE_)"
make

