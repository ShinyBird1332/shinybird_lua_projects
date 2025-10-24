local comp = require("component") 
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller
local redstone = comp.redstone

function search_flint()
    robot.turnLeft()

    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)
        if item and item.label == 'Dream Flint' then
            i_c.suckFromSlot(sides.front, i, 1)
            break
        end
    end

    robot.turnRight()
end

function main()
    robot.select(1)
    search_flint()
    robot.place()

    redstone.setOutput(sides.down, 16)
    os.sleep(1)
    repeat--если меч не бесконечный, надо добавить доп проверку на наличие моба, а то робот иногда не видит
        robot.swing()
        os.sleep(0.2)
    until not robot.detect() --мб тут сделать цикл из 2-3 секунд
    redstone.setOutput(sides.down, 0)
    
    robot.turnLeft()
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item then
            robot.select(i)
            robot.drop()
        end
    end
    robot.turnRight()
end

while true do
    main()
    os.sleep(2)
end