local constants = {}

constants.comp = require("component")
constants.event = require("event")
constants.unicode = require("unicode")
constants.term = require("term")
constants.sides = require("sides")
constants.serialization = require("serialization")

constants.side_chest_big = constants.sides.east
constants.side_chest_hive_in = constants.sides.south
constants.side_chest_out = constants.sides.west
constants.side_chest_trash = constants.sides.up

constants.gpu = constants.comp.gpu

constants.w, constants.h = constants.gpu.getResolution()

constants.colors = {
    red = 0x940000,
    white = 0xFFFFFF,
    black = 0x000000,
    green = 0x086300,
    gray = 0x7a7a7a,
    yellow = 0xc29800
}

return constants
