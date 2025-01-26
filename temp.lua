--ставим робота на сбор цветков и автоматизацию ботании
--вручную доходим до магических семян и рунического алтаря
--ставим на автокрафт все остальные свитки изучения

local comp = require("component")
local sides = require("sides")

local redstone = comp.redstone

while true do
    print(redstone.getInput(sides.east))
    os.sleep(0.5)
end