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

constants.main_trans_craft = constants.comp.proxy("20a0be72-e470-4b47-8634-b4e8debb37be")

constants.trans_craft = {
    ["Reactor Casing"] = {transposer = constants.comp.proxy("38cc7dca-f832-4cc2-8b2f-d1ca4ceb0eed"), mb = 5, count = 2210},
    ["Reactor Controller"] = {transposer = constants.comp.proxy("c203a636-b8c2-4d0e-9896-321d17dc3522"), mb = 89, count = 1},
    ["Reactor Control Rod"] = {transposer = constants.comp.proxy("7885a746-1289-4634-a788-7df650635563"), mb = 36, count = 98},
    ["Yellorium Fuel Rod"] = {transposer = constants.comp.proxy("015e9812-bff7-430b-8a49-e0c042b313e0"), mb = 20, count = 2940},
    ["Reactor Access Port"] = {transposer = constants.comp.proxy("0a734a88-9f52-4f0d-99b2-013a0de8625e"), mb = 78, count = 2},
    ["Reactor Power Tap"] = {transposer = constants.comp.proxy("8d96cdd7-8c80-4369-a9cb-9f78103b5920"), mb = 25, count = 1}
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