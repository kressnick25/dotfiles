#!/usr/bin/env bash

### Nicholas Kress terminal setup
# assumes fedora distro

set -e

function log {
    GREEN="\033[0;32m"
    BLUE="\033[0;34m"
    CYAN="\033[0;36m"
    NC="\033[0m"
    log_header="[ DOTFILES ]"

    echo -e "${CYAN}$log_header ${BLUE}$1${NC}"
}

ssh_key=~/.ssh/id_ed25519_$(hostname)
if [ ! -f $ssh_key ]; then
    log "generate SSH key: $ssh_key"
    ssh-keygen \
        -t ed25519 \
        -C "kressnick25@gmail.com" \
        -N "" \
        -f ~/.ssh/id_ed25519_$(hostname)
else
    log "SSH key already created: $ssh_key"
fi

log "enable dnf repos"
dnf_repos=(
    atim/lazygit
)
sudo dnf copr enable "${dnf_repos[@]}" -y

log "install packages"
packages=(
    bat
    delta
    fd-find
    fish
    git
    gpg2
    golang
    java-latest-openjdk
    jq
    lazygit
    neovim
    pass
    python3-pip
    ripgrep
    stow
    tmux
    xclip
    yq
    zoxide
)
sudo dnf install -y --skip-unavailable "${packages[@]}"

log "stow dotfiles"
stow --adopt .

log "create ~/.local/"
mkdir -p ~/.local/bin
mkdir -p ~/.local/opt

if [ ! -d ~/.venv/ ]; then
    log "Set up python3 virtualenv"
    python3 -m venv ~/.venv
    source ~/.venv/bin/activate
else
    log "python3 virtualenv already created"
fi

log "install language servers"
# languge servers
pip install pyright
go install golang.org/x/tools/gopls@latest

log "setup docker-compose for podman"
# allow docker-compose to connect to podman non-root
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
systemctl --user start podman.socket
export DOCKER_HOST="unix:///run/user/$(id -u)"

# setup password manager
# https://ryan.himmelwright.net/post/setting-up-pass/
if [ ! -d "$HOME/.password-store/" ]; then
    log "set up pass"
    gpg2 --full-key-gen
    
    read -p "Enter uid of secret key from 'gpg --list-secret-keys'" secret_key_id
    pass init $secret_key_id
else
    log "pass is already installed." 
fi

if command -v fish 2>&1 >/dev/null; then
    log "run fish bootstrap"
    fish ./.config/bootstrap.fish
fi
