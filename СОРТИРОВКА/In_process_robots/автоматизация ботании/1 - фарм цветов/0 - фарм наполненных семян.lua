local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller

--надо сделать сканирование сундука, если там меньше стака костей, надо подфармить еще

function check_or_replenish_item(item, count)
    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label == item and robot_slot.size > count - 1 then
            robot.select(i)
            return
        end
    end

    for i = 1, i_c.getInventorySize(sides.front) do
        local chest_item = i_c.getStackInSlot(sides.front, i)
        if chest_item and chest_item.label == item then
            robot.select(1)
            i_c.suckFromSlot(sides.front, i, 32)
            break
        end
    end

    check_or_replenish_item(item, count)
end

function search_seed()
    robot.turnAround()
    i_c.equip()

    check_or_replenish_item("Bone Meal", 32)
    i_c.equip()
    check_or_replenish_item("Infused Seeds", 1)
    robot.turnAround()
end

function fertilizer()
    robot.turnLeft()
    robot.swing()
    robot.turnRight()
    for _ = 1, 3 do
        robot.use()
    end
    robot.turnRight()
    robot.swing()
    robot.turnLeft()
end

function grab_res()
    robot.up()
    robot.fill()
    os.sleep(0.3)
    robot.drain()
    robot.down()
end

function main()
    search_seed()
    robot.place()
    fertilizer()
    grab_res()
end

while true do
    main()
    os.sleep(600)
end