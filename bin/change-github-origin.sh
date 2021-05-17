#!/bin/sh

set -e

if [ ! -f ~/github-repos-need-origin-change ]; then
    echo "* no repos found that need origin change"
    exit 0
fi

# check for ssh-keygen
if [ ! `which ssh-keygen` ]; then
    echo "* ERROR: ssh-keygen not found"
    exit 2
fi

# generate ssh key
if [ ! -f $HOME/id_ecdsa ]; then
    echo " * generate ssh key"
    sudo -u $USER ssh-keygen -f /home/$USER/.ssh/id_ecdsa -t ecdsa -b 521
    echo " * MANUALLY add the public key to github"
    cat /home/$USER/.ssh/id_ecdsa.pub
    echo "Press enter to continue..."
    read ignore
fi

# TODO
