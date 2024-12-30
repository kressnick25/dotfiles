if status is-interactive
    # Commands to run in interactive sessions can go here

    zoxide init fish | source
    kubectl completion fish | source
end

set PATH ~/.local/bin $PATH
set PATH /usr/local/go/bin $PATH
set PATH ~/go/bin $PATH
set PATH ~/.local/opt/yazi $PATH
set PATH ~/.npm-global/bin $PATH

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

