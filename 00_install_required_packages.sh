#!/bin/bash

################################################################################
##########                    Define color for output:                ##########
################################################################################
_WHITE_="tput sgr0"
_RED_="tput setaf 1"
_GREEN_="tput setaf 2"
_ORANGE_="tput setaf 3"
################################################################################

# Update and upgrade OS
echo "$($_ORANGE_)Update and upgrade OS$($_WHITE_)"
apt-get update     > /dev/null
apt-get upgrade -y > /dev/null

# Need golang v10
if grep -q stretch /etc/os-release; then

    ## For stretch (Debian 9), install via stretch-backports repository
    echo "$($_GREEN_)Debian Stretch detected$($_WHITE_)"

    echo "$($_ORANGE_)Add stretch-backports repository$($_WHITE_)"
    # Install software-properties-common, necessary for use add-apt-repository
    apt-get install -y software-properties-common > /dev/null
    # Add stretch-backports repository
    add-apt-repository 'deb http://ftp.fr.debian.org/debian stretch-backports main contrib non-free'
    apt-get update > /dev/null

    # Install golang package from stretch-backports repository
    echo "$($_ORANGE_)Install golang package from stretch-backports repository$($_WHITE_)"
    apt-get install -y -t stretch-backports golang golang-doc golang-go golang-src > /dev/null

elif grep -q buster /etc/os-release; then

    # natively in buster (Debian 10)
    echo "$($_GREEN_)Debian Buster detected$($_WHITE_)"

    echo "$($_ORANGE_)Install golang v10$($_WHITE_)"
    apt-get install -y golang > /dev/null

else

    echo "$($_RED_)ERROR$($_WHITE_)"
    echo "$($_RED_)Debian 9 or 10 is required$($_WHITE_)"
    exit 1

fi

# Required : Install nécessary packages and dependencies to compile LXC
echo "$($_ORANGE_)Required : Install nécessary packages and dependencies to compile LXC$($_WHITE_)"
apt-get install -y  \
    acl             \
    dnsmasq-base    \
    git             \
    liblxc1         \
    lxc-dev         \
    libacl1-dev     \
    make            \
    pkg-config      \
    rsync           \
    squashfs-tools  \
    tar             \
    xz-utils        \
    bsdutils        \
    tcl             \
    autoconf        \
    libtool         \
    libuv1          \
    libsqlite3-dev  \
    libcap-dev      \
    > /dev/null

# Optional : Install LVM tools and lvm thin provisioning tools
echo "$($_ORANGE_)Optional : Install LVM tools and lvm thin provisioning tools$($_WHITE_)"
apt-get install -y          \
    lvm2                    \
    thin-provisioning-tools \
    > /dev/null

# Optional : Install bridge-utils to create a bridge to test LXD in this host
echo "$($_ORANGE_)Optional : Install bridge-utils to create a bridge to test LXD in this host$($_WHITE_)"
apt-get install -y  \
    bridge-utils    \
    > /dev/null

