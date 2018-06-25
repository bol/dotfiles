local table = require("gears.table")
local key = require("awful.key")
local aclient = require("awful.client")

local modkey = require("keys").modkey

local clientkeys = table.join(
        key({ modkey, }, "f",
                function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                { description = "toggle fullscreen", group = "client" }
        ),
        key({ modkey, "Shift" }, "c",
                function(c)
                    c:kill()
                end,
                { description = "close", group = "client" }
        ),
        key({ modkey, "Control" }, "space",
                aclient.floating.toggle,
                { description = "toggle floating", group = "client" }
        ),
        key({ modkey, "Control" }, "Return",
                function(c)
                    c:swap(aclient.getmaster())
                end,
                { description = "move to master", group = "client" }
        ),
        key({ modkey, }, "o",
                function(c)
                    c:move_to_screen()
                end,
                { description = "move to screen", group = "client" }
        ),
        key({ modkey, }, "t",
                function(c)
                    c.ontop = not c.ontop
                end,
                { description = "toggle keep on top", group = "client" }
        ),
        key({ modkey, }, "n",
                function(c)
                    -- The client currently has the input focus, so it cannot be
                    -- minimized, since minimized clients can't have the focus.
                    c.minimized = true
                end,
                { description = "minimize", group = "client" }
        ),
        key({ modkey, }, "m",
                function(c)
                    c.maximized = not c.maximized
                    c:raise()
                end,
                { description = "maximize", group = "client" }
        )
)

for i = 1, 9 do
    clientkeys = table.join(clientkeys,
    -- Move client to tag.
            key({ modkey, "Shift" }, "#" .. i + 9,
                    function(c)
                        if client.focus then
                            local t = client.focus.screen.tags[i]
                            if t then
                                client.focus:move_to_tag(t)
                            end
                        end
                    end,
                    { description = "move focused client to tag #" .. i, group = "tag" }
            ),
    -- Toggle tag on focused client.
            key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                    function(c)
                        if client.focus then
                            local t = client.focus.screen.tags[i]
                            if t then
                                client.focus:toggle_tag(t)
                            end
                        end
                    end,
                    { description = "toggle focused client on tag #" .. i, group = "tag" }
            )
    )
end

return clientkeys
