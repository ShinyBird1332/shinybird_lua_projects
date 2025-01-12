local reactor = {}

local constants = dofile("constants.lua")
local functions = dofile("functions.lua")

function reactor.build_floor()
    for _ = 1, constants.SIZE do
        for _ = 1, constants.SIZE do
            functions.place_block("Reactor Casing")
            functions.repeat_swing("forward")
        end
        functions.end_build_row(constants.SIZE)
    end
    constants.robot.turnLeft() 
    functions.run(constants.SIZE)
    constants.robot.turnRight()
    functions.repeat_swing("up")
end

function reactor.build_walls()
    local function buid_wall(i)
        for j = 1, constants.SIZE - 1 do
            for _ = 1, 31 do
                functions.place_block("Reactor Casing")
                functions.repeat_swing("up")
            end
            functions.run(1)
            if i ~= 4 or j ~= constants.SIZE - 1 then
                for _ = 1, 31 do
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

function reactor.build_rods()
    --хз, вернется ли он на начало, потом доделаю тут
    --предположим, он уже на нужных кордах
    for _ = 1, 7 do
        for _ = 1, constants.SIZE - 2 do
            for _ = 1, 30 do
                functions.place_block("Yellorium Fuel Rod")
                functions.repeat_swing("up")
            end
            for _ = 1, 30 do functions.repeat_swing("down") end
            functions.repeat_swing("forward")
        end
    
        constants.robot.turnAround()
        functions.run(constants.SIZE - 2)
        constants.robot.turnLeft()
        functions.run(2)
        constants.robot.turnLeft()
    end --на этот моменте делаются только стержни 
    
end

return reactor