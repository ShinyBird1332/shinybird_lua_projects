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

constants.w, constants.h = constants.gpu.getResolution()

constants.main_trans_craft = constants.comp.proxy("d5b7ecca-245c-4796-868c-0f98c1b7c03d")
constants.trans_tank = constants.comp.proxy("b5dfbfd5-91f3-4471-890d-6859c68a563e")

constants.trans_craft = {
    ["Reactor Casing"] = {transposer = constants.comp.proxy("f2433e51-d0c2-49d8-915c-5fd31c6f869f"), mb = 5, count = 2210},
    ["Reactor Controller"] = {transposer = constants.comp.proxy("2f210503-a9dc-4648-a8e8-411b2cb5bb93"), mb = 89, count = 1},
    ["Reactor Control Rod"] = {transposer = constants.comp.proxy("bd57fd70-462e-4f20-8d89-835bc232c6ce"), mb = 36, count = 98},
    ["Yellorium Fuel Rod"] = {transposer = constants.comp.proxy("8c573b2e-9388-4432-aa4c-3afc1554f547"), mb = 20, count = 2940},
    ["Reactor Access Port"] = {transposer = constants.comp.proxy("fbf950f2-aafa-4f59-96fd-55431a683491"), mb = 78, count = 2},
    ["Reactor Power Tap"] = {transposer = constants.comp.proxy("9737eb42-1786-4a9d-b24d-87ea74d09e8c"), mb = 25, count = 1}
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