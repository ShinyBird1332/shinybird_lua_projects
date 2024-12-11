local constants = {}

constants.comp = require("component") 
constants.sides = require("sides")
constants.robot = require("robot")
constants.g = constants.comp.generator
constants.i_c = constants.comp.inventory_controller

constants.SIZE = 15

constants.COUNT_COAL = 2 -- Количество угля, хранящегося в генераторе робота. Не больше 8!
constants.COUNT_ITEM_GRAB = 48 -- Количество предметов для извлечения из сундука. Не больше 64!

constants.SLOT_KEY = 13 -- Слот с гаечным ключом
constants.SLOT_TANK = 14 -- Слот с резервуаром для охлаждающей жидкости реактора (например: криотеум)
constants.SLOT_CHEST = 15 -- Слот с сундуком, в котором будут все ресурсы для постройки
constants.SLOT_COAL = 16  --Слот для угля или угольных блоков (для работы хватило 16 угольных блоков)

constants.resourses = { 
    ["Reactor Casing"] = 479,
    ["Reactor Controller"] = 1,
    ["Reactor Control Rod"] = 26,
    ["Yellorium Fuel Rod"] = 26,
    ["Reactor Access Port"] = 3,
    ["Reactor Coolant Port"] = 9,

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