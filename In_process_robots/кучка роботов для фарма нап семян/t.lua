local comp = require("component")
local robot = require("robot")
local sides = require("sides")

local i_c = comp.inventory_controller
local crafting = comp.crafting
local tractor_beam = comp.tractor_beam

local DROP = "Bone Meal"
local COUNT = 256
local COUNT_ROBOTS = 4

local actions = {
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down},
    ["func_robot"] = {robot.inventorySize, i_c.getStackInInternalSlot},
    ["func_chest"] = {i_c.getInventorySize, i_c.getStackInSlot}
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

function run(iter)
    for _ = 1, iter do
        repeat_swing("forward")
    end
end

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

function inv_summ(name_item, count_item, func)
    local action = actions["func_" .. func] 
    local size_func, slot_func = table.unpack(action)
    local prev_slot = robot.select()
    local res = 0

    for i = 1, size_func(sides.front) do
        if func == "robot" then
            cur_item = slot_func(i)
        else
            cur_item = slot_func(sides.front, i)
        end
        if cur_item and cur_item.label == name_item then
            res = res + cur_item.size
        end
    end

    robot.select(prev_slot)

    if res < count_item then
        return false
    else
        return true
    end
end

function t_chest(name_item, count_item)
    local prev_slot = robot.select()
    for i = 1, i_c.getInventorySize(sides.front) do
        local cur_item = i_c.getStackInSlot(sides.front, i)
        if cur_item and cur_item.label == name_item and cur_item.size >= count_item then
            robot.select(i)
            return prev_slot
        end
    end
end

function check_count_item(need_item)
    local res = 0
    for i = 1, i_c.getInventorySize(sides.front) do
        local item = i_c.getStackInSlot(sides.front, i)
        if item and item.label == need_item then 
            res = res + item.size 
        end
    end
    --robot.turnLeft()
    print(res)
    return res
end

function search_seed()
    robot.turnRight()
    check_or_replenish_item("Bone Meal", 32)
    check_or_replenish_item("Infused Seeds", 1)
    robot.turnLeft()
end

function fertilizer()
    local prev_slot = robot.select()
    check_or_replenish_item("Bone Meal", 1)
    for _ = 1, 3 do
        robot.place()
    end
    robot.select(prev_slot)
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
    local prev_slot = robot.select()
    robot.up()
    robot.fill()
    os.sleep(0.3)
    robot.drain()
    robot.down()

    for _ = 1, 3 do
        tractor_beam.suck()
    end

    robot.turnRight()
    craft_meal()

    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        robot.select(i)
        if item and item.label ~= "Infused Seeds" then
            robot.drop()
        elseif item and item.label == "Infused Seeds" then
            robot.transferTo(prev_slot)
        end
    end
    robot.turnLeft()
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

function tt(name_item, count_item, func, iter)
    if not inv_summ(name_item, count_item, func) then
        print("В сундуке недостаточно пыли")
        robot.turnRight()
        run(iter)
        robot.turnRight()
        while check_count_item("Bone Meal") < COUNT do
            print("dshdhfejhgdfjfgjkf")
            --цель пока что - зациклить робота в удачной проверке кол-ва пыли
            search_seed()
            robot.place()
            fertilizer()
            grab_res()

            os.sleep(1)
        end
        print("Цикл завершен")
    else
        print("пыли в сундуке достаточно")
        robot.turnLeft()
    end
end

function main()
    print("Запуск проверки сундуков")
    robot.turnAround()
    for i = 1, COUNT_ROBOTS do
        repeat_swing("forward")
        robot.turnRight()
        tt("Bone Meal", 256, "chest", i) --тут неправильное завершение фукнции
    end
    robot.turnAround()
    run(COUNT_ROBOTS)
end

while true do
    print("Старт программы")
    main()
    os.sleep(10)
end