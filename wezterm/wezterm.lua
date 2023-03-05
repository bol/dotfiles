local wezterm = require("wezterm")

local config = {
    color_scheme = "Builtin Solarized Dark",

    font = wezterm.font("MesloLGM Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
    font_size = 16.0,
    hide_tab_bar_if_only_one_tab = true,
    audible_bell = "Disabled",
}

if wezterm.target_triple == 'aarch64-apple-darwin' or wezterm.target_triple == 'x86_64-apple-darwin' then
    config.default_prog = { '/opt/homebrew/bin/tmux' }
else
    config.default_prog = { '/usr/bin/env', 'zsh' }
end

return config
