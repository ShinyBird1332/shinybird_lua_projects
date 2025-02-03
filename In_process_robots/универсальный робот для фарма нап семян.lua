--

local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller
local crafting = comp.crafting
local tractor_beam = comp.tractor_beam

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
    robot.turnLeft()

    check_or_replenish_item("Bone Meal", 32)
    check_or_replenish_item("Infused Seeds", 1)
    robot.turnRight()
end

function fertilizer()
    local prev_slot = robot.select()
    --robot.turnLeft()
    --robot.swing()
    --robot.turnRight()
    check_or_replenish_item("Bone Meal", 1)
    for _ = 1, 3 do
        robot.place()
    end
    robot.select(prev_slot)
    --robot.turnRight()
    --robot.swing()
    --robot.turnLeft()
end

function craft_meal()
    check_or_replenish_item("Infused Seeds", 1)
    robot.transferTo(4)
    check_or_replenish_item("Bone Meal", 1)
    robot.transferTo(12)
    check_or_replenish_item("Bone", 1)
    robot.transferTo(1)
    robot.select(8)
    crafting.craft()
    robot.select(16)
    crafting.craft()
end

function grab_res()
    robot.up()
    robot.fill()
    os.sleep(0.3)
    robot.drain()
    robot.down()

    for _ = 1, 3 do
        tractor_beam.suck()
    end

    robot.turnLeft()

    craft_meal()
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item and item.label ~= "Infused Seeds" then
            robot.select(i)
            robot.drop()
        end
    end
    robot.turnRight()
end

function main()
    search_seed()
    robot.place()
    fertilizer()
    grab_res()

end

while true do
    robot.turnLeft()
    local res = 0
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)
        if item and item.label == "Bone Meal" then res = res + item.size end
    end
    robot.turnRight()
    if res < 256 then
        main()
    end
    os.sleep(10)
end
