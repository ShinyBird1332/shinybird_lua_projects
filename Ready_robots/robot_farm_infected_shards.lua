--Developed by ShinyBird368

--Конфигурация робота:
--Системный блок 2
--Процессор 2
--Видеокарта 1
--Диск 2
--Память 2 (2 штуки)
--Lua Bios
--Монитор 1
--Клавиатура
--Дисковод
--Улучшение инвентарь
--Улучшение контроллер инфентаря
--Улучшение ёмкость 1 (опционально)
--Улучшение парение 1 (опционально)

local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller

local SIZE = 15 -- размеры квадратной комнаты
local COUNT_FLOOR = 2 -- количество этажей для фарма
local NEED_CHARGE = 0.2 -- процент прочности лопаты для замены
local TIME_SLEEP = 20 -- время ожидания новых волокон
local STAIRS_HEIGHT = 3

local actions = {
    ["func_forward"] = {robot.swing, robot.detect, robot.forward},
    ["func_up"] = {robot.swingUp, robot.detectUp, robot.up},
    ["func_down"] = {robot.swingDown, robot.detectDown, robot.down},
    ["right"] = {robot.turnRight},
    ["left"] = {robot.turnLeft}
}

function check_charge_simple(need_charge, time_sleep, turn)
    check_charge({need_charge = need_charge, time_sleep = time_sleep, turn = turn})
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
  
function transfer_shards()
    robot.turnLeft() 
    for i = 1, robot.getInventorySize() do 
        robot.select(i)
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnRight()
end

function run(direction, distance)
    local action = actions["func_" .. direction] 
    local swing_func, detect_func, move_func = table.unpack(action)

    for _ = 1, distance do
        repeat
            swing_func()
            os.sleep(0.2)
        until not detect_func()
        move_func()
    end
end

function farm_shards()
    for _ = 1, COUNT_FLOOR do
        for _ = 1, SIZE do
            run(SIZE, "forward")
            robot.turnAround()
            run(SIZE, "forward")

            robot.turnRight()
            run(1, "forward")
            robot.turnRight()
        end
        robot.turnLeft()
        run(SIZE, "forward")
        robot.turnRight()

        run(STAIRS_HEIGHT, "up")
    end
    run(STAIRS_HEIGHT * COUNT_FLOOR, "down")
end

function main()
    while true do
        farm_shards()
        transfer_shards()
        check_charge({need_charge=NEED_CHARGE, turn="left"})
        os.sleep(TIME_SLEEP)
    end
end

main()
