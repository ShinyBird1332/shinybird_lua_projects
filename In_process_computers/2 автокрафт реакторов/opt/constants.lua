local constants = {}

constants.comp = require("component")
constants.event = require("event")
constants.unicode = require("unicode")
constants.term = require("term")
constants.sides = require("sides")

constants.side_trans_result_craft = constants.sides.north
constants.side_trans_in_mat = constants.sides.north
constants.side_trans_out_mat = constants.sides.south
constants.side_trans_redstone_storage = constants.sides.east

constants.gpu = constants.comp.gpu
constants.modem = constants.comp.modem

constants.w, constants.h = constants.gpu.getResolution()

constants.modem.open(4)

constants.robot_dig = constants.comp.proxy("")
constants.robot_build = constants.comp.proxy("")

constants.main_trans_craft = constants.comp.proxy("2fd25f0b-3896-47f5-8aaf-159bdc6fd1d8")
constants.trans_tank = constants.comp.proxy("7276b470-adc8-48ea-8521-9d0541c945e9")

constants.trans_craft = {
    ["Reactor Casing"] = {transposer = constants.comp.proxy("a6a7c666-960b-445e-a654-b316282b5716"), mb = 5, count = 2210},
    ["Reactor Controller"] = {transposer = constants.comp.proxy("1c66a7d3-58a6-45ff-af78-a28536c5a79e"), mb = 89, count = 1},
    ["Reactor Control Rod"] = {transposer = constants.comp.proxy("e6c4802c-3805-4688-bafb-1012eece32af"), mb = 36, count = 98},
    ["Yellorium Fuel Rod"] = {transposer = constants.comp.proxy("52dbf1ff-6705-4508-a3ef-fc65546187d4"), mb = 20, count = 2940},
    ["Reactor Access Port"] = {transposer = constants.comp.proxy("a4ad8c5e-7aa4-4c3c-a78b-8807137ba07d"), mb = 78, count = 2},
    ["Reactor Power Tap"] = {transposer = constants.comp.proxy("9773bf7a-548b-4717-8ec4-7a055e1d78b7"), mb = 25, count = 1},
    ["Reactor Computer Port"] = {transposer = constants.comp.proxy("db8b1a11-5cb8-4219-84e7-83bb3c28e04f"), mb = 47, count = 1}
}
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