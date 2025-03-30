if status is-interactive
    # Commands to run in interactive sessions can go here

    zoxide init fish | source
    kubectl completion fish | source
end

fish_add_path ~/.local/bin
fish_add_path /usr/local/go/bin
fish_add_path ~/go/bin
fish_add_path ~/.local/opt/yazi
fish_add_path ~/.npm-global/bin
fish_add_path /opt/nvim/bin

set BAT_THEME gruvbox-dark
# expires 2024-11-21 + 30 days
# github container registry
set CR_PAT (pass ghcr-token)
set JIRA_HOST jira.int.corp.sun
set KUBECONFIG ~/.kube/config


alias cat bat
alias e nvim
alias v nvim
alias vim nvim
alias lg lazygit
alias reload "source ~/.config/fish/config.fish"
alias erc "nvim ~/.config/fish/config.fish"

# source ~/.venv/bin/activate

function ssh-copy-terminfo -d "Copy terminfo to remote SSH server"
    infocmp -x | ssh $argv -- tic -x -
end
