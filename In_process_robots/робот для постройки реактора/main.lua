local constants = dofile("constants.lua")
local functions = dofile("functions.lua")
local reactor = dofile("reactor.lua")
local turbines = dofile("turbines.lua")

function main()
    --if not functions.check_kit_start() then return end --проверяем наличие ресурсов для постройки реактора
    --print("Проверка ресурсов для реактора: Успешно!")
    --reactor.build_floor() --строим пол реактора
    --reactor.move_up() -- переходим в начало координат постройки и на 1 выше
    --reactor.filling_or_roof_reactor("криотеум", "Yellorium Fuel Rod", "Reactor Access Port", "Reactor Controller") --строим второй уровень реактора
    --reactor.move_up() -- переходим в начало координат постройки и на 1 выше
    --reactor.filling_or_roof_reactor("Reactor Casing", "Reactor Control Rod") -- строим крышу реактора

    --reactor.move_up()
    --functions.replace_coolant_ports() 
    --functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
    --constants.robot.turnRight()
    --for i = 1, 8 do functions.repeat_swing(table.unpack(constants.actions["func_forward"])) end
    --constants.robot.turnRight()
    --после постройки реактора, надо сделать функцию выброски лишних блоков обратно в сундук
    --или сделать так, чтоб лизних блоков и не было?

    functions.repeat_swing(table.unpack(constants.actions["func_up"]))
    turbines.build_floor()


    --дальше - турбина
    --турбина 7х7х16

end

local function main_test()

end

--main_test()

main()
