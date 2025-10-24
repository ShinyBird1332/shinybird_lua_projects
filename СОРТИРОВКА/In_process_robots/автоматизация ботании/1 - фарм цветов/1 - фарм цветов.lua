local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller
local crafting = comp.crafting

local flower_name = "Mystical"

actions = { 
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down}
}

function suck_all_flowers()
    for i = 1, robot.inventorySize() do
        robot.select(i)
        robot.drop()
    end
    robot.select(1)
end

function grab_one_flower()
    local count_flowers = 0
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find(flower_name) and count_flowers < 2 then
            i_c.suckFromSlot(sides.front, i, 1)
            count_flowers = count_flowers + 1
        end
    end
end

function grab_one_stack_flower()
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find(flower_name) then
            
            if item.size > 1 then
                if item.size // 2 * 2 > 32 then c = 32 else c = item.size // 2 * 2 end
                i_c.suckFromSlot(sides.front, i, c)
                return "same"
            else
                grab_one_flower()
                return "different"
            end
        end
    end
end

function craft_meal()
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find("Bone Meal") and item.size >= 16 then
            return
        end
    end
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find("Bone") then
            robot.select(1)
            i_c.suckFromSlot(sides.front, i, 21)
            robot.select(4)
            crafting.craft()
            robot.drop()
            return
        end
    end
end

function find_item(name, c)
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label == name then
            i_c.suckFromSlot(sides.front, i, c)
            break
        end
    end
end

function craft_dust(param)
    if param == "same" then
        robot.select(4)
        crafting.craft()
        robot.transferTo(2)
        robot.select(1)

        find_item("Pestle and Mortar", 1)

        robot.select(4)
        crafting.craft()
        robot.select(1)
        robot.drop()
        robot.select(4)
        local c = i_c.getStackInInternalSlot(4).size / 4

        for i = 2, 3 do robot.transferTo(i, c) end
        for i = 5, 6 do robot.transferTo(i, c) end

        robot.select(1)
        robot.turnRight()

        find_item("Bone Meal", c)

        robot.select(4)
        crafting.craft()

    elseif param == "different" then
        robot.select(2)
        robot.transferTo(4)
        robot.select(8)
        crafting.craft()
        robot.select(4)
        robot.transferTo(1)
        crafting.craft()
        robot.select(8)
        robot.transferTo(2)
        robot.select(1)

        find_item("Pestle and Mortar", 1)

        robot.select(8)
        crafting.craft()
        robot.select(4)
        robot.transferTo(2)
        crafting.craft()
        robot.select(1)
        robot.drop()
        robot.select(4)

        for i = 2, 3 do robot.transferTo(i, 1) end
        robot.select(8)
        for i = 5, 6 do robot.transferTo(i, 1) end

        robot.turnRight()
        robot.select(1)
        find_item("Bone Meal", 1)
        crafting.craft()
    end
end

function repeat_swing(direction)
    local action = actions["func_" .. direction] 
    local swing_func, detect_func, move_func = table.unpack(action)

    repeat
        swing_func()
        os.sleep(0.2)
    until not detect_func()
    move_func()
end

function main()
    robot.select(1)
    robot.turnRight()
    suck_all_flowers()
    robot.turnRight()
    craft_meal()
    robot.turnLeft()
    local param = grab_one_stack_flower()
    craft_dust(param)
    robot.turnAround()

    for _ = 1, 3 do repeat_swing("forward") end
    f = robot.count()
    i_c.equip()
    for _ = 1, f do
        robot.use()
    end
    robot.turnAround()
    for _ = 1, 2 do repeat_swing("forward") end
    robot.turnRight()
    for _ = 1, 3 do repeat_swing("forward") end
    robot.turnRight()

    for _ = 1, 6 do
        for _ = 1, 6 do repeat_swing("forward") end
        robot.turnAround()
        for _ = 1, 6 do repeat_swing("forward") end
        robot.turnLeft()
        repeat_swing("forward")
        robot.turnLeft()
    end
    for _ = 1, 6 do repeat_swing("forward") end
    robot.turnAround()
    for _ = 1, 6 do repeat_swing("forward") end
    robot.turnRight()
    for _ = 1, 3 do repeat_swing("forward") end
    robot.turnLeft()
    repeat_swing("forward")
    robot.turnAround()
end

while true do
    main()
    os.sleep(0.5)
end
