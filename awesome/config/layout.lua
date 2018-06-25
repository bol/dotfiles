local table = require("gears.table")
local filesystem = require("gears.filesystem")
local wallpaper = require("gears.wallpaper")

local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")

local modkey = require("keys").modkey

local layout = {}

-- Themes define colours, icons, font and wallpapers.
beautiful.init(filesystem.get_configuration_dir() .. "themes/powerarrow-darker/theme.lua")

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.spiral,
    awful.layout.suit.magnifier
}

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1

function layout.set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local bwallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(bwallpaper) == "function" then
            bwallpaper = bwallpaper(s)
        end
        wallpaper.maximized(bwallpaper, s, true)
    end
end

-- {{{ Wibox
local separators = lain.util.separators
local clock = wibox.widget.textclock()
lain.widget.calendar({
    attach_to = { clock },
})

-- MEM
local memicon = wibox.widget.imagebox(beautiful.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
})

-- / fs
local fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
local fsroot = lain.widget.fs({
    notification_preset = { fg = beautiful.fg_normal, bg = beautiful.bg_normal, font = "Terminus 10" },
    settings = function()
        widget:set_text("/: " .. fs_now["/"].percentage .. "%")
    end
})

-- Volume
local volicon = wibox.widget.imagebox(beautiful.widget_vol)
local volume = lain.widget.pulsebar()

-- Separators
local spr = wibox.widget.textbox(' ')
local arrl_dl = separators.arrow_left(beautiful.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus)

-- }}}

-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = table.join(
        awful.button({ }, 1, function(t)
            t:view_only()
        end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({ }, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),
        awful.button({ }, 5, function(t)
            awful.tag.viewprev(t.screen)
        end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    layout.set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(table.join(
            awful.button({ }, 1, function()
                awful.layout.inc(1)
            end),
            awful.button({ }, 3, function()
                awful.layout.inc(-1)
            end),
            awful.button({ }, 4, function()
                awful.layout.inc(1)
            end),
            awful.button({ }, 5, function()
                awful.layout.inc(-1)
            end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            spr,
            arrl_ld,
            wibox.container.background(cpuicon, beautiful.bg_focus),
            wibox.container.background(cpu.widget, beautiful.bg_focus),
            arrl_dl,
            memicon,
            mem.widget,
            arrl_ld,
            wibox.container.background(fsicon, beautiful.bg_focus),
            wibox.container.background(fsroot.widget, beautiful.bg_focus),
            arrl_dl,
            volicon,
            volume.widget,
            arrl_ld,
            wibox.container.background(clock, beautiful.bg_focus),
            s.mylayoutbox,
        },
    }
end)

function layout.titlebar(c)
    -- buttons for the titlebar
    local buttons = table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end

-- {{{ Signals
-- Signal function to execute when a new client appears.
function layout.manage(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
            not c.size_hints.user_position
            and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end

function layout.mouse_enter(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
        client.focus = c
    end
end

function layout.focus(c)
    c.border_color = beautiful.border_focus
end

function layout.unfocus(c)
    c.border_color = beautiful.border_normal
end

return layout
