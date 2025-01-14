--перед запуском робота обязательно добавьте себя в свой приват в качестве учасника
--/rg addmember <ваш_приват> <ваш_ник>

local comp = require("component")
local robot = require("robot")
local g = comp.generator

local COUNT_COAL = 2
local SLOT_COAL = 16  
local SLOT_CHEST = 15 --совет: оставить этот слот последним, чтоб все, что до него, уходило в сундук

actions = { --константы для работы перемещения, менять не рекомендуется
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down}
}

local x_size = 5 -- сторона, в которую смотрит робот при старте
local y_size = 4 -- сторона, справа от робота
local z_size = 3 -- сторона вниз

function eat()
    if g.count() >= COUNT_COAL then return end

    robot.select(SLOT_COAL)
    if robot.count() < COUNT_COAL - 1 then
        print("Нет топлива! Ожидание...")
        while robot.count() < COUNT_COAL - 1 do
            os.sleep(1)
        end
    end
    g.insert(8)
end
  
function check_inv()
    if robot.count(SLOT_CHEST - 1) > 0 then
        local selected_slot = robot.select()
        robot.select(SLOT_CHEST)
        robot.placeUp()
        for i = 1, 14 do
            robot.select(i)
            robot.dropUp()
        end
        robot.select(selected_slot)
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

function run(direct)
    for _ = 1, direct do
        eat()
        check_inv()
        repeat_swing("forward")
    end
end

function main()
    repeat_swing("down")
    for i = 1, z_size do
        for _ = 1, y_size - 1 do
            run(x_size - 1)
            robot.turnAround()
            run(x_size - 1)
            robot.turnLeft()
            run(1)
            robot.turnLeft()
        end
        run(x_size - 1)
        robot.turnAround()
        run(x_size - 1)  

        robot.turnRight()
        run(y_size - 1)
        robot.turnRight()

        if i ~= z_size then repeat_swing("down") end
    end
end

main()
