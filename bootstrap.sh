#!/bin/sh

set -ex

GIT_REPO=https://github.com/turbana/systemsetup.git
SOURCES=/etc/apt/sources.list
TMP_SOURCES=/tmp/$$.sources.list

# add ansible repo
if [ ! grep -q ansible $SOURCES ]; then
    cp $SOURCES $TMP_SOURCES
    echo >> $TMP_SOURCES
    echo "# ansible repo" >> $TMP_SOURCES
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> $TMP_SOURCES
    mv $TMP_SOURCES $SOURCES
fi

# add ansible public key
if [ ! apt-key list | grep -q Ansible ]; then
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
fi

apt-get update
apt-get install ansible python sudo
ansible-pull -U $GIT_REPO
