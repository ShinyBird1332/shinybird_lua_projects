local constants = dofile("constants.lua")
local functions = dofile("functions.lua")
local reactor = dofile("reactor.lua")
local turbines = dofile("turbines.lua")

function main()

--изначально сундук стоит сзади, чтоб если чего-то не хватает, было проще добавлять ##вроде готово, надо тестить
--не уверен, но третья турбина просто куда-то пропала ##вроде готово, надо тестить
--неправильно располагаются порты охлаждения!
--1 - все ок
--2 - порты на 1 правее должны быть
--3 - порты на 1 дальше
--4 - порты на 1 правее и на 1 дальше
--##вроде исправил, надо тестить


--стака угля может не хватить, а может благодаря углю, роботу хватит энергии без подзарядки
--надо реализовать авто заправку: если заряда меньше 10% ставим энергокуб, выше зарядник, где-то рядом красный камень или как-то с ключом решить, выше робот
--или поискать еще блоки, которые заряжают робота!

    if not functions.check_kit_start() then return end
    print("Проверка ресурсов для реактора: Успешно!")
    reactor.build_floor()
    reactor.move_up()
    reactor.filling_or_roof_reactor("криотеум", "Yellorium Fuel Rod", "Reactor Access Port", "Reactor Controller")
    reactor.move_up()
    reactor.filling_or_roof_reactor("Reactor Casing", "Reactor Control Rod")
    reactor.move_up()
    functions.replace_coolant_ports(false)

    functions.run(1)
    constants.robot.turnRight()
    functions.run(8)
    constants.robot.turnRight()
    turbines.build_turbine()

    constants.robot.turnLeft()
    functions.run(6)
    constants.robot.turnLeft()
    functions.run(3)
    constants.robot.turnLeft()
    for _ = 1, 16 do functions.repeat_swing("down") end
    turbines.build_turbine() --возможно, не тут недостающая турбина

    functions.run(8)
    constants.robot.turnLeft()
    functions.run(16)
    constants.robot.turnRight()
    functions.repeat_swing("down") --если недостающая турбина там, значит тут должен быть цикл
    turbines.build_turbine()

    constants.robot.turnAround()
    functions.run(3)
    constants.robot.turnRight()
    functions.run(6)
    constants.robot.turnAround()
    for _ = 1, 16 do functions.repeat_swing("down") end
    turbines.build_turbine()
end

main()
