local comp = require("component")
local computer = require("computer")
local robot = require("robot")
local g = comp.generator
local log_file = "/home/robot_dig_log.txt"

local COUNT_COAL = 4
local SLOT_COAL = 16  
local SLOT_CHEST = 15 

actions = { 
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down}
}

local x_size = 25 -- сторона, в которую смотрит робот при старте
local y_size = 25 -- сторона, справа от робота
local z_size = 25 -- сторона вниз

function monitor_energy()
    local energy = computer.energy()
    local max_energy = computer.maxEnergy()
    print(energy, "---", max_energy)
    if energy and max_energy then
        local percentage = (energy / max_energy) * 100
        if percentage < 10 then
            print("Энергия на уровне " .. math.floor(percentage) .. "%. Ожидание зарядки...")
            while (robot.energy() / max_energy) * 100 < 50 do
                os.sleep(1)
            end
            print("Зарядка завершена.")
        end
    else
        print("Не удалось определить уровень энергии.")
    end
end

local function write_log(message)
    local file = io.open(log_file, "a") -- "a" означает добавление в конец файла
    if file then
        file:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. message .. "\n")
        file:close()
    else
        print("Не удалось открыть файл для записи: " .. log_file)
    end
end

function eat()
    if g.count() >= COUNT_COAL then return end

    robot.select(SLOT_COAL)
    if robot.count() < COUNT_COAL - 1 then
        write_log("Кушаем уголь")
        print("Нет топлива! Ожидание...")
        while robot.count() < COUNT_COAL - 1 do
            os.sleep(1)
        end
    end
    g.insert(8)
end
  
function check_inv()
    if robot.count(SLOT_CHEST - 1) > 0 then
        write_log("Сбрасываем предметы")
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
    for x = 1, direct do
        eat()
        check_inv()
        repeat_swing("forward")
        monitor_energy()
    end
end

function main()
    repeat_swing("down")
    for z = 1, z_size do
        for y = 1, y_size - 1 do
            run(x_size - 1)
            robot.turnAround()
            run(x_size - 1)
            robot.turnLeft()
            run(1)
            robot.turnLeft()
            write_log("y = " .. y)
        end
        run(x_size - 1)
        robot.turnAround()
        run(x_size - 1)  

        robot.turnRight()
        run(y_size - 1)
        robot.turnRight()

        if z ~= z_size then repeat_swing("down") end
        write_log("z = " .. z)
    end
end

main()
