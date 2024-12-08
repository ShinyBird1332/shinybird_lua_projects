local constants = {}

constants.comp = require("component") 
constants.sides = require("sides")
constants.robot = require("robot")
constants.g = constants.comp.generator
constants.i_c = constants.comp.inventory_controller

constants.SIZE = 15
constants.SLOT_KEY = 13
constants.SLOT_TANK = 14
constants.SLOT_CHEST = 15
constants.SLOT_COAL = 16

constants.coolant_positions = {
    {2, 2}, {2, 6}, 
    {9, 2}, {9, 6}, 
    {2, 9}, {2, 13},
    {9, 9}, {9, 13} 
}

constants.resourses = { 
    ["Reactor Casing"] = 479,
    ["Reactor Controller"] = 1,
    ["Reactor Control Rod"] = 26,
    ["Yellorium Fuel Rod"] = 26,
    ["Reactor Access Port"] = 3,
    ["Reactor Coolant Port"] = 8,

    ["Turbine Housing"] = 1724,
    ["Turbine Controller"] = 4,
    ["Turbine Power Port"] = 4,
    ["Turbine Fluid Port"] = 8,
    ["Turbine Rotor Shaft"] = 64,
    ["Turbine Rotor Blade"] = 320,
    ["Turbine Rotor Bearing"] = 4,
    ["Ludicrite Block"] = 128
}

constants.actions = {
    ["func_forward"] = {constants.robot.swing, constants.robot.detect, constants.robot.forward},
    ["func_up"] = {constants.robot.swingUp, constants.robot.detectUp, constants.robot.up},
    ["func_down"] = {constants.robot.swingDown, constants.robot.detectDown, constants.robot.down}
}

return constants