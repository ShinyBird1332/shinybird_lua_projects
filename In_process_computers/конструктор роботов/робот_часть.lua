local comp = require("component")
local event = require("event")
local robot = require("robot")
local i_c = comp.inventory_controller

-- Перемещение к шине экспорта
function move_me_bus_export()
    print("Робот движется к шине экспорта...")
    robot.turnRight()
    for _ = 1, 3 do
        robot.forward()
    end
    robot.turnLeft()
    robot.up()
    print("Робот прибыл к шине экспорта.")
end

-- Сброс лишних предметов в мусорку
function move_trash()
    print("Робот движется к мусорке для удаления лишних предметов...")
    robot.down()
    robot.turnLeft()
    robot.forward()
    robot.turnLeft()
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item and item.size > 1 then
            print("Удаляем лишние предметы из слота " .. i .. ": " .. (item.size - 1) .. " шт.")
            robot.select(i)
            robot.drop(item.size - 1)
        end
    end
    print("Удаление лишних предметов завершено.")
end

-- Складирование компонентов в сборщик
function move_assembler()
    print("Робот движется к сборщику для загрузки компонентов...")
    robot.turnLeft()
    robot.forward()
    robot.forward()
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item and item.label:find("Computer Case") then
            print("Загружаем основной компонент: " .. item.label)
            robot.select(i)
            robot.drop()
            break
        end
    end

    -- Сбрасываем остальные компоненты
    robot.select(1)
    for i = 1, robot.inventorySize() do
        local item = i_c.getStackInInternalSlot(i)
        if item then
            print("Сбрасываем дополнительный компонент из слота " .. i)
            robot.select(i)
            robot.drop()
        end
    end
    print("Все компоненты успешно загружены в сборщик.")
end

-- Ожидание завершения сборки
function move_grab()
    print("Робот ждет завершения сборки...")
    robot.turnLeft()
    robot.forward()
    robot.turnRight()
    robot.forward()
    robot.forward()
    robot.turnRight()
    robot.forward()
    robot.turnRight()

    -- Ждем некоторое время (пока сборщик завершит работу)
    os.sleep(5) -- Можно настроить время или добавить проверку статуса
    print("Сборка завершена. Готовимся к извлечению робота.")
end

-- Извлечение готового робота и его размещение
function grab_robot()
    print("Робот извлекает готового робота из сборщика...")
    if robot.suckUp() then
        print("Готовый робот успешно извлечен!")
    else
        print("Не удалось извлечь робота! Возможно, сборщик пуст.")
        return
    end

    print("Робот перемещается для вручения готового робота...")
    robot.turnRight()
    robot.forward()
    robot.turnLeft()
    for _ = 1, 4 do
        robot.forward()
    end
    robot.turnRight()
    for _ = 1, 3 do
        robot.forward()
    end
    robot.place()
    print("Готовый робот успешно передан!")
end

-- Главный цикл ожидания команд
while true do
    local _, _, _, _, _, message, command = event.pull("modem_message")
    print("Получена команда: " .. message)

    if message == "robot_move_me_bus_export" then
        move_me_bus_export()
    elseif message == "robot_move_trash" then
        move_trash()
    elseif message == "robot_move_assembler" then
        move_assembler()
    elseif message == "robot_move_grab" then
        move_grab()
    elseif message == "robot_grab_robot" then
        grab_robot()
    else
        print("Неизвестная команда: " .. tostring(message))
    end
end
