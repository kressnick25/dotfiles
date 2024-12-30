#!/usr/bin/bash

set -ev

distro=$(cat /etc/os-release | grep '^ID=' | sed s/ID=//)

useradd -m tester || echo "tester already exists"

cd /home/tester
rm -rf dotfiles .dotfiles

if [ $distro = "ubuntu" ]; then
    apt-get update
    apt-get install -y git sudo
elif [ $distro = "fedora" ]; then
    sudo dnf install -y git
fi

git clone https://github.com/kressnick25/dotfiles.git
cd dotfiles && git switch test && cd /home/tester

mv dotfiles .dotfiles
cd .dotfiles
bash bootstrap.sh
