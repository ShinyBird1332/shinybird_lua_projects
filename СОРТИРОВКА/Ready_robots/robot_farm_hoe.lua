--Powered by ShinyBird368
--Конфигурация робота:
----системный блок 3-го уровня
--процессор 2-2 уровень
--видеокарта 1-й уровень
--память 2-й уровень
--диск 2-й уровень
--монитор 1-й уровень
--клавиатура
--дисковод
--биос
--улучшение инвентарь
--улучшение контроллер инвентаря

local comp = require("component")
local robot = require("robot")
local sides = require("sides")
local i_c = comp.inventory_controller

robot.use()

local COUNT_USES = 120
local need_charge = 0.2
local time_sleep = 5

function check_charge()
    local prev_slot = robot.select()
    local durability = robot.durability()

    if durability and durability < need_charge then
        print("Прочность инструмента: " .. (durability * 100) .. "%. Необходимо зарядить.")

        robot.turnAround()

        print("Инструмент отправлен на зарядку. Ожидание...")
        i_c.equip()
        robot.drop()

        repeat
            os.sleep(time_sleep)
        until i_c.getStackInSlot(sides.front, 1)
        i_c.suckFromSlot(sides.front, 1, 1)
        i_c.equip()

        print("Инструмент успешно заряжен и возвращён.")
        robot.turnAround()
    else
        print("Инструмент в хорошем состоянии. Прочность: " .. (durability and (durability * 100) or "недоступно") .. "%")
    end
    robot.select(prev_slot)
end

function farm()
    for i = 1, COUNT_USES do
        robot.use()
    end
end

function storage()
    robot.turnAround()
    for i = 1, robot.inventorySize() do
        robot.select(i)
        if robot.count() > 0 then
            robot.drop()
        end
    end
    robot.turnAround()
end

function main()
    check_charge()
    farm()
    storage()
    os.sleep(5)
end

while true do
    main()
end