local table = require("gears.table")
local button = require("awful.button")
local mouse = require("awful.mouse")

local modkey = require("keys").modkey

return table.join(
        button({ }, 1,
                function(c)
                    client.focus = c;
                    c:raise()
                end),
        button({ modkey }, 1, mouse.client.move),
        button({ modkey }, 3, mouse.client.resize)
)
