local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local programs = require("programs")

local menu = {}

menu.awesome = {
    { "hotkeys", function()
        return false, hotkeys_popup.show_help
    end },
    { "manual", programs.terminal .. " -e man awesome" },
    { "edit config", programs.editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function()
        awesome.quit()
    end }
}

menu.main = awful.menu({
    items = {
        { "awesome", menu.awesome, beautiful.awesome_icon },
        { "flow", "calligraflow" },
        { "datagrip", "datagrip" },
        { "yEd", "yed" },
        { "sql-developer", "oracle-sqldeveloper" },
        { "virt-manager", "virt-manager" },
        { "open terminal", programs.terminal }
    }
})

function menu.toggle()
    menu.main:toggle()
end

return menu
