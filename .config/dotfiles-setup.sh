#!/usr/bin/env bash

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_$(hostname)

mkdir .bashrc.d
touch .bashrc.d/alias
alias_file="~/.bashrc.d/alias.bashrc"


install="sudo dnf install"

$install neovim
$install tmux
echo "alias vim='nvim'" >> $alias_file

$install git
$install ripgrep
$install fd-find
$install delta
$install bat
$install zoxide
$install lazygit
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
$install xclip
echo "alias clip='xclip -selection c'" >> $alias_file

# languge servers
$install python3-pip
pip install pyright

# allow docker-compose to connect to podman non-root
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
systemctl --user start podman.socket
export DOCKER_HOST="unix:///run/user/$(id

# setup password manager
# https://ryan.himmelwright.net/post/setting-up-pass/
if [ ! -d "~/.password-store" ]; then
    echo "Setting up pass..."
    $install gpg2 pass
    gpg2 --full-key-gen
    
    read -p "Enter uid of secret key from 'gpg --list-secret-keys'" secret-key-id
    pass init $secret-key-id
fi
