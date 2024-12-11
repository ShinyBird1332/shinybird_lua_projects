local turbines = {}

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")

function turbines.build_floor()
    local function build_coolant_row()
        functions.place_block("Turbine Housing")
        functions.run(1)
        functions.place_block("Turbine Fluid Port")
        functions.run(1)

        for _ = 1, 3 do
            functions.place_block("Turbine Housing")
            functions.run(1)
        end

        functions.place_block("Turbine Fluid Port")
        functions.swith_key()
        functions.run(1)
        functions.place_block("Turbine Housing")
        functions.run(1)

        constants.robot.turnAround()
        functions.run(7)
        constants.robot.turnLeft()
        functions.run(1)
        constants.robot.turnLeft()    
    end

    functions.build_row("Turbine Housing", "Turbine Housing", "Turbine Housing", 7)
    build_coolant_row()
    for _ = 1, 5 do
        functions.build_row("Turbine Housing", "Turbine Housing", "Turbine Housing", 7)
    end
    functions.clear_inventory()
end

function turbines.build_walls()
    local function buid_wall(i)
        for j = 1, 6 do
            for _ = 1, 16 do
                functions.place_block("Turbine Housing")
                functions.repeat_swing("up")
            end
            functions.run(1)
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
    functions.clear_inventory()
end

function turbines.build_rotor()
    for _ = 1, 14 do
        functions.place_block("Turbine Rotor Shaft")
        functions.repeat_swing("up")
    end
end

function turbines.build_coil()
    for _ = 1, 4 do
        for _ = 1, 4 do
            for _ = 1, 2 do
                functions.place_block("Ludicrite Block")
                functions.run(1)
            end
            constants.robot.turnLeft()
        end
        functions.repeat_swing("up")
    end
end

function turbines.build_rotor_blade()
    local function build_col_rotor()
        for _ = 1, 10 do
            functions.place_block("Turbine Rotor Blade")
            functions.repeat_swing("up")
        end
    end

    for _ = 1, 3 do
        build_col_rotor()
        functions.run(1)
        for _ = 1, 10 do functions.repeat_swing("down") end
        build_col_rotor()
        constants.robot.turnLeft()
        functions.run(2)
        constants.robot.turnLeft()
        functions.run(2)
        constants.robot.turnLeft()
        functions.run(1)
        for _ = 1, 10 do functions.repeat_swing("down") end
        constants.robot.turnAround()
    end
    build_col_rotor()
    functions.run(1)
    for _ = 1, 10 do functions.repeat_swing("down") end
    build_col_rotor()
end

function turbines.build_roof()
    for _ = 1, 2 do
        functions.build_row("Turbine Housing", "Turbine Housing", "Turbine Housing", 5)
    end

    functions.place_block("Turbine Housing")
    functions.run(1)
    functions.place_block("Turbine Controller")
    functions.run(1)
    functions.place_block("Turbine Rotor Bearing")
    functions.run(1)
    functions.place_block("Turbine Power Port")
    functions.run(1)
    functions.place_block("Turbine Housing")
    functions.run(1)

    functions.end_build_row(5)

    for _ = 1, 2 do
        functions.build_row("Turbine Housing", "Turbine Housing", "Turbine Housing", 5)
    end
end

function turbines.build_turbine()
    functions.repeat_swing("up")
    turbines.build_floor()

    constants.robot.turnLeft()
    functions.run(7)
    constants.robot.turnRight()

    turbines.build_walls()

    functions.run(3)
    constants.robot.turnRight()
    functions.run(3)
    for _ = 1, 15 do functions.repeat_swing("down") end

    turbines.build_rotor()

    functions.run(1)
    for _ = 1, 14 do functions.repeat_swing("down") end
    constants.robot.turnLeft()
    functions.run(1)
    constants.robot.turnLeft()

    turbines.build_coil()

    functions.run(1)
    constants.robot.turnRight()

    turbines.build_rotor_blade()

    constants.robot.turnRight()
    functions.run(2)
    constants.robot.turnRight()

    turbines.build_roof()
end

return turbines