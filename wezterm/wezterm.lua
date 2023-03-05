local wezterm = require("wezterm")

local config = {
    default_prog = { '/usr/bin/env', 'tmux' },

    color_scheme = "Builtin Solarized Dark",

    font = wezterm.font("MesloLGM Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}),
    font_size = 16.0,
    hide_tab_bar_if_only_one_tab = true,
    audible_bell = "Disabled",
}

return config