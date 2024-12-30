#!/usr/bin/bash

set -ev


useradd tester || echo "tester already exists"

cd /home/tester
rm -rf dotfiles .dotfiles

sudo dnf install -y git

git clone https://github.com/kressnick25/dotfiles.git
cd dotfiles && git switch test && cd /home/tester

mv dotfiles .dotfiles
cd .dotfiles
bash bootstrap.sh
