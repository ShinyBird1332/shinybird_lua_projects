local comp = require("component") 
local sides = require("sides")
local robot = require("robot")
local i_c = comp.inventory_controller

function check_or_replenish_item(item)
    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label == item and robot_slot.size > 3 then
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

    check_or_replenish_item(item)
end

function ensure_empty()
    while robot.detect() do
        robot.swing() -- Пытаемся сломать блок или моба
        os.sleep(0.5) -- Небольшая задержка для стабильности
    end
    robot.place()
end

function clear_inventory()
    local trach = {'Division Sigil', 'Miniature Yellow Heart', 'Nether Star', 'Rare Shader Grabbag', 'Sulfur'}

    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        robot.select(i)
        for j = 1, #trach do
            if robot_slot and robot_slot.label == trach[j]then
                robot.drop()
            end
        end
    end
    robot.select(1)
end

--false, air
--true, entity

function main()
    robot.turnLeft()
    check_or_replenish_item("Soul Sand")
    robot.turnLeft()
    check_or_replenish_item("Wither Skeleton Skull")
    robot.turnAround()
    check_or_replenish_item("Soul Sand")

    ensure_empty()
    robot.up()
    ensure_empty()

    robot.turnLeft()
    robot.forward()
    robot.turnRight()
    ensure_empty()

    robot.turnRight()
    robot.forward()
    robot.forward()
    robot.turnLeft()
    ensure_empty()

    check_or_replenish_item("Wither Skeleton Skull")
    robot.up()
    ensure_empty()

    for _ = 1, 2 do
        robot.turnLeft()
        robot.forward()
        robot.turnRight()
        ensure_empty()     
    end

    robot.turnRight()
    robot.forward()
    robot.turnLeft()
    robot.down()

    os.sleep(2)

    repeat
        robot.swing()
        os.sleep(0.2)
    until not robot.detect()
    robot.down()
    clear_inventory()
end

while true do
    main()
    os.sleep(3)
end