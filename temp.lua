--ставим робота на сбор цветков и автоматизацию ботании
--вручную доходим до магических семян и рунического алтаря
--ставим на автокрафт все остальные свитки изучения


--робот для разворачивания системы автокрафта наполненных панелей с крафтом активатора матрицы

--перед началом, надо как-то сделать автокрафт маг предметов

local comp = require("component")
local sides = require("sides")
local trans = comp.transposer

c = trans.getInventorySize(sides.up)
print(c)

local redstone = comp.redstone

while true do
    print(redstone.getInput(sides.east))
    os.sleep(0.5)
end