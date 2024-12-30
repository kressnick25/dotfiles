#!/usr/bin/bash

set -ev

dnf install -y git
git clone https://github.com/kressnick25/dotfiles.git
mv dotfiles .dotfiles
cd .dotfiles
bash bootstrap.sh
