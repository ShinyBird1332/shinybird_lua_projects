local constants = {}

constants.comp = require("component") 
constants.sides = require("sides")
constants.robot = require("robot")
constants.g = constants.comp.generator
constants.i_c = constants.comp.inventory_controller

constants.SIZE = 16

constants.COUNT_COAL = 2 -- Количество угля, хранящегося в генераторе робота. Не больше 8!
constants.COUNT_ITEM_GRAB = 48 -- Количество предметов для извлечения из сундука. Не больше 64!

constants.SLOT_KEY = 13 -- Слот с гаечным ключом
constants.SLOT_TANK = 14 -- Слот с резервуаром для охлаждающей жидкости реактора (например: криотеум)
constants.SLOT_CHEST = 15 -- Слот с сундуком, в котором будут все ресурсы для постройки
constants.SLOT_COAL = 16  --Слот для угля или угольных блоков (для работы хватило 16 угольных блоков)

constants.resourses = { 
    ["Reactor Casing"] = 2210,
    ["Reactor Controller"] = 1,
    ["Reactor Control Rod"] = 98,
    ["Yellorium Fuel Rod"] = 2940,
    ["Reactor Access Port"] = 2,
    ["Reactor Power Tap"] = 1,
    ["Destabilized Redstone Drum"] = 1,
    ["Reactor Computer Port"] = 1

}

constants.actions = {
    ["func_forward"] = {constants.robot.swing, constants.robot.detect, constants.robot.forward},
    ["func_up"] = {constants.robot.swingUp, constants.robot.detectUp, constants.robot.up},
    ["func_down"] = {constants.robot.swingDown, constants.robot.detectDown, constants.robot.down}
}

return constants