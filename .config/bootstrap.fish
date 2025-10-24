#!/usr/bin/env fish

if not type -q fisher 
    echo "fisher not found. Installing from source"
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

set _fisher_plugins "jorgebucaran/autopair.fish" "patrickf1/fzf.fish" "pure-fish/pure"
set _fisher_installed_plugins (fisher list | string split \n)
for plugin in $_fisher_plugins
    if not contains $plugin $_fisher_installed_plugins
        fisher install $plugin
    else
        echo "fisher plugin already installed: $plugin"
    end
end

fzf_configure_bindings
