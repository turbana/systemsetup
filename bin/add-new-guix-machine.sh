#!/bin/sh

set -e

cd `dirname $0`
template=../guix/systems/template.scm
config=../guix/systems/`hostname`.scm

if [ -f "$config" ]; then
    echo "* config for `hostname` already exists"
    exit 0
fi

find_uuid() {
    # device=`mount | grep "on $1 " | cut -f1 -d' '`
    device=/dev/`lsblk -l | grep "part ${1}$" | cut -f1 -d' '`
    for uuid in /dev/disk/by-uuid/*; do
        if [ "$device" -ef "$uuid" ]; then
            echo `basename $uuid`
            return 0
        fi
    done
    >&2 echo "* ERROR could not find UUID for mount point $1"
    return 1
}

HOSTNAME=`hostname`
ROOT_UUID=`find_uuid /`
BOOT_UUID=`find_uuid /boot/efi`
SWAP_UUID=`find_uuid '\\[SWAP\]'`

echo "* creating config for $HOSTNAME"
sed -e "s/<HOSTNAME>/$HOSTNAME/g" \
    -e "s/<ROOT_UUID>/$ROOT_UUID/g" \
    -e "s/<BOOT_UUID>/$BOOT_UUID/g" \
    -e "s/<SWAP_UUID>/$SWAP_UUID/g" \
    $template > $config

if [ ! -z "$EDITOR" ]; then
    echo "* editing config for $HOSTNAME"
    $EDITOR $config
else
    echo "* \$EDITOR not found, manually edit file at:"
    path=`pwd`/$config
    echo `readlink -f $path`
fi
