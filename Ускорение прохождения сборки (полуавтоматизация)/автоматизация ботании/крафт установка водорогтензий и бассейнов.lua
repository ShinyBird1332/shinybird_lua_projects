local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller
local crafting = comp.crafting

--сделать беск источник воды 3 на 3
--обложить источник плитами
--позаботиться, чтоб по бокам была земля
--запомнить координаты источника
--набрать воды в робота
--опустошить воду в аптекаря

--так же, следить за энергией, если мало, идти к доку

actions = { 
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down}
}

function repeat_swing(direction)
    local action = actions["func_" .. direction] 
    local swing_func, detect_func, move_func = table.unpack(action)

    repeat
        swing_func()
        os.sleep(0.2)
    until not detect_func()
    move_func()
end

function grab_item(need_item, count)
    local sys = false
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)

        if item and item.label:find(need_item) then
            i_c.suckFromSlot(sides.front, i, count)
            sys = true
            break
        end
    end
    if not sys then
        print("Недостаточно ресурсов в сундуке: " .. need_item .. ", " .. count .. " штук!")
        move_base_chest("back")
        os.sleep(5)
        move_base_chest("forward")
        grab_item("Cobblestone", 7)
    end
end

function suck_item(need_item)
    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label:find(need_item) then 
            robot.select(i)
            robot.drop() 
        end
    end
end

function search_item_in_robot(need_item)
    for i = 1, robot.inventorySize() do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot and robot_slot.label:find(need_item) then 
            robot.select(i) 
            break
        end
    end
end

function craft_pharmacist()
    move_base_chest("forward")
    robot.select(1)
    grab_item("Mystical", 1)
    crafting.craft()
    robot.transferTo(4)
    robot.select(13)
    grab_item("Cobblestone", 7)

    for i = 1, 3 do robot.transferTo(i, 1) end
    robot.select(1)
    crafting.craft()
    robot.transferTo(3, 1)
    robot.select(4)
    robot.transferTo(2)
    robot.select(13)
    robot.transferTo(6, 1)
    for i = 9, 11 do robot.transferTo(i, 1) end
    robot.select(4)
    crafting.craft()
    suck_item("Mystical")
    suck_item("Cobblestone")
end

function move_base_chest(direct)
    if direct == "forward" then
        repeat_swing("forward")
        robot.turnRight() 
        for _ = 1, 3 do repeat_swing("forward") end
    else
        robot.turnAround()
        for _ = 1, 3 do repeat_swing("forward") end
        robot.turnLeft() 
        repeat_swing("forward")
        robot.turnAround()
    end
end

function craft_plates()
    robot.select(1)
    grab_item("Cobblestone", 6)
    robot.select(4)
    crafting.craft()
    suck_item("Cobblestone")
    robot.transferTo(1)
    robot.select(1)
end

function main()
    craft_pharmacist()
    robot.turnLeft()
    for _ = 1, 2 do repeat_swing("forward") end
    search_item_in_robot("Pharmacist")
    robot.place()
    robot.turnAround()
    for _ = 1, 2 do repeat_swing("forward") end
    robot.turnLeft()

    craft_plates()
    robot.turnLeft()
    for _ = 1, 2 do repeat_swing("forward") end
    robot.turnRight()
    for _ = 1, 2 do repeat_swing("forward") end
end

main()