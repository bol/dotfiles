local beautiful = require("beautiful")
local awful = require("awful")
require("awful.hotkeys_popup.keys")

local rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = require("clientkeys"),
          buttons = require("clientbuttons"),
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap + awful.placement.no_offscreen
      }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA", -- Firefox addon DownThemAll.
            "copyq", -- Includes session name in class.
        },
        class = {
            "Arandr",
            "Gpick",
            "Kruler",
            "MessageWin", -- kalarm.
            "Sxiv",
            "Wpa_gui",
            "pinentry",
            "veromix",
            "MPlayer",
            "gimp",
            "Firefox",
            "xtightvncviewer" },

        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
      properties = { floating = true }
    },

    -- Fix Intellij popup menues
    {
        rule = {
            class = "jetbrains-.*",
            instance = "sun-awt-X11-XWindowPeer",
            name = "win.*"
        },
        properties = {
            floating = true,
            focus = true,
            focusable = false,
            ontop = true,
            placement = awful.placement.restore,
            buttons = {}
        }
    },
    {
        rule = {
            class = "jetbrains-.*",
            instance = "sun-awt-X11-XDialogPeer",
            name = "win.*"
        },
        properties = {
            floating = true,
            focus = true,
            focusable = false,
            ontop = true,
            placement = awful.placement.restore,
            buttons = {}
        }
    },
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

awful.rules.rules = rules

return rules
