#!/bin/sh

set -e

# check for git and install
if [ ! `which git` ]; then
    echo "* git not found, installing"
    guix package --install git
    if [ "$?" -ne "0" -o ! `which git` ]; then
        echo "* ERROR: git failed to install"
        exit 2
    fi
fi

repo() {
    url=$1
    path=$2
    if [ -e "$path/.git" ]; then
        echo "** repo $path already exists"
    else
        echo "** cloning repo $path"
        git clone $url $path
        if [ "$?" -eq "0" ]; then
            echo $path >> ~/github-repos-need-origin-change
        fi
    fi
}

# clone git repos
echo "* clone github repos"
repo https://github.com/turbana/systemsetup.git ~/src/systemsetup
repo https://github.com/turbana/dotfiles.git ~/src/etc
repo https://github.com/turbana/cpu.git ~/src/cpu
repo https://github.com/turbana/emacs-config.git ~/src/emacs
repo https://github.com/turbana/themian.git ~/src/themian

# setup symlinks
echo "* setup symlinks"
sh ~/src/etc/setup.sh
mkdir -p ~/.config/guix/{profiles,auto-start-profiles}
ln -sf ~/src/systemsetup/guix/systems ~/.config/guix/
ln -sf ~/src/systemsetup/guix/manifests ~/.config/guix/

# add new machine
echo "* create new guix config"
sh ~/src/systemsetup/bin/add-new-guix-machine.sh 

# reconfigure
echo "* manually run the following commands to complete bootstrap:"
echo "guix pull"
echo "sudo guix system -L ~/.config/guix/systems reconfigure ~/.config/guix/systems/`hostname`.scm"
echo "sudo reboot"
