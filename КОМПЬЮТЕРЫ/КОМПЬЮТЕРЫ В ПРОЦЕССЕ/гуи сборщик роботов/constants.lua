local constants = {}

constants.comp = require("component")
constants.event = require("event")
constants.unicode = require("unicode")
constants.term = require("term")
constants.sides = require("sides")

constants.gpu = constants.comp.gpu
constants.me_interface = constants.comp.me_interface
constants.me_exportbus = constants.comp.me_exportbus
constants.database = constants.comp.database
constants.trans = constants.comp.transposer
constants.assembler = constants.comp.assembler

constants.side_trans = constants.sides.east
constants.side_trans_out_trash = constants.sides.south
constants.side_trans_out_ass = constants.sides.west
constants.side_me_bus = constants.sides.north

constants.trans_1 = constants.comp.proxy("8bbc02b0-5084-4c4e-918a-59183b55b672")
--constants.trans_2 = constants.comp.proxy("ab618f26-4ade-422a-8d72-65b8e75862a1")


constants.db_slot = 1 
constants.me_bus_slot = 1 

-- Размеры кнопок
constants.BTN_HEIGHT = 4
constants.BTN_WIDTH = 22

-- Цвета
constants.colors = {
    red = 0x940000,
    white = 0xFFFFFF,
    black = 0x000000,
    green = 0x086300,
    gray = 0x7a7a7a
}

--обязательные компоненты
constants.required_components = {
    "Screen (Tier 1)", --1
    "Disk Drive", --2
    "Keyboard", -- 1
    "EEPROM (Lua BIOS)" --0
}

--дополнительные кнопки
constants.control_buttons = {
    {text = "Старт", x = 3, y = 45, action = "start"},
    {text = "Стоп", x = 3 + constants.BTN_WIDTH + 4, y = 45, action = "stop"},
    {text = "Сброс выбора", x = 3 + 2 * (constants.BTN_WIDTH + 4), y = 45, action = "clear"},
    {text = "Сложность:", x = 110, y = 3, action = ""}
}

-- Таблица компонентов
constants.choise_components = {
    {name_craft = "Computer Case (Tier 1)", btn_text = "Корпус 1", tier = 1, difficult = 12, required = true}, --+
    {name_craft = "Computer Case (Tier 2)", btn_text = "Корпус 2", tier = 2, difficult = 18, required = true}, 
    {name_craft = "Computer Case (Tier 3)", btn_text = "Корпус 3", tier = 3, difficult = 20, required = true}, 
    {name_craft = "Memory (Tier 1)", btn_text = "Память 1", tier = 1, difficult = 1, required = true}, 
    {name_craft = "Memory (Tier 2)", btn_text = "Память 2", tier = 2, difficult = 2, required = true}, 
    {name_craft = "Memory (Tier 3)", btn_text = "Память 3", tier = 3, difficult = 3, required = true}, 
    {name_craft = "Hard Disk Drive (Tier 1) (1MB)", btn_text = "Диск 1", tier = 1, difficult = 1, required = true}, 
    {name_craft = "Hard Disk Drive (Tier 2) (2MB)", btn_text = "Диск 2", tier = 2, difficult = 2, required = true}, 
    {name_craft = "Hard Disk Drive (Tier 3) (4MB)", btn_text = "Диск 3", tier = 3, difficult = 3, required = true}, 
    {name_craft = "Central Processing Unit (CPU) (Tier 1)", btn_text = "Процессор 1", tier = 1, difficult = 1, required = true}, --+
    {name_craft = "Central Processing Unit (CPU) (Tier 2)", btn_text = "Процессор 2", tier = 2, difficult = 1, required = true}, 
    {name_craft = "Central Processing Unit (CPU) (Tier 3)", btn_text = "Процессор 3", tier = 3, difficult = 1, required = true}, 
    {name_craft = "Battery Upgrade (Tier 1)", btn_text = "Доп аккум 1", tier = 1, difficult = 1, required = false}, 
    {name_craft = "Battery Upgrade (Tier 2)", btn_text = "Доп аккум 2", tier = 2, difficult = 2, required = false}, 
    {name_craft = "Battery Upgrade (Tier 3)", btn_text = "Доп аккум 3", tier = 3, difficult = 3, required = false}, 
    {name_craft = "Hover Upgrade (Tier 1)", btn_text = "Улyчш полет 1", tier = 1, difficult = 1, required = false}, 
    {name_craft = "Hover Upgrade (Tier 2)", btn_text = "Улyчш полет 2", tier = 2, difficult = 2, required = false}, 
    {name_craft = "Crafting Upgrade", btn_text = "Улучш крафт", tier = 2, difficult = 2, required = false}, 
    {name_craft = "Generator Upgrade", btn_text = "Улучш генератор", tier = 2, difficult = 2, required = false}, 
    {name_craft = "Solar Generator Upgrade", btn_text = "Улучш солн панель", tier = 2, difficult = 2, required = false}, 
    {name_craft = "Angel Upgrade", btn_text = "Улучш ангел", tier = 2, difficult = 2, required = false}, 
    {name_craft = "Experience Upgrade", btn_text = "Улучш опыт", tier = 3, difficult = 3, required = false}, 
    {name_craft = "Inventory Controller Upgrade", btn_text = "Улучш контрол инв", tier = 2, difficult = 2, required = false}, 
    {name_craft = "Tractor Beam Upgrade", btn_text = "Улучш магнит", tier = 3, difficult = 3, required = false}, 
    {name_craft = "Tank Upgrade", btn_text = "Улучш жидк хран", tier = 1, difficult = 1, required = false}, 
    {name_craft = "Tank Controller Upgrade", btn_text = "Улучш контрл жидк", tier = 2, difficult = 2, required = false},
    {name_craft = "Trading Upgrade", btn_text = "Улучш торгаш", tier = 2, difficult = 2, required = false},
    {name_craft = "Upgrade Container (Tier 1)", btn_text = "Контейнер 1", tier = 1, difficult = 1, required = false},
    {name_craft = "Upgrade Container (Tier 2)", btn_text = "Контейнер 2", tier = 2, difficult = 2, required = false},
    {name_craft = "Upgrade Container (Tier 3)", btn_text = "Контейнер 3", tier = 3, difficult = 3, required = false}
}

return constants