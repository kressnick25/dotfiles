#!/usr/bin/bash

set -ev

rm -rf dotfiles .dotfiles

dnf install -y git
git clone https://github.com/kressnick25/dotfiles.git
cd dotfiles && git switch test && cd /
mv dotfiles .dotfiles
cd .dotfiles
bash bootstrap.sh
