#!/bin/sh

set -ex

GIT_REPO=https://github.com/turbana/systemsetup.git
SOURCES=/etc/apt/sources.list
TMP_SOURCES=/tmp/$$.sources.list

# add ansible repo
if ! grep -q ansible $SOURCES; then
    cp $SOURCES $TMP_SOURCES
    echo >> $TMP_SOURCES
    echo "# ansible repo" >> $TMP_SOURCES
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> $TMP_SOURCES
    mv $TMP_SOURCES $SOURCES
fi

# dirmngr needed for apt-key
apt-get install -y dirmngr
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt-get update
apt-get install -y ansible python
ansible-pull -U $GIT_REPO
