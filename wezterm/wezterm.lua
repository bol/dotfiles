local wezterm = require("wezterm")

local config = {
    colors = {
        foreground = "#adbcbc",
        background = "#103c48",
        cursor_bg = "#adbcbc",
        cursor_fg = "#103c48",
        cursor_border = "#adbcbc",
        selection_bg = "#184956",
        selection_fg = "#cad8d9",
        ansi = {
            "#184956",
            "#fa5750",
            "#75b938",
            "#dbb32d",
            "#4695f7",
            "#f275be",
            "#41c7b9",
            "#72898f",
        },
        brights = {
            "#2d5b69",
            "#ff665c",
            "#84c747",
            "#ebc13d",
            "#58a3ff",
            "#ff84cd",
            "#53d6c7",
            "#cad8d9",
        },
    },

    font = wezterm.font("MesloLGM Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
    font_size = 16.0,
    font_rules = {
        {
            intensity = 'Bold',
            italic = false,
            font = wezterm.font("MesloLGM Nerd Font", {
                weight = "Bold",
                stretch = "Normal",
                style = "Normal",
            }),
        },
        {
            intensity = 'Normal',
            italic = true,
            font = wezterm.font("MesloLGM Nerd Font", {
                weight = "Regular",
                stretch = "Normal",
                style = "Italic",
            }),
        },
        {
            intensity = 'Bold',
            italic = true,
            font = wezterm.font("MesloLGM Nerd Font", {
                weight = "Bold",
                stretch = "Normal",
                style = "Italic",
            }),
        },
    },

    hide_tab_bar_if_only_one_tab = true,
    audible_bell = "Disabled",
    window_close_confirmation = "NeverPrompt",
}

if wezterm.target_triple == 'aarch64-apple-darwin' or wezterm.target_triple == 'x86_64-apple-darwin' then
    config.default_prog = { '/opt/homebrew/bin/zsh' }
else
    config.default_prog = { '/usr/bin/env', 'zsh' }
end

return config
