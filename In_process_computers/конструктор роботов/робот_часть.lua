local constants = dofile("constants.lua")

--вот интересный момент, мне нужно добавлять в робота файл constants.lua или он подтянется с компьютера?

-- Перемещение к шине экспорта
function move_me_bus_export()
    print("Робот движется к шине экспорта...")
    constants.robot.turnRight()
    for _ = 1, 3 do
        constants.robot.forward()
    end
    constants.robot.turnLeft()
    constants.robot.up()
    print("Робот прибыл к шине экспорта.")
end

-- Сброс лишних предметов в мусорку
function move_trash()
    print("Робот движется к мусорке для удаления лишних предметов...")
    constants.robot.down()
    constants.robot.turnLeft()
    constants.robot.forward()
    constants.robot.turnLeft()
    for i = 1, constants.robot.inventorySize() do
        local item = constants.i_c.getStackInInternalSlot(i)
        if item and item.size > 1 then
            print("Удаляем лишние предметы из слота " .. i .. ": " .. (item.size - 1) .. " шт.")
            constants.robot.select(i)
            constants.robot.drop(item.size - 1)
        end
    end
    print("Удаление лишних предметов завершено.")
end

-- Складирование компонентов в сборщик
function move_assembler()
    print("Робот движется к сборщику для загрузки компонентов...")
    constants.robot.turnLeft()
    constants.robot.forward()
    constants.robot.forward()
    for i = 1, constants.robot.inventorySize() do
        local item = constants.i_c.getStackInInternalSlot(i)
        if item and item.label:find("Computer Case") then
            print("Загружаем основной компонент: " .. item.label)
            constants.robot.select(i)
            constants.robot.drop()
            break
        end
    end

    -- Сбрасываем остальные компоненты
    constants.robot.select(1)
    for i = 1, constants.robot.inventorySize() do
        local item = constants.i_c.getStackInInternalSlot(i)
        if item then
            print("Сбрасываем дополнительный компонент из слота " .. i)
            constants.robot.select(i)
            constants.robot.drop()
        end
    end
    print("Все компоненты успешно загружены в сборщик.")
end

-- Ожидание завершения сборки
function move_grab()
    print("Робот ждет завершения сборки...")
    constants.robot.turnLeft()
    constants.robot.forward()
    constants.robot.turnRight()
    constants.robot.forward()
    constants.robot.forward()
    constants.robot.turnRight()
    constants.robot.forward()
    constants.robot.turnRight()

    -- Ждем некоторое время (пока сборщик завершит работу)
    os.sleep(5) -- Можно настроить время или добавить проверку статуса
    print("Сборка завершена. Готовимся к извлечению робота.")
end

-- Извлечение готового робота и его размещение
function grab_robot()
    while not constants.robot.suck() do
        constants.robot.suck()
    end


    print("Робот перемещается для вручения готового робота...")
    constants.robot.turnRight()
    constants.robot.forward()
    constants.robot.turnLeft()
    for _ = 1, 4 do
        constants.robot.forward()
    end
    constants.robot.turnRight()
    constants.robot.forward()
    constants.robot.place()
    print("Готовый робот успешно передан!")

    constants.robot.turnAround()
    constants.robot.forward()
    constants.robot.forward()
    constants.robot.turnRight()
    constants.robot.forward()
    constants.robot.forward()
    constants.robot.turnRight()
    constants.robot.select(1)
end

-- Главный цикл ожидания команд
while true do
    local _, _, _, _, _, message, command = constants.event.pull("modem_message")
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
