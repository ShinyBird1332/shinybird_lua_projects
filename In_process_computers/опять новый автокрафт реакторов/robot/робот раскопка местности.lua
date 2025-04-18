local comp = require("component")
local computer = require("computer")
local robot = require("robot")
local event = require("event")
local modem = comp.modem
local g = comp.generator

--если случай, скорее всего изза моба: робот думает, что прошел шаг а он не прошел, изза чего он съезжает
--проблема: робот ест много угля. Надо сделать автокрафт угольных блоков на этом же роботе или просто хавать нафармленный уголь
--еще проблема: стака сундуков вообще не хватит, надо что-то придумать с этим

local COUNT_COAL = 4 --кол-во угля, содержащееся в генераторе
local COUNT_COAL_ADD = 8

local SLOT_COAL = 16  
local SLOT_CHEST = 15 
local MIN_PERCENT_ENERGY = 10
local PERCENT_UNTIL_CHARGE = 50

actions = { 
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down}
}

local x_size = 16 -- сторона, в которую смотрит робот при старте
local y_size = 16 -- сторона, справа от робота
local z_size = 35 -- сторона вниз

function monitor_energy()
    local energy = computer.energy()
    local max_energy = computer.maxEnergy()
    local percentage = (energy / max_energy) * 100

    if percentage < MIN_PERCENT_ENERGY then
        print("Энергия на уровне " .. math.floor(percentage) .. "%. Ожидание зарядки...")
        while (computer.energy() / max_energy) * 100 < PERCENT_UNTIL_CHARGE do
            eat()
            os.sleep(1)
        end
        print("Зарядка завершена.")
    end
end

function eat()
    if g.count() >= COUNT_COAL then return end

    robot.select(SLOT_COAL)
    if robot.count() < COUNT_COAL - 1 then
        print("Нет топлива! Ожидание...")
        while robot.count() < COUNT_COAL - 1 do
            os.sleep(1)
        end
    end
    g.insert(COUNT_COAL_ADD)
end
  
function check_inv()
    if robot.count(SLOT_CHEST - 1) > 0 then
        local selected_slot = robot.select()
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
        monitor_energy()
    end
end

function move_start()
    local x = 1
    run(4)
    robot.turnLeft()
    run(9)
    robot.turnRight()
    for i = 1, 35 do repeat_swing("up") end
    functions.run(x)
    for i = 1, 35 do repeat_swing("down") end
end

function move_finish()
    local x = 1
    robot.turnAround()
    run(x)
    for i = 1, z_size - 1 do
        repeat_swing("down")
    end
    robot.turnLeft()
    run(9)
    robot.turnRight()
    run(4)
    robot.turnAround()
end

function main()
    move_start() --помимо основного перемещения, надо подниматься вверх и искать место для след реактора
    --repeat_swing("up")
    for z = 1, z_size do
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

        if z ~= z_size then repeat_swing("up") end
    end
    move_finish()
    modem.broadcast(4, "dig_ready")
    --надо сделать функцию перемещения на точку и функцию возврата обратно
end

modem.open(4)
while true do
    local _, _, _, _, _, message = event.pull("modem_message")
    if tostring(message) == "dig" then
        print("Got a message: " .. tostring(message))
        main()
    end
end
