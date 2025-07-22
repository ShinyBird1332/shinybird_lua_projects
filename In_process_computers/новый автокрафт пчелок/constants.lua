local constants = {}

constants.comp = require("component")
constants.event = require("event")
constants.term = require("term")
constants.sides = require("sides")
constants.serialization = require("serialization")

constants.side_chest_big = constants.sides.east
constants.side_chest_hive_in = constants.sides.south
constants.side_chest_out = constants.sides.west
constants.side_chest_trash = constants.sides.up

return constants
