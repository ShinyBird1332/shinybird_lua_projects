local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller

local actions = {
    ["right"] = {robot.turnRight},
    ["left"] = {robot.turnLeft}
}

--- Проверка заряда инструмента (упрощённый вызов)
--- @param need_charge number Минимальная прочность (где 1 = 100%). По умолчанию 0.2 (20%).
--- @param time_sleep number Задержка ожидания в секундах. По умолчанию 2.
--- @param turn string Направление поворота ("right" или "left"). По умолчанию "right".
function check_charge_simple(need_charge, time_sleep, turn)
    check_charge({need_charge = need_charge, time_sleep = time_sleep, turn = turn})
end

-- Проверка и зарядка инструмента
--- @param args table? Таблица аргументов (опционально)
---  args.need_charge number Минимальная прочность (где 1 = 100%). По умолчанию 0.2 (20%).
---  args.time_sleep number Задержка ожидания в секундах. По умолчанию 2.
---  args.turn string Направление поворота ("right" или "left"). По умолчанию "right".
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
