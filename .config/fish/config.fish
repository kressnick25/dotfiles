fish_add_path ~/.local/bin 
fish_add_path ~/.cargo/bin 
fish_add_path /usr/local/go/bin 
fish_add_path ~/go/bin 
fish_add_path ~/.local/opt/yazi 
fish_add_path ~/.npm-global/bin 
fish_add_path /opt/nvim-linux64/bin 
fish_add_path /opt/homebrew/bin 
fish_add_path /opt/homebrew/sbin

set BAT_THEME gruvbox-dark
# expires 2024-11-21 + 30 days
# github container registry
set CR_PAT $(pass ghcr-token)
set JIRA_HOST jira.int.corp.sun
set KUBECONFIG ~/.kube/config
set GREP_OPTIONS '--color=auto'
set TERM xterm-color
set CLICOLOR 1

alias cat bat
alias e nvim
alias v nvim
alias vim nvim
alias lg lazygit
alias reload "source ~/.config/fish/config.fish"
alias docker="sudo docker"
alias docker-tools="sudo docker exec -it tools /bin/bash"
alias compose-up="sudo docker compose -f ~/config/docker/core.yml up -d"
alias python="python3.11"

if status is-interactive
    # Commands to run in interactive sessions can go here

    zoxide init fish | source
    kubectl completion fish | source
end

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
end
