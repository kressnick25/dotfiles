#!/usr/bin/bash

set -ev

distro=$(cat /etc/os-release | grep '^ID=' | sed s/ID=//)

useradd -m tester || echo "tester already exists"
cd /home/tester

if [ $distro = "ubuntu" ]; then
    apt-get update
    apt-get install -y git sudo
elif [ $distro = "fedora" ]; then
    sudo dnf install -y git
fi


if [ $# -eq 0 ]; then # no args, use 'skip-checkout' to skip
    echo "Checking out dotfiles"
    git clone https://github.com/kressnick25/dotfiles.git
    cd dotfiles && git switch test && cd /home/tester # TODO remove
    mv dotfiles .dotfiles
    cd .dotfiles
fi

bash bootstrap.sh
