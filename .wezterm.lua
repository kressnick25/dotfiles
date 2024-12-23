local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- COLOR SCHEME & FONTS
config.color_scheme = 'catppuccin-mocha'
config.font = wezterm.font('CaskaydiaMono Nerd Font Mono', {})

-- HYPERLINKS
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = 'https://www.github.com/$1/$3',
})

-- PLUGINS
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

-- MISC
config.audible_bell = "Disabled"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

return config
