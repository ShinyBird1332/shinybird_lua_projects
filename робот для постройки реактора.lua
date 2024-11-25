local comp = require("component") 
local sides = require("sides")
local robot = require("robot")
local g = comp.generator
local i_c = comp.inventory_controller

local size = 15
local SLOT_CHEST = 15
local SLOT_COAL = 16

--надо придумать нормальный способ пополнения ураном
--надо сделать так, чтоб перед началом постройки робот проверял кол-во ресов 
--еще надо будет сделать подключение к компу, который дает статистику по всем реакторам

local resourses = { 
    ["Реакторный корпус"] = 5,
    ["Реакторный контроллер"] = 5,
    ["Реакторный контролирующий стержень"] = 5,
    ["Реакторная розетка"] = 5,
    ["Реакторный порт доступа"] = 5,
    ["Йелориумовый топливный стержень"] = 5,
    ["Графитовый блок"] = 5,
}

function repeat_swing(direct)
    if direct == "forw" then
        repeat
            robot.swing()
            os.sleep(0.2)
        until not robot.detect()
        robot.forward()

    elseif direct == "up" then
        repeat
            robot.swingUp()
            os.sleep(0.2)
        until not robot.detectUp()
        robot.up()

    elseif direct == "down" then
        repeat
            robot.swing()
            os.sleep(0.2)
        until not robot.detect()
        robot.forward()
        
    end
end

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

function run(direct, distance)
    for _ = 1, distance do
        eat()
        repeat_swing(direct)
    end
end

function check_kit_start()
    
end

function replenishment_robot_storage(need_item)
    if robot.count() <= 16 then
        local selected_slot = robot.select()
        robot.select(SLOT_CHEST)
        repeat_swing("up")
        robot.placeDown()
        robot.select(selected_slot)
    
        for i = 1, i_c.getInventorySize(sides.down) do
            local chest_item = i_c.getStackInSlot(sides.down, i)
    
            if chest_item ~= nil then
                if chest_item.label == need_item then
                    i_c.suckFromSlot(sides.down, i, 48)
                    break
                end
            end
        end

        robot.select(SLOT_CHEST)
        repeat_swing("down")
        robot.select(selected_slot)
    end
end

function check_need_block(item)
    local res = false
    for i = 1, 14 do
        local robot_slot = i_c.getStackInInternalSlot(i)
        if robot_slot ~= nil then
            if robot_slot.label == item and robot_slot.count > 16 then
                res = true
                break
            end
        end
    end
    if not res then
        replenishment_robot_storage(item)
    end
end

function build_row(block)
    if block ~= "криотнум" then
        for i = 1, size do
            eat()
            check_need_block(block)
    
            repeat
                robot.swingDown()
                os.sleep(0.2)
            until not robot.detectDown()
            robot.placeDown()
    
            repeat_swing("forw")
        end
    else
        print(robot.tankSpace())
        robot.drainUp(16000)
        print(robot.tankSpace())
        robot.fillDown()
        print(robot.tankSpace())
    end

    robot.turnAround()
    run("forw", size)

    robot.turnLeft()
    robot.forward()
    robot.turnLeft()
end

function build_floor()
    for _ = 1, size do
        build_row("Реакторный корпус")
    end
end

function filling_or_roof_reactor(block1, block2)
    for _ = 1, 3 do
        build_row(block1)----------
    end

    build_row(block2)
    
    for _ = 1, 5 do
        build_row(block1)----------
    end

    build_row(block2)

    for _ = 1, 3 do
        build_row(block1)----------
    end
end

function move_up()
    robot.turnRight() 
    run("forw", size)
    robot.turnRight()
    repeat_swing("up")
end

function main()
    check_kit_start() --проверяем наличие ресурсов для постройки реактора
    build_floor() --строим пол реактора
    move_up() -- переходим в начало координат постройки и на 1 выше
    filling_or_roof_reactor("криотеума", "Йелориумовый топливный стержень") --строим второй уровень реактора
    move_up() -- переходим в начало координат постройки и на 1 выше
    filling_or_roof_reactor("Реакторный корпус", "Реакторный контролирующий стержень") -- строим крышу реактора

    --дальше - турбина

end

main()