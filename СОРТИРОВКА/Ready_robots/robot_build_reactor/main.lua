--Developed by ShinyBird368

--ВАЖНО!!! Программа все еще на версии беты, так что перед постройкой обязательно расчистите место для будушей структуры (15х15х19)

--Конфигурация робота:
----системный блок 3-го уровня
--процессор с видеокартой 2-й уровень
--память 2-й уровень
--диск 2-й уровень
--монитор 1-й уровень
--клавиатура
--дисковод (опционально, но желательно)
--биос
--контейнер для улучшения 2-й лвл 
--контейнер для улучшения 3-й лвл 
--улучшение инвентарь
--улучшение контроллер инвентаря
--улучшение бак
--улучшение генератор
--улучшение ангельское
--улучшение парение 1-й уровень 


--надо бы еще сделать так, чтоб угольные блоки, ключ и криотеум были в сундуке и робот брал это оттуда сразу
--еще надо сделать запуск по этапам:
-- main 0 - стандартный запуск
--main 1 - запуск без сканирования сундука, сразу забор ресов
--main 2 - запуск без взаимодействия с сундуком, тип он уже все взял
--и т д

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")
local reactor = dofile("reactor.lua")
local turbines = dofile("turbines.lua")

function main()
    if not functions.check_kit_start() then return end
    print("Проверка ресурсов для реактора: Успешно!")
    reactor.build_floor()
    reactor.move_up()
    reactor.filling_or_roof_reactor("криотеум", "Yellorium Fuel Rod", "Reactor Access Port", "Reactor Controller", "Reactor Coolant Port")
    reactor.move_up()
    reactor.filling_or_roof_reactor("Reactor Casing", "Reactor Control Rod", "Reactor Casing", "Reactor Casing")

    reactor.move_up()
    functions.replace_coolant_ports(false)

    functions.run(1)
    constants.robot.turnRight()
    functions.run(9)
    constants.robot.turnRight() 
    turbines.build_turbine()

    constants.robot.turnLeft()
    functions.run(6)
    constants.robot.turnLeft()
    functions.run(3)
    constants.robot.turnLeft()
    for _ = 1, 16 do functions.repeat_swing("down") end
    turbines.build_turbine()

    functions.run(5)
    constants.robot.turnRight()
    functions.run(2)
    for _ = 1, 16 do functions.repeat_swing("down") end
    turbines.build_turbine()

    functions.run(13)
    constants.robot.turnLeft()
    functions.run(6)
    constants.robot.turnAround()
    for _ = 1, 16 do functions.repeat_swing("down") end
    turbines.build_turbine()    
end

main()
