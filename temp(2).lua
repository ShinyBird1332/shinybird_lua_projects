local robot = require("robot")
local comp = require("component")
local sides = require("sides")
local i_c = comp.inventory_controller

--можно сделать массив со всеми способами, а потом, по надобности, нажать кнопку и поменять режим
--режим изменится только по завершению итерации цикла
--Bone Meal, Hoe of Grouth, Electric Hoe of Grouth



function main()
    while true do
        robot.swing()
        if robot.durability() < 0.5 then
            i_c.equip()
            robot.turnRight()
            robot.drop()
            robot.turnLeft()
        end
    end
end
  
main()
