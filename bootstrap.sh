#!/bin/sh

set -e

GIT_REPO=https://github.com/turbana/systemsetup.git
SOURCES=/etc/apt/sources.list
TMP_SOURCES=/tmp/$$.sources.list

if [ "$#" = "1" ]; then
    USER=$1
else
    echo " * finding user"
    USER=$(id -un 1000)
fi
if [ -z "$USER" ]; then
    echo "ERROR: could not determine user; run '$(basename $0) <user>'"
    exit 2
fi

echo " * user is $USER"

# add ansible repo
if ! grep -q ansible $SOURCES; then
    echo " * add ansible apt repository"
    cp $SOURCES $TMP_SOURCES
    echo >> $TMP_SOURCES
    echo "# ansible repo" >> $TMP_SOURCES
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> $TMP_SOURCES
    mv $TMP_SOURCES $SOURCES
fi

# dirmngr needed for apt-key
echo " * install dirmngr"
apt-get install -y dirmngr > /dev/null

echo " * add ansible public apt key"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 > /dev/null

echo " * update packages"
apt-get update > /dev/null

echo " * install ansible/git/sudo"
apt-get install -y ansible python git sudo > /dev/null

if [ ! -f $HOME/id_ecdsa ]; then
    echo " * generate ssh key"
    sudo -u $USER ssh-keygen -f /home/$USER/.ssh/id_ecdsa -t ecdsa -b 521
    echo " * MANUALLY add the public key to github"
    cat /home/$USER/.ssh/id_ecdsa.pub
    echo "Press enter to continue..."
    read ignore
fi

echo " * start ansible"
ansible-pull -U $GIT_REPO
