local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller

function search_clock(item)
    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label == item and robot_slot.size > 0 then
            robot.select(i)
            return
        end
    end

    for i = 1, i_c.getInventorySize(sides.front) do
        local chest_item = i_c.getStackInSlot(sides.front, i)
        if chest_item and chest_item.label == item then
            robot.select(1)
            i_c.suckFromSlot(sides.front, i, 48)
            break
        end
    end

    search_clock(item)
end

function clear_inventory()
    for i = 1, robot.inventorySize() do
        robot.select(i)
        robot.drop()
    end
    robot.select(1)
end

function main()
    robot.turnAround()
    search_clock("Mysterious Clock")
    robot.turnAround()
    robot.placeUp()

    repeat
        robot.swingUp()
        os.sleep(0.2)
    until not robot.detectUp()

    robot.turnRight()
    clear_inventory()
    robot.turnLeft()
end

while true do
    main()
end