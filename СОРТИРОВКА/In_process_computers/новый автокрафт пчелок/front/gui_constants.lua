local gui_constants = {}

gui_constants.comp = require("component")
gui_constants.event = require("event")
gui_constants.unicode = require("unicode")
gui_constants.term = require("term")
gui_constants.serialization = require("serialization")

gui_constants.gpu = gui_constants.comp.gpu

gui_constants.w, gui_constants.h = gui_constants.gpu.getResolution()

gui_constants.sep = 2
gui_constants.start_x_first = 10
gui_constants.start_y_first = 5
gui_constants.wigth_first = gui_constants.w - gui_constants.start_x_first * 2
gui_constants.height_first = gui_constants.h - gui_constants.start_y_first * 2

gui_constants.colors = {
    red = 0x940000,
    white = 0xFFFFFF,
    black = 0x000000,
    green = 0x086300,
    gray = 0x7a7a7a,
    yellow = 0xc29800
}

return gui_constants
