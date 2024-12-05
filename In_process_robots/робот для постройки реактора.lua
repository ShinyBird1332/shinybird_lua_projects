local comp = require("component") 
local sides = require("sides")
local robot = require("robot")
local g = comp.generator
local i_c = comp.inventory_controller

local SIZE = 15
local SLOT_TANK = 14
local SLOT_CHEST = 15
local SLOT_COAL = 16

local resourses = { 
    ["Reactor Casing"] = 479,
    ["Reactor Controller"] = 1,
    ["Reactor Control Rod"] = 26,
    ["Yellorium Fuel Rod"] = 26,
    ["Reactor Access Port"] = 3,
    ["Reactor Coolant Port"] = 8,
}

local actions = {
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down}
}

function eat()
    local selected_slot = robot.select()
    robot.select(SLOT_COAL)
    print("Нет топлива!")

    while robot.count() < 1 do
        os.sleep(1)
    end
    if g.count() < 2 then
        g.insert(4)
    end
    robot.select(selected_slot)
end

function run()
    for _ = 1, SIZE do
        eat()
        repeat_swing(table.unpack(actions["func_forward"]))
    end
end

function check_kit_start()
    robot.select(SLOT_CHEST)
    repeat_swing(table.unpack(actions["func_up"]))
    robot.placeDown()
    local result = true

    for name, count in pairs(resourses) do
        local res_count = 0
        for j = 1, i_c.getInventorySize(sides.down) do
            local chest_item = i_c.getStackInSlot(sides.down, j)
            if chest_item ~= nil then
                if chest_item.label == name then
                    res_count = res_count + chest_item.size
                end
            end
        end

        if res_count < count then
            print("Недостаточно " .. name .. " предметов: " .. count - res_count)
            result = false
        end
    end
    robot.select(SLOT_CHEST)
    repeat_swing(table.unpack(actions["func_down"]))
    robot.select(1)
    return result
end

function repeat_swing(...)
    local swing_func, detect_func, move_func = ...
    repeat
        swing_func()
        os.sleep(0.2)
    until not detect_func()
    move_func()
end

function replenishment_robot_storage(need_item)
    local selected_slot = robot.select()
    robot.select(SLOT_CHEST)
    repeat_swing(table.unpack(actions["func_up"]))
    robot.placeDown()
    robot.select(selected_slot)

    for i = 1, i_c.getInventorySize(sides.down) do
        local chest_item = i_c.getStackInSlot(sides.down, i)

        if chest_item ~= nil and chest_item.label == need_item then
            i_c.suckFromSlot(sides.down, i, 48)
            break
        end
    end
    
    robot.select(SLOT_CHEST)
    repeat_swing(table.unpack(actions["func_down"]))
    robot.select(selected_slot)
    check_need_block(need_item)

end

function check_need_block(item)
    for i = 1, 13 do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot ~= nil and robot_slot.label == item then
            robot.select(i)
            return
        end
    end
    replenishment_robot_storage(item)
end

function build_row(block1, block2, block3)
    block2 = block2 or "Reactor Casing"
    block3 = block3 or "Reactor Casing"

    for i = 1, SIZE do
        eat()
        if i == 1 then
            check_need_block(block3)
            repeat
                robot.swingDown()
                os.sleep(0.2)
            until not robot.detectDown()
            robot.placeDown()

            repeat_swing(table.unpack(actions["func_forward"]))
        
        elseif i == SIZE then
            check_need_block(block2)
            repeat
                robot.swingDown()
                os.sleep(0.2)
            until not robot.detectDown()
            robot.placeDown()

            repeat_swing(table.unpack(actions["func_forward"]))

        elseif block1 ~= "криотеум" then
            check_need_block(block1)    
            repeat
                robot.swingDown()
                os.sleep(0.2)
            until not robot.detectDown()
            robot.placeDown()
        
            repeat_swing(table.unpack(actions["func_forward"]))

        else
            if robot.tankLevel() <= 1000 then
                robot.select(SLOT_TANK)
                repeat
                    robot.swingUp()
                    os.sleep(0.2)
                until not robot.detectUp()

                robot.placeUp()
                robot.drainUp(16000)
                repeat
                    robot.swingUp()
                    os.sleep(0.2)
                until not robot.detectUp()
            end

            repeat
                robot.swingDown()
                os.sleep(0.2)
            until not robot.detectDown()
            robot.fillDown()

            repeat_swing(table.unpack(actions["func_forward"]))
        end 
    end
    robot.turnAround()
    run()

    robot.turnLeft()
    robot.forward()
    robot.turnLeft()
end

function move_up()
    robot.turnLeft() 
    run()
    robot.turnRight()
    repeat_swing(table.unpack(actions["func_up"]))
end

function build_floor()
    for _ = 1, SIZE do
        build_row("Reactor Casing")
    end
end

function filling_or_roof_reactor(block1, block2)
    build_row("Reactor Casing")

    for i = 1, 3 do
        build_row(block1, "Reactor Casing", "Reactor Access Port")
    end

    build_row(block2)
    
    for i = 1, 5 do
        build_row(block1)
    end

    build_row(block2)

    for i = 1, 3 do
        build_row(block1)
    end

    build_row("Reactor Casing")
end

function main() --проблема: нужно добавить скан инвентаря робота, чтоб знать, куда пополнять ресы и какой слот выбирать
    if not check_kit_start() then return end --проверяем наличие ресурсов для постройки реактора
    print("Проверка ресурсов для реактора: Успешно!")
    build_floor() --строим пол реактора
    move_up() -- переходим в начало координат постройки и на 1 выше
    filling_or_roof_reactor("криотеум", "Yellorium Fuel Rod") --строим второй уровень реактора
    move_up() -- переходим в начало координат постройки и на 1 выше
    filling_or_roof_reactor("Reactor Casing", "Reactor Control Rod") -- строим крышу реактора

    --дальше - турбина

end

main()