local turbines = {}

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")

function turbines.build_walls()
    local function buid_wall(i)
        for j = 1, 6 do
            for _ = 1, 16 do
                functions.place_block("Turbine Housing")
                functions.repeat_swing("up")
            end
            functions.repeat_swing("forward")
            if i ~= 4 or j ~= 6 then
                for _ = 1, 16 do
                    functions.repeat_swing("down")
                end
            end
        end
    end
    for i = 1, 4 do
        buid_wall(i)
        constants.robot.turnRight()
    end
end

function turbines.build_row_floor(iter)
    for _ = 1, iter do
        functions.place_block("Turbine Housing")
        functions.repeat_swing("forward")
    end
    constants.robot.turnAround()
    for _ = 1, iter do
        functions.repeat_swing("forward")
    end
    constants.robot.turnLeft()
    functions.repeat_swing("forward")
    constants.robot.turnLeft()
end

function turbines.build_floor()
    local function build_coolant_row()
        functions.place_block("Turbine Housing")
        functions.repeat_swing("forward")

        functions.place_block("Turbine Fluid Port")
        functions.repeat_swing("forward")

        for _ = 1, 3 do
            functions.place_block("Turbine Housing")
            functions.repeat_swing("forward")
        end

        functions.place_block("Turbine Fluid Port")
        functions.swith_key()
        functions.repeat_swing("forward")


        functions.place_block("Turbine Housing")
        functions.repeat_swing("forward")

        constants.robot.turnAround()
        for _ = 1, 7 do
            functions.repeat_swing("forward")
        end
        constants.robot.turnLeft()
        functions.repeat_swing("forward")
        constants.robot.turnLeft()    
    end

    turbines.build_row_floor(7)
    build_coolant_row()
    for _ = 1, 5 do
        turbines.build_row_floor(7)
    end
end

function turbines.build_rotor()
    for i = 1, 14 do
        functions.place_block("Turbine Rotor Shaft")
        functions.repeat_swing("up")
    end
    
end

function turbines.build_coil()
    local function t()
        for _ = 1, 4 do
            for j = 1, 2 do
                functions.place_block("Ludicrite Block")
                functions.repeat_swing("forward")
            end
            constants.robot.turnLeft()
        end
        functions.repeat_swing("up")
    end
    for i = 1, 4 do
        t()
    end
    
end

function turbines.build_rotor_blade()
    local function t()
        for i = 1, 10 do
            functions.place_block("Turbine Rotor Blade")
            functions.repeat_swing("up")
        end
    end

    for i = 1, 3 do
        t()
        functions.repeat_swing("forward")
        for i = 1, 10 do functions.repeat_swing("down") end
        t()
        constants.robot.turnLeft()
        for i = 1, 2 do functions.repeat_swing("forward") end
        constants.robot.turnLeft()
        for i = 1, 2 do functions.repeat_swing("forward") end
        constants.robot.turnLeft()
        functions.repeat_swing("forward")
        for i = 1, 10 do functions.repeat_swing("down") end
        constants.robot.turnAround()
    end
    t()
    functions.repeat_swing("forward")
    for i = 1, 10 do functions.repeat_swing("down") end
    t()
end

function turbines.build_roof()
    for _ = 1, 2 do
        turbines.build_row_floor(5)
    end

    functions.place_block("Turbine Housing")
    functions.repeat_swing("forward")
    functions.place_block("Turbine Controller")
    functions.repeat_swing("forward")
    functions.place_block("Turbine Rotor Bearing")
    functions.repeat_swing("forward")
    functions.place_block("Turbine Power Port")
    functions.repeat_swing("forward")
    functions.place_block("Turbine Housing")
    functions.repeat_swing("forward")

    constants.robot.turnAround()
    for _ = 1, 5 do
        functions.repeat_swing("forward")
    end
    constants.robot.turnLeft()
    functions.repeat_swing("forward")
    constants.robot.turnLeft()

    for _ = 1, 2 do
        turbines.build_row_floor(5)
    end
end

--ротор
--

return turbines