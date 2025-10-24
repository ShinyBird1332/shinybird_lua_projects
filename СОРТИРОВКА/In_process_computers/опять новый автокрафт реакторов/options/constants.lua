local constants = {}

constants.trans_craft = {
    ["Reactor Casing"] = {transposer = constants.comp.proxy(""), mb = 5, count = 2210},
    ["Reactor Controller"] = {transposer = constants.comp.proxy(""), mb = 89, count = 1},
    ["Reactor Control Rod"] = {transposer = constants.comp.proxy(""), mb = 36, count = 98},
    ["Yellorium Fuel Rod"] = {transposer = constants.comp.proxy(""), mb = 20, count = 2940},
    ["Reactor Access Port"] = {transposer = constants.comp.proxy(""), mb = 78, count = 2},
    ["Reactor Power Tap"] = {transposer = constants.comp.proxy(""), mb = 25, count = 1},
    ["Reactor Computer Port"] = {transposer = constants.comp.proxy(""), mb = 47, count = 1}
}

constants.robot_dig = constants.comp.proxy("")
constants.robot_build = constants.comp.proxy("")

constants.main_trans_craft = constants.comp.proxy("")
constants.trans_tank = constants.comp.proxy("")

constants.comp = require("component")
constants.event = require("event")
constants.unicode = require("unicode")
constants.term = require("term")
constants.sides = require("sides")
constants.serialization = require("serialization")

constants.side_trans_result_craft = constants.sides.up
constants.side_trans_in_mat = constants.sides.down
constants.side_trans_out_mat = constants.sides.up
constants.side_trans_redstone_storage = constants.sides.up

constants.gpu = constants.comp.gpu
constants.modem = constants.comp.modem

constants.w, constants.h = constants.gpu.getResolution()

constants.modem.open(4)

constants.reactors = {}
for i in pairs(constants.comp.list("br_reactor")) do
    table.insert(constants.reactors, constants.comp.proxy(i))
end

constants.liquid_redstone = 100000
constants.colors = {
    red = 0x940000,
    white = 0xFFFFFF,
    black = 0x000000,
    green = 0x086300,
    gray = 0x7a7a7a,
    yellow = 0xc29800
}

return constants