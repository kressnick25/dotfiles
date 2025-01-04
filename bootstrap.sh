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

function install_packages {
    _distro=$1
    shift # remove first arg
    _packages="$@" # list of remaining args
    echo "${packages[@]}"

    if [ $_distro = "fedora" ]; then
        sudo dnf install -y --skip-unavailable "${packages[@]}"
    elif [ $_distro = "ubuntu" ]; then
        sudo apt-get install -y --ignore-missing "${packages[@]}"
    else
        echo "unknown distro: $_distro"
        exit 1
    fi
}

distro=$(cat /etc/os-release | grep '^ID=' | sed s/ID=//)
if [ $distro = "debian" ]; then
    distro=ubuntu
fi

if [ $distro = "fedora" ]; then
    log "enable dnf repos"
    dnf_repos=(
        atim/lazygit
    )
    sudo dnf copr enable "${dnf_repos[@]}" -y
fi

# kubectl install
KUBE_VERSION="v1.32"
if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
    if [ $distro = "ubuntu" ]; then
        log "enable dnf repos"
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg 
        curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBE_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
        echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBE_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
        sudo apt-get update
        sudo apt-get install -y kubectl
    elif [ $distro = "fedora" ]; then
        echo "TODO fedora kubectl install"
    fi
fi


log "install packages"
packages=(
    bat
    curl
    delta
    fd-find
    fish
    git
    golang
    hostname
    jq
    neovim
    pass
    podman
    python3-pip
    ripgrep
    stow
    tmux
    xclip
    zoxide
)
fedora_packages=(
    lazygit
    java-latest-openjdk
    gpg2
    yq
)
ubuntu_packages=(
    gnupg
    default-jdk
    python3-venv
)
if [ $distro = "ubuntu" ]; then
    packages=("${packages[@]}" "${ubuntu_packages[@]}")
elif [ $distro = "fedora" ]; then
    packages=("${packages[@]}" "${fedora_packages[@]}")
fi
install_packages $distro "${packages[@]}"

if [ $distro = "ubuntu" ]; then
    log "install lazygit"
    lg_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${lg_version}/lazygit_${lg_version}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
fi


log "stow dotfiles"
stow --adopt .

ssh_key=~/.ssh/id_ed25519_$(hostname)
if [ ! -f $ssh_key ]; then
    log "generate SSH key: $ssh_key"
    mkdir -p ~/.ssh
    ssh-keygen \
        -t ed25519 \
        -C "kressnick25@gmail.com" \
        -N "" \
        -f ~/.ssh/id_ed25519_$(hostname)
else
    log "SSH key already created: $ssh_key"
fi

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
systemctl --user start podman.socket || log "unable to enable podman compose"
export DOCKER_HOST="unix:///run/user/$(id -u)"

# setup password manager
# https://ryan.himmelwright.net/post/setting-up-pass/
if [ ! -d "$HOME/.password-store/" ]; then
    if [ $distro = "fedora" ]; then
        gpg="gpg2"
    elif [ $distro = "ubuntu" ]; then
        gpg="gpg"
    fi

    log "set up pass"
    $gpg --batch --full-generate-key <<EOF
Key-Type: ECDSA
Key-Curve: nistp256
Key-Usage: sign
Name-Real: Nicholas Kress
Name-Email: kressnick25@gmail.com
Expire-Date: 0
%no-protection
%commit
EOF
    
    secret_key_id=$($gpg --list-keys --with-colons | grep uid | tail -n1 | cut -d':' -f8)
    pass init $secret_key_id
else
    log "pass is already installed." 
fi

if command -v fish 2>&1 >/dev/null; then
    log "run fish bootstrap"
    fish ./.config/bootstrap.fish
fi
