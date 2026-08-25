local wezterm = require("wezterm")
local is_wayland = os.getenv("XDG_SESSION_TYPE") == "wayland"
    or (os.getenv("WAYLAND_DISPLAY") or "") ~= ""

local function jetbrains_mono(spec)
    return wezterm.font_with_fallback({
        {
            family = "JetBrains Mono",
            weight = spec.weight,
            style = spec.style,
        },
        {
            family = "Symbols Nerd Font Mono",
        },
    })
end

local risk_colors = {
    PROD = "#fa5750",
    PREPROD = "#dbb32d",
    NONPROD = "#75b938",
    UNK = "#72898f",
}

local function middle_ellipsis(text, max_width)
    if text == nil or text == "" then
        return ""
    end

    if wezterm.column_width(text) <= max_width then
        return text
    end

    local ellipsis = "..."
    local ellipsis_width = wezterm.column_width(ellipsis)
    if max_width <= ellipsis_width then
        return wezterm.truncate_right(text, max_width)
    end

    local keep = max_width - ellipsis_width
    local keep_left = math.floor(keep / 2)
    local keep_right = keep - keep_left
    return wezterm.truncate_right(text, keep_left)
        .. ellipsis
        .. wezterm.truncate_left(text, keep_right)
end

local function update_context_status(window, pane)
    local user_vars = pane:get_user_vars() or {}
    local git_icon = wezterm.nerdfonts.dev_git_branch or wezterm.nerdfonts.md_git or "git:"
    local aws_icon = wezterm.nerdfonts.dev_aws or wezterm.nerdfonts.md_aws or "aws:"
    local k8s_icon = wezterm.nerdfonts.md_kubernetes or "k8s:"
    local git = user_vars.GIT_STATUS_DISPLAY or user_vars.GIT_STATUS or ""
    local aws = user_vars.AWS_PROFILE_DISPLAY or user_vars.AWS_PROFILE or ""
    local k8s = user_vars.K8S_CONTEXT_DISPLAY or user_vars.K8S_CONTEXT or ""
    local risk = user_vars.CONTEXT_RISK or ""
    local risk_color = risk_colors[risk] or risk_colors.UNK

    if git == "<none>" then
        git = ""
    else
        if git:sub(1, 4) == "git:" then
            git = git:sub(5)
            git = git:gsub("^%s+", "")
        end
        git = middle_ellipsis(git, 42)
    end
    aws = middle_ellipsis(aws, 28)
    k8s = middle_ellipsis(k8s, 36)

    local status = {}

    if risk ~= "" then
        table.insert(status, { Foreground = { Color = risk_color } })
        table.insert(status, { Text = "[" .. risk .. "] " })
    end
    if git ~= "" then
        table.insert(status, { Foreground = { Color = "#F05033" } })
        table.insert(status, { Attribute = { Intensity = "Bold" } })
        table.insert(status, { Text = git_icon .. " " })
        table.insert(status, { Attribute = { Intensity = "Normal" } })
        table.insert(status, { Foreground = { Color = "#cad8d9" } })
        table.insert(status, { Text = git .. "  " })
    end
    if aws ~= "" then
        table.insert(status, { Foreground = { Color = "#FF9900" } })
        table.insert(status, { Attribute = { Intensity = "Bold" } })
        table.insert(status, { Text = aws_icon .. " " })
        table.insert(status, { Attribute = { Intensity = "Normal" } })
        table.insert(status, { Foreground = { Color = "#cad8d9" } })
        table.insert(status, { Text = aws .. "  " })
    end
    if k8s ~= "" then
        table.insert(status, { Foreground = { Color = "#326CE5" } })
        table.insert(status, { Attribute = { Intensity = "Bold" } })
        table.insert(status, { Text = k8s_icon .. " " })
        table.insert(status, { Attribute = { Intensity = "Normal" } })
        table.insert(status, { Foreground = { Color = "#cad8d9" } })
        table.insert(status, { Text = k8s })
    end

    if #status == 0 then
        window:set_right_status("")
        return
    end

    window:set_right_status(wezterm.format(status))
end

wezterm.on("update-status", function(window, pane)
    update_context_status(window, pane)
end)

local config = wezterm.config_builder()
config:set_strict_mode(true)

config.colors = {
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
}

config.font = jetbrains_mono({ weight = "Regular", style = "Normal" })
config.font_size = 16.0
config.font_rules = {
    {
        intensity = 'Bold',
        italic = false,
        font = jetbrains_mono({ weight = "Bold", style = "Normal" }),
    },
    {
        intensity = 'Normal',
        italic = true,
        font = jetbrains_mono({ weight = "Regular", style = "Italic" }),
    },
    {
        intensity = 'Bold',
        italic = true,
        font = jetbrains_mono({ weight = "Bold", style = "Italic" }),
    },
}

config.audible_bell = "Disabled"
config.notification_handling = "NeverShow"
config.window_close_confirmation = "NeverPrompt"
config.window_frame = {
    font_size = 18.0,
}

if wezterm.target_triple == 'aarch64-apple-darwin' then
    config.default_prog = { '/bin/zsh' }
else
    config.default_prog = { '/usr/bin/env', 'zsh' }
    if is_wayland then
        -- Mutter does not provide usable server-side decorations for WezTerm.
        -- Keep the tab bar as the only title area while retaining resize support.
        config.window_decorations = "RESIZE"
    end
end

return config
