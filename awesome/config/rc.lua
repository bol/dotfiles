-- Standard awesome library
local awful = require("awful")

-- Notification library
local naughty = require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Local modules
local layout = require("layout")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", layout.set_wallpaper)

client.disconnect_signal("request::geometry", awful.ewmh.client_geometry_requests)
client.connect_signal("manage", layout.manage)
client.connect_signal("request::titlebars", layout.titlebar)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", layout.mouse_enter)
client.connect_signal("focus", layout.focus)
client.connect_signal("unfocus", layout.unfocus)


root.keys(require("globalkeys"))
root.buttons(require("globalbuttons"))

require("rules")
