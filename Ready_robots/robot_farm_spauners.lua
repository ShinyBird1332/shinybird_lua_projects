--powered by ShinyBird368
local robot = require("robot")
local comp = require("component")
local sides = require("sides")
local tract = comp.tractor_beam
local i_c = comp.inventory_controller

--проблема: робот складывает не меч, а селектед слот (при разряде)

local TIME_GRAB = 2 --количество секунд, сколько робот будет собирать выпавшие предметы
local COUNT_HITS = 25 --количество ударов за 1 цикл
local NEED_CHARGE = 0.3 --уровень прочности меча, на котором требуется зарядка

local actions = {
    ["swing"] = {robot.swing},
    ["suck"] = {robot.suck},
    ["right"] = {robot.turnRight},
    ["left"] = {robot.turnLeft}
}

function attack_or_grab(name_func, count_iters)
    local func = table.unpack(actions[name_func])
    for _ = 1, count_iters do
        func()
        os.sleep(0.5)
    end
end

function attack_or_grab(action_func, count_iters)
    for _ = 1, count_iters do
        action_func()
        os.sleep(0.5)
    end
end

function check_charge(args)
    local function turn(direction)
        local action = actions[direction]
        if not action then
            error("Ошибка: Некорректное направление поворота - " .. tostring(direction))
        end
        local rotate_func = table.unpack(action)
        rotate_func()
    end

    local args = args or {}
    local need_charge = args.need_charge or 0.2
    local time_sleep = args.time_sleep or 2
    local turn_direction = args.turn or "right"

    local prev_slot = robot.select()
    local durability = robot.durability()

    if durability and durability < need_charge then
        print("Прочность инструмента: " .. (durability * 100) .. "%. Необходимо зарядить.")

        turn(turn_direction)

        if not robot.drop() then
            print("Ошибка: Не удалось положить инструмент в сундук!")
            turn(turn_direction == "right" and "left" or "right")
            return false
        end

        print("Инструмент отправлен на зарядку. Ожидание...")

        repeat
            os.sleep(time_sleep)
        until i_c.getStackInSlot(sides.front, 1) and i_c.getStackInSlot(sides.front, 1).durability == 1

        if i_c.suckFromSlot(sides.front, 1) then
            print("Инструмент успешно заряжен и возвращён.")
            turn(turn_direction == "right" and "left" or "right")
            return true
        else
            print("Ошибка: Не удалось забрать инструмент из сундука!")
            turn(turn_direction == "right" and "left" or "right")
            return false
        end
    else
        print("Инструмент в хорошем состоянии. Прочность: " .. (durability and (durability * 100) or "недоступно") .. "%")
    end

    robot.select(prev_slot)
    return true
end

function check_storage()
    for i = 1, robot.inventorySize() do
        robot.select(i)
        if robot.count() == 0 then 
            return true
        end
    end
    return false
end

function transfer_to_storage()
    robot.turnLeft()
    for i = 1, robot.inventorySize() - 1 do
        robot.select(i)
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnRight()
end

function main()
    while true do
        if not check_storage() then
            transfer_to_storage()
        else
            attack_or_grab(robot.swing, COUNT_HITS)
            attack_or_grab(robot.suck, TIME_GRAB)
            check_charge({need_charge = NEED_CHARGE, turn = "right"})
        end
    end
end

main()