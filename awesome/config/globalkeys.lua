local table = require("gears.table")
local key = require("awful.key")

local tag = require("awful.tag")
local client = require("awful.client")
local screen = require("awful.screen")
local layout = require("awful.layout")
local prompt = require("awful.prompt")
local spawn = require("awful.util").spawn
local eval = require("awful.util").eval
local get_cache_dir = require("awful.util").get_cache_dir
local hotkeys_popup = require("awful.hotkeys_popup").widget
local naughty = require("naughty")

local programs = require("programs")
local menu = require("menu")

local modkey = require("keys").modkey

local globalkeys = table.join(
        key({ modkey, }, "s",
                function()
                    hotkeys_popup.show_help()
                end,
                { description = "show help", group = "awesome" }
        ),
        key({ modkey, }, "Left",
                function()
                    tag.viewprev()
                end,
                { description = "view previous", group = "tag" }
        ),
        key({ modkey, }, "Right",
                function()
                    tag.viewnext()
                end,
                { description = "view next", group = "tag" }
        ),
        key({ modkey, }, "Escape",
                function()
                    tag.history.restore()
                end,
                { description = "go back", group = "tag" }
        ),
        key({ modkey, }, "j",
                function()
                    client.focus.byidx(1)
                end,
                { description = "focus next by index", group = "client" }
        ),
        key({ modkey, }, "k",
                function()
                    client.focus.byidx(-1)
                end,
                { description = "focus previous by index", group = "client" }
        ),
        key({ modkey, }, "w",
                function()
                    menu.main:show()
                end,
                { description = "show main menu", group = "awesome" }
        ),

        key({}, "Print",
                function()
                    spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'")
                    naughty.notify({ text = "Taking screenshot", timeout = 2 })
                end,
                { description = "take screenshot", group = "awesome" }
        ),

        key({}, "Scroll_Lock",
                function()
                    spawn(programs.lock_cmd)
                end,
                { description = "lock screen", group = "awesome" }
        ),

-- Layout manipulation
        key({ modkey, "Shift" }, "j",
                function()
                    client.swap.byidx(1)
                end,
                { description = "swap with next client by index", group = "client" }
        ),
        key({ modkey, "Shift" }, "k",
                function()
                    client.swap.byidx(-1)
                end,
                { description = "swap with previous client by index", group = "client" }
        ),
        key({ modkey, "Control" }, "j",
                function()
                    screen.focus_relative(1)
                end,
                { description = "focus the next screen", group = "screen" }
        ),
        key({ modkey, "Control" }, "k",
                function()
                    screen.focus_relative(-1)
                end,
                { description = "focus the previous screen", group = "screen" }
        ),
        key({ modkey, }, "u",
                client.urgent.jumpto,
                { description = "jump to urgent client", group = "client" }
        ),
        key({ modkey, }, "Tab",
                function()
                    client.focus.history.previous()
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                { description = "go back", group = "client" }
        ),
-- Standard program
        key({ modkey, }, "Return",
                function()
                    spawn(programs.terminal)
                end,
                { description = "open a terminal", group = "launcher" }
        ),
        key({ modkey, "Control" }, "r",
                awesome.restart,
                { description = "reload awesome", group = "awesome" }
        ),
        key({ modkey, "Shift" }, "q",
                awesome.quit,
                { description = "quit awesome", group = "awesome" }
        ),
-- Sound
        key({ modkey, }, "KP_Add",
                function()
                    spawn("pulseaudio-ctl up")
                end),
        key({ modkey, }, "KP_Subtract",
                function()
                    spawn("pulseaudio-ctl down")
                end),

        key({ modkey, }, "l",
                function()
                    tag.incmwfact(0.05)
                end,
                { description = "increase master width factor", group = "layout" }
        ),
        key({ modkey, }, "h",
                function()
                    tag.incmwfact(-0.05)
                end,
                { description = "decrease master width factor", group = "layout" }
        ),
        key({ modkey, "Shift" }, "h",
                function()
                    tag.incnmaster(1, nil, true)
                end,
                { description = "increase the number of master clients", group = "layout" }
        ),
        key({ modkey, "Shift" }, "l",
                function()
                    tag.incnmaster(-1, nil, true)
                end,
                { description = "decrease the number of master clients", group = "layout" }
        ),
        key({ modkey, "Control" }, "h",
                function()
                    tag.incncol(1, nil, true)
                end,
                { description = "increase the number of columns", group = "layout" }
        ),
        key({ modkey, "Control" }, "l",
                function()
                    tag.incncol(-1, nil, true)
                end,
                { description = "decrease the number of columns", group = "layout" }
        ),
        key({ modkey, }, "space",
                function()
                    layout.inc(1)
                end,
                { description = "select next", group = "layout" }
        ),
        key({ modkey, "Shift" }, "space",
                function()
                    layout.inc(-1)
                end,
                { description = "select previous", group = "layout" }
        ),
        key({ modkey, "Control" }, "n",
                function()
                    local c = client.restore()
                    -- Focus restored client
                    if c then
                        client.focus = c
                        c:raise()
                    end
                end,
                { description = "restore minimized", group = "client" }
        ),
-- Prompt
        key({ modkey }, "r",
                function()
                    screen.focused().mypromptbox:run()
                end,
                { description = "run prompt", group = "launcher" }
        ),
        key({ modkey }, "x",
                function()
                    prompt.run {
                        prompt = "Run Lua code: ",
                        textbox = screen.focused().mypromptbox.widget,
                        exe_callback = eval,
                        history_path = get_cache_dir() .. "/history_eval"
                    }
                end,
                { description = "lua execute prompt", group = "awesome" }
        )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = table.join(globalkeys,
    -- View tag only.
            key({ modkey }, "#" .. i + 9,
                    function()
                        local t = screen.focused().tags[i]
                        if t then
                            t:view_only()
                        end
                    end,
                    { description = "view tag #" .. i, group = "tag" }
            ),
    -- Toggle tag display.
            key({ modkey, "Control" }, "#" .. i + 9,
                    function()
                        local t = screen.focused().tags[i]
                        if t then
                            tag.viewtoggle(t)
                        end
                    end,
                    { description = "toggle tag #" .. i, group = "tag" }
            ))
end

return globalkeys
