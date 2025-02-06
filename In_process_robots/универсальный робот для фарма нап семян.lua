local comp = require("component")
local robot = require("robot")
local sides = require("sides")

local i_c = comp.inventory_controller
local crafting = comp.crafting
local tractor_beam = comp.tractor_beam

local DROP = "Bone Meal"
local COUNT = 256

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
    check_or_replenish_item("Bone Meal", 32)
    check_or_replenish_item("Infused Seeds", 1)
    robot.turnAround()
end

function fertilizer()
    local prev_slot = robot.select()
    check_or_replenish_item("Bone Meal", 1)
    for _ = 1, 3 do
        robot.place()
    end
    robot.select(prev_slot)
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
    if robot.tankLevel() < 1000 then
        robot.turnLeft()
        print("Недостаточно воды. Разлейте воду напротив робота.")
        while robot.tankLevel() < 1000 do
            robot.drain()
            os.sleep(1)
        end
        robot.turnRight()
    end
    local prev_slot = robot.select() --неправильно, надо, чтоб пред слот считался в самом начале
    robot.up()
    robot.fill()
    os.sleep(0.3)
    robot.drain()
    robot.down()

    for _ = 1, 3 do
        tractor_beam.suck()
    end



    robot.turnAround()

    --craft_meal() --включить только, если робот отвечает за крафт муки

    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item and item.label ~= "Infused Seeds" then
            robot.select(i)
            robot.drop()
        elseif item and item.label == "Infused Seeds" then
            robot.transferTo(prev_slot)
        end
    end
    robot.turnAround()
end

function check_count_item(need_item)
    robot.turnAround()
    local res = 0
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)
        if item and item.label == need_item then 
            res = res + item.size 
        end
    end
    robot.turnAround()
    return res
end

function main()
    search_seed()
    robot.place()
    fertilizer()
    grab_res()
end

while true do
    if check_count_item(DROP) < COUNT then
        main()
    end
    os.sleep(10)
end
