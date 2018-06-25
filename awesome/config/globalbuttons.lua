local table = require("gears.table")
local button = require("awful.button")
local menu = require("menu")
local tag = require("awful.tag")

return table.join(
        button({ }, 3, menu.toggle),
        button({ }, 4, tag.viewnext),
        button({ }, 5, tag.viewprev)
)
