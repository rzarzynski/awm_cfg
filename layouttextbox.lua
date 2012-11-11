---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @author Radoslaw Zarzynski
-- @copyright 2009 Julien Danjou
-- @copyright 2012 Radoslaw Zarzynski
-- @release v3.4.11
---------------------------------------------------------------------------

local setmetatable = setmetatable
local ipairs = ipairs
local button = require("awful.button")
local layout = require("awful.layout")
local tag = require("awful.tag")
local beautiful = require("beautiful")
local capi = { image = image,
               screen = screen,
               widget = widget }

--- Layouttextbox widget.
module("mywidgets.layouttextbox")

local function update(w, screen)
    local layout = layout.getname(layout.get(screen))

    if layout and beautiful["layout_txt_map"] then
        w.text = beautiful["layout_txt_map"][layout]
    else
        w.text = "&lt;" .. layout .. "&gt;"
    end
end

--- Create a layoutbox widget. It draws a picture with the current layout
-- symbol of the current tag.
-- @param screen The screen number that the layout will be represented for.
-- @param args Standard arguments for textbox widget.
-- @return A textbox widget configured as a layouttextbox.
function new(screen, args)
    local screen = screen or 1
    local args = args or {}
    args.type = "textbox"
    local w = capi.widget(args)
    update(w, screen)

    local function update_on_tag_selection(tag)
        return update(w, tag.screen)
    end

    tag.attached_add_signal(screen, "property::selected", update_on_tag_selection)
    tag.attached_add_signal(screen, "property::layout", update_on_tag_selection)

    return w
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
