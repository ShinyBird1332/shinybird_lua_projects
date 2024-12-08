local constants = dofile("constants.lua")
local functions = dofile("functions.lua")
local reactor = dofile("reactor.lua")
local turbines = dofile("turbines.lua")

function main()

--изначально сундук стоит сзади, чтоб если чего-то не хватает, было проще добавлять
--турбины не едят уголь, надо доработать!
--не уверен, но третья турбина просто куда-то пропала
--неправильно располагаются порты охлаждения!
--1 - все ок
--2 - порты на 1 правее должны быть
--3 - порты на 1 дальше
--4 - порты на 1 правее и на 1 дальше
--надо реализовать авто заправку: если заряда меньше 10% ставим энергокуб, выше зарядник, где-то рядом красный камень или как-то с ключом решить, выше робот
--или поискать еще блоки, которые заряжают робота!

    --if not functions.check_kit_start() then return end --проверяем наличие ресурсов для постройки реактора
    --print("Проверка ресурсов для реактора: Успешно!")
    --reactor.build_floor() --строим пол реактора
    --reactor.move_up() -- переходим в начало координат постройки и на 1 выше
    --reactor.filling_or_roof_reactor("криотеум", "Yellorium Fuel Rod", "Reactor Access Port", "Reactor Controller") --строим второй уровень реактора
    --reactor.move_up() -- переходим в начало координат постройки и на 1 выше
    --reactor.filling_or_roof_reactor("Reactor Casing", "Reactor Control Rod") -- строим крышу реактора

    --reactor.move_up()
    --functions.replace_coolant_ports() 
    --functions.repeat_swing("forward)
    --constants.robot.turnRight()
    --for i = 1, 8 do functions.repeat_swing("forward") end
    --constants.robot.turnRight()

    local function t()
        functions.repeat_swing("up")
        turbines.build_floor()
    
        constants.robot.turnLeft()
        for i = 1, 7 do functions.repeat_swing("forward") end
        constants.robot.turnRight()
    
        turbines.build_walls()
    
        for i = 1, 3 do functions.repeat_swing("forward") end
        constants.robot.turnRight()
        for i = 1, 3 do functions.repeat_swing("forward") end
        for i = 1, 15 do functions.repeat_swing("down") end
    
        turbines.build_rotor()
    
        functions.repeat_swing("forward")
        for i = 1, 14 do functions.repeat_swing("down") end
        constants.robot.turnLeft()
        functions.repeat_swing("forward")
        constants.robot.turnLeft()
    
        turbines.build_coil()
    
        functions.repeat_swing("forward")
        constants.robot.turnRight()
    
        turbines.build_rotor_blade()
    
        constants.robot.turnRight()
        for i = 1, 2 do functions.repeat_swing("forward") end
        constants.robot.turnRight()
    
        turbines.build_roof()
    end

    --t()

    --constants.robot.turnLeft()
    --for i = 1, 6 do functions.repeat_swing("forward") end
    --constants.robot.turnLeft()
    --for i = 1, 3 do functions.repeat_swing("forward") end
    --constants.robot.turnLeft()
    --for i = 1, 16 do functions.repeat_swing("down") end

    --for i = 1, 8 do functions.repeat_swing("forward") end
    --constants.robot.turnLeft()
    --for i = 1, 16 do functions.repeat_swing("forward") end
    --constants.robot.turnRight()
    --functions.repeat_swing("down")

    --t()

    constants.robot.turnAround()
    for i = 1, 3 do functions.repeat_swing("forward") end
    constants.robot.turnRight()
    for i = 1, 6 do functions.repeat_swing("forward") end
    constants.robot.turnAround()
    for i = 1, 16 do functions.repeat_swing("down") end

    functions.repeat_swing("down")------------enhfnm!

    t()
end

main()
