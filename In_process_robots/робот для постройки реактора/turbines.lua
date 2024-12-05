local turbines = {}

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")

function turbines.build_walls()
    local function buid_wall()
        for _ = 1, 6 do
            for _ = 1, 15 do
                functions.place_block("Turbine Housing")
                functions.repeat_swing(table.unpack(constants.actions["func_up"]))
            end
            functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
            for _ = 1, 16 do
                functions.repeat_swing(table.unpack(constants.actions["func_down"]))
            end
        end
    end
    for _ = 1, 4 do
        buid_wall()
        constants.robot.turnRight()
    end
end

function turbines.build_floor()
    local function build_row_floor()
        for _ = 1, 3 do
            for _ = 1, 7 do
                functions.place_block("Turbine Housing")
                functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
            end
            constants.robot.turnAround()
            for _ = 1, 7 do
                functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
            end
            constants.robot.turnLeft()
            functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
            constants.robot.turnLeft()
        end
    end
    local function build_rotor()
        for _ = 1, 3 do
            functions.place_block("Turbine Housing")
            functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
        end
        functions.place_block("Turbine Rotor Bearing")
        functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
        for _ = 1, 3 do
            functions.place_block("Turbine Housing")
            functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
        end
        constants.robot.turnAround()
        for _ = 1, 7 do
            functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
        end
        constants.robot.turnLeft()
        functions.repeat_swing(table.unpack(constants.actions["func_forward"]))
        constants.robot.turnLeft()      
    end
    build_row_floor()
    build_rotor()
    build_row_floor()
end






function turbines.build_base2(x_start, y_start)
    for x = x_start, x_start + 6 do
        for y = y_start, y_start + 6 do
            constants.robot.goTo(x, y, 1) -- Переместиться к точке
            functions.place_block("Turbine Casing")
        end
    end
    
end

function turbines.build_shaft(x_center, y_center, z_start)
    for z = z_start, z_start + 14 do
        constants.robot.goTo(x_center, y_center, z) -- Переместиться к точке
        functions.place_block("Turbine Shaft")
    end
end

function turbines.add_rotor_blades(x_center, y_center, z_start)
    for z = z_start + 1, z_start + 13, 3 do
        for offset = -1, 1, 2 do
            constants.robot.goTo(x_center + offset, y_center, z) -- Левая и правая стороны
            functions.place_block("Turbine Rotor Blade")
            constants.robot.goTo(x_center, y_center + offset, z) -- Верх и низ
            functions.place_block("Turbine Rotor Blade")
        end
    end
end

function turbines.add_coolant_ports(x_start, y_start, z_start)
    for _, pos in pairs(constants.coolant_positions) do
        local x, y = pos[1] + x_start - 1, pos[2] + y_start - 1
        constants.robot.goTo(x, y, z_start)
        functions.place_block("Turbine Coolant Port")
        functions.swith_key() -- Меняем режим порта
    end
end

function turbines.build_roof(x_start, y_start, z_top)
    for x = x_start, x_start + 6 do
        for y = y_start, y_start + 6 do
            constants.robot.goTo(x, y, z_top) -- Переместиться к точке
            functions.place_block("Turbine Casing")
        end
    end
end

function turbines.build_turbine(x_start, y_start, z_start)
    -- Построить основание
    turbines.build_base()

    -- Установить охлаждающие порты
    turbines.add_coolant_ports(x_start, y_start, z_start)

    -- Построить вал
    turbines.build_shaft(x_start + 3, y_start + 3, z_start + 1)

    -- Добавить лопасти ротора
    turbines.add_rotor_blades(x_start + 3, y_start + 3, z_start + 1)

    -- Построить крышу
    turbines.build_roof(x_start, y_start, z_start + 15)
end


return turbines